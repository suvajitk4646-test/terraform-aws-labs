output "server_public_ip" {
  value = aws_instance.soc_node.public_ip
  description = "The public IP of the SOC server"
}