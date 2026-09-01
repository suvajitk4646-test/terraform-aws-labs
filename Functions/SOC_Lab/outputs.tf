output "active_log_bucket" {
 description = "Global unique name for SOC logging bucket" 
 value = aws_s3_bucket.forensic_logs.id
}
output "provisioned_analysts" {
  description = "List of IAM users created for the team"
  value = [for user in aws_iam_user.team : user.name]
}