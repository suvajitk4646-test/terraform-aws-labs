variable "environment" {
  type = string
  default = "ProDUCTIoN"
}
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}
variable "soc_team" {
  type = list(string)
  default = [ "bob","alice","xoxo" ]
}
variable "admin_user" {
  type = string
  default = "alice"
}
variable "ami-id" {
  type = string
  description = "AMI ID to deploy"
  validation {
    condition = can(regex("^ami-",var.ami-id))
    error_message = "The image must be a valid AMI ID"
  }
}
variable "port-number" {
  type = string
  default = "8080"
}
variable "db_instance_class" {
  type = string
  default = "db.t3.medium"
  validation {
    condition = contains(["db.t3.micro","db.t3.medium"],var.db_instance_class)
    error_message = "Choose correct instance type"
  }
}
