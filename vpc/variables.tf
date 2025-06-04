variable "project_name" {
    type = string
}
variable "environment" {
    type = string
}

variable "vpc_cidr" {
    #default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
    type = map(string)
}
variable "private_subnet_cidrs" {
    type = map(string)
}

variable "database_subnet_cidrs" {
    type = map(string)
}

variable "enable_dns_hostnames" {
    default = true
}

variable "common_tags" {
    default = {}
}

variable "vpc_tags" {
    default = {}
}

variable "igw_tags" {
    default = {}
}

variable "public_subnet_tags" {
    default = {}
}
variable "private_subnet_tags" {
    default = {}
}
variable "database_subnet_tags" {
    default = {}
}
variable "aws_db_subnet_group_tags" {
    default = {}
}
variable "aws_nat_gateway_tags" {
    default = {}
}

variable "public_route_table_tags" {
    default = {}
}
variable "private_route_table_tags" {
    default = {}
}
variable "database_route_table_tags" {
    default = {}
}

variable "is_peering_required" {
    type = bool
    default = false
}

variable "vpc_peering_tags" {
    default = {}
}

