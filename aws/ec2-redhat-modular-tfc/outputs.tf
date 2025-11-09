output "instance_id" {
  description = "Amazon Linux 2023 EC2 Instance ID (RHEL-based)"
  value       = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "Public IP address of the Amazon Linux 2023 instance"
  value       = module.ec2_instance.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the Amazon Linux 2023 instance"
  value       = "ssh -i ${var.key_pair_name}.pem ec2-user@${module.ec2_instance.public_ip}"
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = module.ssh_key.private_key_path
  sensitive   = false
}

output "connection_info" {
  description = "Connection information for Amazon Linux 2023 instance (RHEL-based)"
  value       = <<-EOT
    ========================================
    Amazon Linux 2023 EC2 Instance - Practice Environment (RHEL-based)
    ========================================
    Instance ID: ${module.ec2_instance.instance_id}
    Public IP:   ${module.ec2_instance.public_ip}
    Instance Type: ${var.instance_type}
    Region:      ${var.aws_region}
    
    SSH Command:
    ssh -i ${var.key_pair_name}.pem ec2-user@${module.ec2_instance.public_ip}
    
    Or wait a moment for the instance to be ready, then run:
    ssh -i ${var.key_pair_name}.pem ec2-user@${module.ec2_instance.public_ip}
    
    ========================================
  EOT
}
