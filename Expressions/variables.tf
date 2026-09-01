variable "environment" {
  type = string
  description = "The type of environment"
  default = "dev"
}
variable "vpc_cidr" {
  type = string
  description = "the CIDR block of the VPC"
  default = "10.0.0.0/16"
}


variable "dns_support_enable" {
  type = bool
  description = " enable/disable DNS support"
}
variable "vpc_tags" {
  type = map(string)
}
 
variable "instance_type" {
  type = list(string)
  description = "All available instance types of Compute Servers"
  default = [ "t2.micro" ]
}
variable "ebs_volume_size" {
  type = object({
    size = number
    
  })
}
