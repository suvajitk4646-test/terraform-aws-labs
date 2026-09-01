variable "server_name" {
  description = "The Name of the SOC Server"
type = string
}

variable "ingress_rules" {
  description = "A map of objects for FW rules"
  type = map(object({
    port = number
    description = string
  }))
}
variable "instance_type" {
  type = string
  default = "t3.micro"
}