resource "aws_vpc" "VPC_Web_DB" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
region = "us-east-1"
enable_dns_hostnames = true
enable_dns_support = true
  tags = {
    Name = "VPC_Web_DB"
  }
}
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC_Web_DB.id

  tags = {
    Name = "IGW"
  }
}
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.VPC_Web_DB.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet"
  }
}
resource "aws_subnet" "private_1a" {
  vpc_id     = aws_vpc.VPC_Web_DB.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_subnet_1a"
  }
}
resource "aws_subnet" "private_1b" {
  vpc_id     = aws_vpc.VPC_Web_DB.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_subnet_1b"
  }
}
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.VPC_Web_DB.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
}
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rtb.id
}