output "deployed_environment" {
  description = "The environment that was just deployed"
  value       = var.environment
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.data_bucket.id
}