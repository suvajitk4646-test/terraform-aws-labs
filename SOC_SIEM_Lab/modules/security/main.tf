resource "aws_security_group" "spoke_web_sg" {
  description = "Allow HTTP/HTTPS from anywhere"
 vpc_id      = var.spoke_vpc_id

  tags = {
    Name = "spoke_web_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.spoke_web_sg.id
   cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.spoke_web_sg.id
   cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.spoke_web_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
resource "aws_security_group" "spoke_db_sg" {
  description = "Allow HTTP/HTTPS from anywhere"
 vpc_id      = var.spoke_vpc_id
ingress {
  from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
  security_groups = [aws_security_group.spoke_web_sg.id] # Fixed SG reference
}
 egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "spoke_db_sg"
  }
}
resource "aws_security_group" "hub_siem_sg" {
  description = "Hub SIEM Security Group for Wazuh"
  vpc_id      = var.hub_vpc_id

  tags = {
    Name = "hub_siem_sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "siem_admin_ingress" {
    for_each = toset(["22","443"])
  security_group_id = aws_security_group.hub_siem_sg.id
   cidr_ipv4         = "0.0.0.0/0"
  from_port         = tonumber(each.value)
  ip_protocol       = "tcp"
  to_port           = tonumber(each.value)
}
resource "aws_vpc_security_group_ingress_rule" "siem_agent_ingress" {
  for_each = toset(["1514", "1515"])

  security_group_id = aws_security_group.hub_siem_sg.id
  cidr_ipv4         = "10.1.0.0/16" # Matches your vpc_spoke CIDR block
  ip_protocol       = "tcp"
  from_port         = tonumber(each.value)
  to_port           = tonumber(each.value)
}

resource "aws_vpc_security_group_egress_rule" "siem_all_outbound" {
  security_group_id = aws_security_group.hub_siem_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
resource "random_password" "db_password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
resource "random_string" "suffix" {
  length = 4
  special = false
}
resource "aws_secretsmanager_secret" "db_secret" {
  name = "mysql-rds-creds-${random_string.suffix.result}"
}
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
  })
}
resource "aws_iam_policy" "boundary" {
  name        = "Web-Strict-Boundary"
  description = "Limits Web Server to log publishing"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = ["cloudwatch:PutLogEvents", "cloudwatch:CreateLogStream", "s3:PutObject", "secretsmanager:GetSecretValue"], Effect = "Allow", Resource = "*" }]
  })
}

resource "aws_iam_role" "web_role" {
  name                 = "spoke-web-role"
  permissions_boundary = aws_iam_policy.boundary.arn
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_policy" {
  role       = aws_iam_role.web_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "web_profile" {
  name = "spoke-web-profile"
  role = aws_iam_role.web_role.name
}