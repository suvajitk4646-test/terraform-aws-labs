terraform {
  backend "s3" {
    bucket         = "suva4646-backendtfstate" # You must create this bucket in AWS first!
    key            = "lab/terraform.tfstate"                     # The path/folder inside the bucket
    region         = "us-east-1"
    
    # Optional but highly recommended for teams:
    # dynamodb_table = "terraform-state-locks"                   # Prevents two people from applying at the same time
     encrypt        = true                                      # Encrypts the state file at rest
  }
}
provider "aws" {
  region = var.aws_region
}
locals {
  bucket_name = "suva4646-${var.environment}"
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "TF-Learning-Lab"
  }
}
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${var.environment}-vpc"
  })
}
resource "aws_s3_bucket" "data_bucket" {
  bucket = local.bucket_name
  tags   = local.common_tags
}
