variable "availability_zones" {
 description = "All the AZ's"
type = list(string)
}
variable "iam_group_names" {
description = "A set of unique IAM group names." 
type = set(string)
}
variable "instance_type" {
description = "The EC2 instance type. Must be a t2 micro or t3 micro."
type = string
validation {
    condition = contains(["t2.micro", "t3.micro"], var.instance_type)
    error_message = "Error: The instance_type must be either 't2.micro' or 't3."
}  
}
variable "database_config" {
    description = "Complex nested database configuration"
    type = object({
        engine = string
        network = object ({
            port = number
            is_public = bool
        })
    })
}