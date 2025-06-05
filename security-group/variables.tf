variable "project_name" {
    type = string
}
variable "environment" {
    type = string
}
variable "sg_name" {
    type = string
}
variable "sg_tags" {
    type = map
    default = {}
}

variable "vpc_id" {

}

variable "common_tags" {
  default = {
    Project     = "Expense"
    Environment = "Dev"
    Terraform   = "True"
  }
}