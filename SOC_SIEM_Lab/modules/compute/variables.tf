variable "spoke_pub_subnet_id" { type = string }
variable "hub_pub_subnet_id" { type = string }
variable "web_sg_id" { type = string }
variable "siem_sg_id" { type = string }
variable "iam_instance_profile_name" { type = string }
variable "siem_private_ip" { 
  type = string
  default = "10.1.1.50" 
}