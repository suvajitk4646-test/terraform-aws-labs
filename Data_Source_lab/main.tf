resource "aws_vpc" "VPC_ALB" {
  cidr_block = "10.0.0.0/16"
  tags = {
name = "VPC_ALB"
  }
  
}


resource "aws_instance" "bastion" {
  ami = data.aws_ami.latest_linux.id
  instance_type = "t3.micro"
  subnet_id = data.aws_subnets.available.id
tags = {
    name = "SOC-Traffic-Inspector"
}
}
resource "aws_security_group" "allow-port-http" {
  vpc_id = aws_vpc.VPC_ALB.id
  name = "allow-port-http"
  description = "This security group all users from the internet on port 80"
   tags = {
    Name = "allow_http"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow-port-http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

