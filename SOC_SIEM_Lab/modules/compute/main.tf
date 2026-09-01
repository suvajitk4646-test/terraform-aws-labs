data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# The Wazuh Manager (SIEM Node)
resource "aws_instance" "siem" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.medium"
  subnet_id              = var.hub_pub_subnet_id
  vpc_security_group_ids = [var.siem_sg_id]
  private_ip             = var.siem_private_ip

  user_data = <<-EOF
              #!/bin/bash
              # Download the Wazuh installation assistant
              curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
              # Execute the unattended installation script
              bash wazuh-install.sh -a
              EOF

  tags = { Name = "Hub-Wazuh-SIEM" }
}

# The Web Server (Sender Node)
resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = var.spoke_pub_subnet_id
  vpc_security_group_ids = [var.web_sg_id]
  iam_instance_profile   = var.iam_instance_profile_name

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              # Install dependencies required by Wazuh
              apt-get install -y python3-pip python3-flask awscli curl apt-transport-https lsb-release gnupg

              # Add Wazuh repository key and source list
              curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor -o /usr/share/keyrings/wazuh.gpg
              echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee /etc/apt/sources.list.d/wazuh.list
              apt-get update
              
              # Install and configure the Wazuh Agent to report back to the SIEM IP via Peering Connection
              WAZUH_MANAGER="${var.siem_private_ip}" apt-get install wazuh-agent -y
              systemctl daemon-reload
              systemctl enable wazuh-agent
              systemctl start wazuh-agent
              EOF

  tags = { Name = "Spoke-Web-Server" }
  depends_on = [aws_instance.siem]
}