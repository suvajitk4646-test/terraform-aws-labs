output "peering_connection_id" {
  description = "The ID of the cross-region VPC peering connection"
  value       = aws_vpc_peering_connection.requester.id
}

output "peering_status" {
  description = "The status of the peering connection"
  value       = aws_vpc_peering_connection.requester.accept_status
}

# --- Primary Region (us-east-1) Outputs ---
output "primary_vpc_id" {
  description = "The ID of the Primary VPC"
  value       = aws_vpc.primary_VPC.id
}

output "primary_instance_id" {
  description = "The ID of the Primary EC2 Instance"
  value       = aws_instance.instance_primary.id
}

output "primary_instance_private_ip" {
  description = "The Private IP of the Primary EC2 Instance (for testing connectivity)"
  value       = aws_instance.instance_primary.private_ip
}

# --- Secondary Region (us-west-2) Outputs ---
output "secondary_vpc_id" {
  description = "The ID of the Secondary VPC"
  value       = aws_vpc.secondary_VPC.id
}

output "secondary_instance_id" {
  description = "The ID of the Secondary EC2 Instance"
  value       = aws_instance.instance_secondary.id
}

output "secondary_instance_private_ip" {
  description = "The Private IP of the Secondary EC2 Instance (for testing connectivity)"
  value       = aws_instance.instance_secondary.private_ip
}