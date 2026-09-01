variable "spoke_vpc_id" {
  description = "ID of the Spoke VPC"
  type        = string
}

variable "hub_vpc_id" {
  description = "ID of the Hub VPC"
  type        = string
}

variable "spoke_vpc_cidr" {
  description = "CIDR block of the Spoke VPC"
  type        = string
}

variable "my_ip" {
  description = "Your home public IP address with /32 prefix"
  type        = string
}