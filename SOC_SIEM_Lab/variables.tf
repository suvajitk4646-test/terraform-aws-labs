variable "my_ip" {
  description = "IP CIDR allowed for SIEM admin access"
  type        = string
  default     = "0.0.0.0/0" # Allows access from anywhere, or set to your preferred CIDR
}