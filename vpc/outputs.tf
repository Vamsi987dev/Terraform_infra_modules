output "vpc_id" {
    value = aws_vpc.main.id
}

output "azs" {
    value = data.aws_availability_zones.available.names
}

output "default_vpc_info" {
    value = data.aws_vpc.default
}

output "default_vpc_route_table_info" {
    value = data.aws_route_tables.main
}