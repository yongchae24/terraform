# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

# Subnet Outputs
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.subnets.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.subnets.private_subnet_id
}

output "public_subnet_cidr" {
  description = "CIDR block of the public subnet"
  value       = module.subnets.public_subnet_cidr
}

output "private_subnet_cidr" {
  description = "CIDR block of the private subnet"
  value       = module.subnets.private_subnet_cidr
}

# Internet Gateway Output
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.internet_gateway.igw_id
}

# Route Table Outputs
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = module.route_tables.private_route_table_id
}

# Security Group Outputs
output "web_security_group_id" {
  description = "ID of the web security group"
  value       = module.security_groups.web_security_group_id
}

output "database_security_group_id" {
  description = "ID of the database security group"
  value       = module.security_groups.database_security_group_id
}

