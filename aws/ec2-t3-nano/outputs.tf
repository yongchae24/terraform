# =============================================================================
# Outputs Configuration for AWS EC2 t3.nano Instance - COST OPTIMIZED
# =============================================================================
# This file defines essential output values for cost-optimized deployment

# =============================================================================
# Instance Information Outputs
# =============================================================================

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.main.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.main.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.main.public_dns
}

# =============================================================================
# Network Information Outputs
# =============================================================================

output "vpc_id" {
  description = "ID of the default VPC"
  value       = data.aws_vpc.default.id
}

output "subnet_id" {
  description = "ID of the default subnet"
  value       = aws_instance.main.subnet_id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2_sg.id
}

# =============================================================================
# Connection Information Outputs
# =============================================================================

output "ssh_connection_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.main.public_ip}"
}

output "web_server_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.main.public_ip}"
}

output "connection_instructions" {
  description = "Instructions for connecting to the instance"
  value       = <<EOF
========================================
CloudTechnote EC2 Instance - Cost Optimized
========================================
Instance ID: ${aws_instance.main.id}
Public IP: ${aws_instance.main.public_ip}
Private IP: ${aws_instance.main.private_ip}
Instance Type: ${aws_instance.main.instance_type}
Region: ${var.aws_region}

Connection Methods:
1. SSH: ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.main.public_ip}
2. Web: http://${aws_instance.main.public_ip}
3. AWS Console: EC2 > Instances > ${aws_instance.main.id}

Cost Information:
- Instance: ~$3.80/month (t3.nano)
- Storage: ~$0.80/month (8GB GP3)
- Total: ~$4.60/month
========================================
EOF
}

# =============================================================================
# Cost Information Outputs
# =============================================================================

output "instance_type" {
  description = "Type of the EC2 instance"
  value       = aws_instance.main.instance_type
}

output "root_volume_size" {
  description = "Size of the root volume in GB"
  value       = aws_instance.main.root_block_device[0].volume_size
}

output "monitoring_enabled" {
  description = "Whether detailed monitoring is enabled"
  value       = aws_instance.main.monitoring
}

# =============================================================================
# Summary Output
# =============================================================================

output "deployment_summary" {
  description = "Summary of the cost-optimized deployment"
  value = {
    project_name           = var.project_name
    environment            = var.environment
    instance_id            = aws_instance.main.id
    instance_type          = aws_instance.main.instance_type
    public_ip              = aws_instance.main.public_ip
    private_ip             = aws_instance.main.private_ip
    vpc_id                 = data.aws_vpc.default.id
    subnet_id              = aws_instance.main.subnet_id
    security_group         = aws_security_group.ec2_sg.id
    region                 = var.aws_region
    cost_optimized         = true
    estimated_monthly_cost = "$4.60"
  }
}
