output "instance_id" {
  description = "Amazon Linux 2023 EC2 Instance ID (RHEL-based)"
  value       = aws_instance.redhat.id
}

output "public_ip" {
  description = "Public IP address of the Amazon Linux 2023 instance"
  value       = aws_instance.redhat.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the Amazon Linux 2023 instance"
  value       = "ssh -i ${var.key_pair_name}.pem ec2-user@${aws_instance.redhat.public_ip}"
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = "${path.module}/${var.key_pair_name}.pem"
  sensitive   = false
}

output "connection_info" {
  description = "Connection information for Amazon Linux 2023 instance (RHEL-based)"
  value       = <<-EOT
    ========================================
    Amazon Linux 2023 EC2 Instance - Practice Environment (RHEL-based)
    ========================================
    Instance ID: ${aws_instance.redhat.id}
    Public IP:   ${aws_instance.redhat.public_ip}
    Instance Type: ${var.instance_type}
    Region:      ${var.aws_region}
    
    SSH Command:
    ssh -i ${var.key_pair_name}.pem ec2-user@${aws_instance.redhat.public_ip}
    
    Or wait a moment for the instance to be ready, then run:
    ssh -i ${var.key_pair_name}.pem ec2-user@${aws_instance.redhat.public_ip}
    
    ========================================
  EOT
}

