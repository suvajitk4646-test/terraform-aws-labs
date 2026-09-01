output "spoke_vpc_id" {
  value = aws_vpc.vpc_spoke.id
}

output "hub_vpc_id" {
  value = aws_vpc.vpc_hub.id
}

output "spoke_pub_subnet_id" {
  value = aws_subnet.spoke_subnet_public.id
}

output "hub_pub_subnet_id" {
  value = aws_subnet.hub_subnet_public.id
}

output "spoke_private_subnet_ids" {
  value = [aws_subnet.spoke_subnet_private_a.id, aws_subnet.spoke_subnet_private_b.id]
}