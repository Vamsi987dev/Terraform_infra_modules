resource "aws_instance" "ec2_instance" {
    ami = var.ami
    instance_type = var.instance_type
    vpc_security_group_ids = var.vpc_security_group_ids
    tags = var.tags
    
}