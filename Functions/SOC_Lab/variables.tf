variable "environment" {
  type = string
  description = "The type of environment"
  default = "dev"
}
variable "vpc_cidr" {
  type = set(string)
  description = "the CIDR block of the VPC"
  default = [ "10.0.0.0/16" ]
}
variable "network_address_usage" {
  type = bool
  description = "Indicates whether Network Address Usage metrics are enabled for your VPC. Defaults to false"
}
variable "dns_support_enable" {
  type = bool
  description = " enable/disable DNS support"
}
variable "vpc_tags" {
  type = map(string)
  description = "VPC tags"
  default = {
    Name = "Own_VPC"
  }
}
variable "instance_type" {
  type = set(string)
  description = "All available instance types of Compute Servers"
  default = [ "t2.micro" ]
}
variable "ebs_volume_size" {
  type = object({
    size = number
    availibility_zone = string 
  })
  default = {
size = 8
availibility_zone = "us-east-1a"
  } 
}
