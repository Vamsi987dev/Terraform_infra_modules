resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = var.enable_dns_hostnames
    
    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = local.resource_name
        }
    )
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.igw_tags,
        {
            Name = local.resource_name
        }
    )
}

resource "aws_subnet" "public" {
    for_each = var.public_subnet_cidrs

    cidr_block = each.value
    vpc_id = aws_vpc.main.id
    availability_zone = local.subnet_az_mapping[each.key]
    map_public_ip_on_launch = true
    
    tags = merge(
        var.common_tags,
        var.public_subnet_tags,
        {
            Name = "${var.project_name}-${var.environment}-public-${local.subnet_az_mapping[each.key]}"
        }
    )
     
}

resource "aws_subnet" "private" {
    for_each = var.private_subnet_cidrs

    cidr_block = each.value
    vpc_id = aws_vpc.main.id
    availability_zone = local.subnet_az_mapping[each.key]

    tags = merge(
        var.common_tags,
        var.private_subnet_tags,
        {
            Name = "${var.project_name}-${var.environment}-private-${local.subnet_az_mapping[each.key]}"
        }
    )
     
}

resource "aws_subnet" "database" {
    for_each = var.database_subnet_cidrs

    cidr_block = each.value
    vpc_id = aws_vpc.main.id
    availability_zone = local.subnet_az_mapping[each.key]

    tags = merge(
        var.common_tags,
        var.database_subnet_tags,
        {
            Name = "${var.project_name}-${var.environment}-database-${local.subnet_az_mapping[each.key]}"
        }
    )
     
}

resource "aws_db_subnet_group" "main" {
    name = local.resource_name
    subnet_ids = [for subnet in aws_subnet.database : subnet.id]

    tags = merge(
        var.common_tags,
        var.aws_db_subnet_group_tags,
        {
            Name = "${var.project_name}-${var.environment}-db-subnet-group"
        }
    )
}

resource "aws_eip" "nat" {
    
    domain = "vpc"

}

resource "aws_nat_gateway" "main" {
    
    allocation_id = aws_eip.nat.id
    subnet_id = values(aws_subnet.public)[0].id

    tags = merge(
        var.common_tags,
        var.aws_nat_gateway_tags,
        {
            Name = local.resource_name
        }
    )

    depends_on = [aws_internet_gateway.main]
}

#Route_Tables
 
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.public_route_table_tags,
        {
            Name = "${local.resource_name}-public"
        }
    )
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.private_route_table_tags,
        {
            Name = "${local.resource_name}-private"
        }
    )
}

resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id

    tags = merge(
        var.common_tags,
        var.database_route_table_tags,
        {
            Name = "${local.resource_name}-database"
        }
    )
}

#Route_Table Associations

resource "aws_route_table_association" "public" {
    for_each = aws_subnet.public

    subnet_id = each.value.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
    for_each = aws_subnet.private

    subnet_id = each.value.id
    route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
    for_each = aws_subnet.database

    subnet_id = each.value.id
    route_table_id = aws_route_table.database.id
}


#Routes

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
}

resource "aws_route" "private_nat" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database_nat" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
}

