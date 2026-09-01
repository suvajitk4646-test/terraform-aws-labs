provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(local.final_tags, { Name = "${local.project_name}-vpc"})
}
resource "aws_subnet" "web" {
  vpc_id = aws_vpc.main.id
  cidr_block = local.web_subnet
  tags = merge(local.final_tags, {Name = "web-tier"})

}
resource "aws_iam_policy" "read_only" {
  name = "${local.clean_env}-read-only"
  description = "A strict IAM Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["ec2:Describe*", "s3:List*"]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
resource "aws_instance" "bastion" {
  ami           = "ami-0ff8a91507f77f867" 
  instance_type = "t2.micro"
  subnet_id = aws_subnet.web.id
  user_data_base64 =   base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              EOF
  )
  tags = local.final_tags
}
