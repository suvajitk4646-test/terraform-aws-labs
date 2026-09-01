output "web_sg_id" { value = aws_security_group.web_sg.id }
output "db_sg_id" { value = aws_security_group.db_sg.id }
output "generated_db_password" { value = random_password.db_password.result }
output "web_instance_profile_name" { value = aws_iam_instance_profile.web_profile.name }