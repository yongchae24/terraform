# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.vpc.igw_id
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = module.subnets.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = module.subnets.private_subnet_ids
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.nat_gateway.nat_gateway_id
}

output "nat_gateway_eip" {
  description = "Elastic IP of NAT Gateway"
  value       = module.nat_gateway.nat_eip
}

# Bastion Outputs
output "bastion_public_ip" {
  description = "Public IP of bastion host"
  value       = module.bastion.bastion_public_ip
}

output "bastion_private_ip" {
  description = "Private IP of bastion host"
  value       = module.bastion.bastion_private_ip
}

output "ssh_key_path" {
  description = "Path to SSH private key file"
  value       = module.ssh_key.private_key_path
}

# EC2 Instances Outputs
output "ec2_instance_ids" {
  description = "IDs of private EC2 instances"
  value       = module.ec2_instances.instance_ids
}

output "ec2_private_ips" {
  description = "Private IPs of EC2 instances"
  value       = module.ec2_instances.instance_private_ips
}

# ALB Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb.alb_dns_name
}

output "alb_url" {
  description = "URL of the Application Load Balancer"
  value       = "http://${module.alb.alb_dns_name}"
}

# RDS Outputs
output "rds_endpoint" {
  description = "RDS MySQL endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_address" {
  description = "RDS MySQL address"
  value       = module.rds.rds_address
}

output "rds_port" {
  description = "RDS MySQL port"
  value       = module.rds.rds_port
}

# S3 Outputs
output "s3_bucket_id" {
  description = "ID of the S3 bucket"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

# VPC Endpoint Output
output "vpc_endpoint_id" {
  description = "ID of the S3 VPC Endpoint"
  value       = module.vpc_endpoint.vpc_endpoint_id
}

# VPC Peering Outputs
output "vpc2_id" {
  description = "ID of the second VPC"
  value       = module.vpc_peering.vpc2_id
}

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection"
  value       = module.vpc_peering.peering_connection_id
}

output "vpc_peering_status" {
  description = "Status of VPC peering connection"
  value       = module.vpc_peering.peering_status
}

# Connection Instructions
output "ssh_to_bastion_command" {
  description = "Command to SSH into bastion"
  value       = "ssh -i ${module.ssh_key.private_key_path} ec2-user@${module.bastion.bastion_public_ip}"
}

output "ssh_to_ec2_via_bastion" {
  description = "Commands to SSH to private EC2 via bastion"
  value = [
    for ip in module.ec2_instances.instance_private_ips :
    "ssh -i ${module.ssh_key.private_key_path} -J ec2-user@${module.bastion.bastion_public_ip} ec2-user@${ip}"
  ]
}

output "mysql_tunnel_command" {
  description = "Command to create SSH tunnel for MySQL"
  value       = "ssh -i ${module.ssh_key.private_key_path} -L 3306:${module.rds.rds_address}:3306 ec2-user@${module.bastion.bastion_public_ip}"
}

