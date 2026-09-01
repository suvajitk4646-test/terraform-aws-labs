data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.web_security_group_id]
  iam_instance_profile   = var.iam_instance_profile_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3-pip python3-flask awscli
              pip3 install boto3 mysql-connector-python
              
              # The EC2 instance now has the AWS CLI and Boto3 installed.
              # Because of the attached IAM profile, your Flask app can use Boto3 
              # to securely query Secrets Manager for the DB password at runtime!
              EOF

  tags = { Name = "Ubuntu-Flask-Web-Server" }
}