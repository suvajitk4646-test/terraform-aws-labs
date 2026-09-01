output "processed_iam_groups" {
  description = "Notice how Terraform automatically removed the duplicate 'developers'!"
  value       = var.iam_group_names
}

output "database_port_used" {
  description = "Accessing a nested object value"
  value       = var.database_config.network.port
}