variable "spoke_vpc_cidr" {
  description = "CIDR block for Spoke Web VPC"
  type        = string
}

variable "spoke_pub_cidr" {
  description = "CIDR block for Spoke Public Subnet"
  type        = string
}

variable "spoke_priv_1a_cidr" {
  description = "CIDR block for Spoke Private Subnet A"
  type        = string
}

variable "spoke_priv_1b_cidr" {
  description = "CIDR block for Spoke Private Subnet B"
  type        = string
}

variable "hub_vpc_cidr" {
  description = "CIDR block for Hub SOC VPC"
  type        = string
}

variable "hub_pub_cidr" {
  description = "CIDR block for Hub Public Subnet"
  type        = string
}