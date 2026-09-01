data "aws_ami" "amazon_linux" {
 most_recent      = true
 owners           = ["amazon"]
 

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_security_group" "soc_sg" {
  name        = "${var.server_name}-sg"
  description = "Dynamic SOC Firewall Rules"
 
 dynamic "ingress" {
   for_each = var.ingress_rules
   content {
     description = ingress.value.description
      from_port = ingress.value.port
      to_port = ingress.value.port
      protocol    = "tcp"
       cidr_blocks = ["0.0.0.0/0"]
   }
 }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "soc_node" {
  ami       = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.soc_sg.id]
tags = {
  Name = var.server_name
}
 
}