# 1.String
variable "project_name" {
    description = "The name of the project"
    type = string
}
#2.Boolean
variable "create_users" {
 description = "Should we create IAM users"
 type = bool
 default = false
}
#3.List of strings
variable "IAM_User_Names" {
description = "A list of usernames to create"
type = list(string)
}
#4.Map of Strings
variable "project_tags" {
    description = "Project tagged to a certain group of users"
    type = map(string)
}
#5.Object creation
variable "server_config" {
    description = "Server Configuration"
    type = object({
        port = number
        protocol = string
        enable_encryption = bool
    })
}