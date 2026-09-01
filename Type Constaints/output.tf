output "server_port_used" {
  description = "Showing how to access a specific value inside an object"
  # We access object properties using a dot (.)
  value = var.server_config.port 
}

output "created_user_arns" {
  description = "The ARNs of all created users"
  value       = aws_iam_user.developers[*].arn
}