resource "aws_vpc" "foundational_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Basic-Terraform-VPC"
    Environment = "Dev"
  }
}