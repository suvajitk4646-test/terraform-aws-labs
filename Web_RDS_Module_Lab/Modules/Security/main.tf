resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Allow HTTP/S"
  }
  ingress  {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "db_sg" {
  name        = "rds-db-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Allow traffic from Web server"
  }
  ingress  {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups =  [aws_security_group.web_sg.id]
  }
}
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
resource "aws_secretsmanager_secret" "db_secret" {
 name = "mysql-rds-credentials-${random_string.suffix.result}"
}
resource "aws_secretsmanager_secret_version" "example" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.db_password.result
  })
}
resource "aws_iam_role" "web_role" {
  name = "web-secrets-role"
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
  name = "web-instance-profile"
  role = aws_iam_role.web_role.name
}
resource "random_string" "suffix" {
  length  = 4
  special = false
}