# EC2 Instance Terraform Module

This Terraform module provisions an **AWS EC2 instance** using configurable input variables.

# Resources Created

 `aws_instance.ec2_instance` – A single EC2 instance created with the given AMI, instance type, and security group(s).


# Input Variables

| Name                   | Type     | Description                                               | Required |
|------------------------|----------|-----------------------------------------------------------|----------|
| `ami`                  | `string` | The ID of the AMI to use for the instance.                |  Yes    |
| `instance_type`        | `string` | The type of EC2 instance (e.g., `t2.micro`).              |  Yes    |
| `vpc_security_group_ids` | `list(string)` | List of VPC security group IDs to associate with the instance. |  Yes    |
| `tags`                | `map(string)` | Key-value tags to assign to the instance.               |  Yes    |


# Usage

module "ec2_instance" {
  source = "./path-to-this-module"

  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids
  tags = {
    Name        = var.name
    Environment = var.environment
  }
}

# Outputs
instance_id = 	The ID of the EC2 instance
public_ip = 	The public IP address of the instance
private_ip = 	The private IP address of the instance
