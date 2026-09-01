provider "aws" {
  region = "us-east-1"
}
#1. DATA SOURCE (Reading the Cloud)
# We need our AWS Account ID so we can make a globally unique S3 bucket name.
# We didn't create the AWS Account via Terraform, so we use 'data' to read it.
data "aws_caller_identity" "current" {  }
# 2. LOCALS (Internal Calculators)
# We use locals to construct complex strings and standardize our tags so we 
# don't have to type them out multiple times later.
locals {
  forensic_bucket_name = "soc-threat-logs-${var.environment}-${data.aws_caller_identity.current.account_id}"


baseline_tags = {
    Environemt = var.environment
    Department = "Security Operations"
    Managed_By = "Terraform"
}
}
#3. META-ARGUMENT: for_each (The Smart Loop)
# We loop through our variable set to create the IAM user

resource "aws_iam_user" "team" {
  for_each = var.soc_analysts
  name = each.value
  tags = local.baseline_tags
}
resource "aws_s3_bucket" "forensic_logs" {
  bucket = local.forensic_bucket_name
  tags = local.baseline_tags

  # Ensures no one can accidentally delete this bucket during an incident investigation
  lifecycle {
    prevent_destroy = true 
  }
}