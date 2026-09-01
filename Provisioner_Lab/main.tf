provider "aws" {
  region = "us-east-1"
}

# 1. Generate a secure key within Terraform
resource "tls_private_key" "lab_key" {
  algorithm = "ED25519"
}

# 2. Save the private key to a local file so the connection block can read it
resource "local_file" "private_key_file" {
  content         = tls_private_key.lab_key.private_key_openssh
  filename        = "provisioner-key"
  file_permission = "0600"
}

# 3. Upload the public key to AWS
resource "aws_key_pair" "lab_key" {
  key_name   = "provisioner-lab-key-v3"
  public_key = tls_private_key.lab_key.public_key_openssh
}

# --- Networking (Kept exactly as before) ---
resource "aws_vpc" "lab_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.lab_vpc.id
}

resource "aws_subnet" "lab_subnet" {
  vpc_id                  = aws_vpc.lab_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_route_table" "lab_rt" {
  vpc_id = aws_vpc.lab_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_igw.id
  }
}

resource "aws_route_table_association" "lab_rta" {
  subnet_id      = aws_subnet.lab_subnet.id
  route_table_id = aws_route_table.lab_rt.id
}

# --- Security & Instance ---
resource "aws_security_group" "web_sg" {
  name        = "provisioner_web_sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.lab_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.lab_key.key_name
  
  subnet_id              = aws_subnet.lab_subnet.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.lab_key.private_key_openssh
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > server_ip.txt"
  }
}