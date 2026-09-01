resource "aws_db_subnet_group" "rds_subnet" {
  name       = "spoke-rds-subnet-group"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "mysql" {
  allocated_storage        = 20
  engine                   = "mysql"
  engine_version           = "8.0"
  instance_class           = "db.t3.micro"
  db_name                  = "flaskappdb"
  username                 = "admin"
  password                 = var.db_password
  db_subnet_group_name     = aws_db_subnet_group.rds_subnet.name
  vpc_security_group_ids   = [var.db_security_group_id]
  skip_final_snapshot      = true
  delete_automated_backups = true
}