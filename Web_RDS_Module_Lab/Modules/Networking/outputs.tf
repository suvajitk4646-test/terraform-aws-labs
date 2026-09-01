output "vpc_id" {
  value = aws_vpc.VPC_Web_DB.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_ids" {
  value = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}