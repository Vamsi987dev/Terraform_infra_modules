locals {
    resource_name = "${lower(var.project_name)}-${lower(var.environment)}"
    azs = slice(data.aws_availability_zones.available.names,0,length(var.public_subnet_cidrs))
    cidr_keys         = keys(var.public_subnet_cidrs)
    subnet_az_mapping = zipmap(local.cidr_keys, local.azs)
}