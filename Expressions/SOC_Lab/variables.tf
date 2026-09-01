variable "environment" {
  type = string
  description = "the deployment variable dev or prod"
}
variable "soc_analysts" {
  type = set(string)
  description = "A unique usernames for threat hunting team"
}
