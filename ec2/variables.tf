variable "ami" {
    type = string
}
variable "instance_type" {
    type = string
    validation {
        condition     = contains(["t2.micro", "t3.micro", "t3.small"], var.instance_type)
        error_message = "Allowed values: t2.micro, t3.micro, t3.small"
    } 
}
variable "vpc_security_group_ids" {
    type = list(string)
}
variable "tags" {
    type = map
}
