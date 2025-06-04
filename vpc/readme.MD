# TERRAFORM AWS VPC MODULE
--------------------------

This Terraform module provisions a VPC with public, private, and database subnets, including Internet Gateway, NAT Gateway, Route Tables, Subnet Groups, and optional VPC Peering.

# RESOURCES CREATED
--------------------
# VPC AND NETWORKING
--------------------

aws_vpc.main                       — Creates the main VPC with DNS hostname support.

aws_internet_gateway.main          — Provides internet access to the public subnet.

aws_subnet.public/private/database — Creates subnets categorized as public, private, and database across AZs.

aws_nat_gateway.main               — NAT Gateway in the public subnet for internet access from private subnets.

aws_eip.nat                        — Elastic IP attached to the NAT Gateway.

# ROUTING
---------

aws_route_table.public/private/database              — Route tables specific for subnet types.

aws_route_table_association.public/private/database  — Associates subnets with their route tables.

aws_route.public                                     — Route to the Internet Gateway for public subnet.

aws_route.private_nat/database_nat                   — Routes to NAT Gateway for private and database subnets.


# DATABASE
----------

aws_db_subnet_group.main — Subnet group for RDS instances using database subnets.

# VPC PEERING (OPTIONAL)
------------------------

aws_vpc_peering_connection.main                                           — Peering connection with the default VPC (optional).

aws_route.public_peering/private_peering/database_peering/default_peering — Routes for peering traffic.

# VARIABLES
-----------

# Name	                  -               Type	                 -              Description
project_name              -	              string	             -              Name of the project (used in resource naming)
environment	              -               string	             -              Deployment environment (e.g., dev, prod)
vpc_cidr                  -	              string	             -              CIDR block for the VPC
public_subnet_cidrs       -	              map(string)	         -              CIDRs for public subnets
private_subnet_cidrs      -	              map(string)            - 	            CIDRs for private subnets
database_subnet_cidrs     -	              map(string)            - 	            CIDRs for database subnets
enable_dns_hostnames      -	              bool	                 -              Enable DNS hostnames in VPC (default true)
common_tags               -	              map                    - 	            Common tags applied to all resources
vpc_tags                  -	              map	                 -              Tags specific to the VPC
igw_tags                  -	              map	                 -              Tags for Internet Gateway
public_subnet_tags        -	              map                    -	            Tags for public subnets
private_subnet_tags       -	              map	                 -              Tags for private subnets
database_subnet_tags      -	              map	                 -              Tags for database subnets
aws_db_subnet_group_tags  -	              map                    -	            Tags for DB subnet group
aws_nat_gateway_tags      -	              map                    -	            Tags for NAT Gateway
public_route_table_tags   -	              map                    -	            Tags for public route tables
private_route_table_tags  -	              map	                 -              Tags for private route tables
database_route_table_tags -	              map                    -	            Tags for database route tables
is_peering_required	      -               bool                   -	            Whether to create VPC peering with default VPC
vpc_peering_tags          - 	          map                    -	            Tags for VPC peering connection


# OUTPUTS
----------

# Name	                       -           Description
vpc_id	                       -          ID of the created VPC
azs	                           -        List of available Availability Zones
default_vpc_info               -     	Information about the default VPC
default_vpc_route_table_info   -  	Information about default VPC route tables

# Notes
-------
Subnet AZ mapping         : The module automatically maps subnets to Availability Zones based on the order of the CIDRs provided.

VPC Peering               : If enabled (is_peering_required = true), the module will create a peering connection with the default VPC and add routes accordingly.

Tagging                   : Resources are tagged by merging common tags with resource-specific tags and a consistent naming convention.

Dependencies              : The NAT Gateway depends on the Internet Gateway to ensure proper resource creation order.