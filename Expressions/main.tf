
resource "aws_vpc" "My-VPC" {
  cidr_block = var.vpc_cidr
enable_dns_support = var.dns_support_enable
tags = var.vpc_tags


  
}
resource "aws_subnet" "primary" {
  vpc_id = aws_vpc.My-VPC.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_instance" "instance_opt" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = var.instance_type[0]
  subnet_id = aws_subnet.primary.id
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = var.ebs_volume_size.size
  }

}