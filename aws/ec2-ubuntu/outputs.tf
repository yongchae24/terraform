output "instance_id" {
  description = "Ubuntu EC2 Instance ID"
  value       = aws_instance.ubuntu.id
}

output "public_ip" {
  description = "Public IP address of the Ubuntu instance"
  value       = aws_instance.ubuntu.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the Ubuntu instance"
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.ubuntu.public_ip}"
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = "${path.module}/${var.key_pair_name}.pem"
  sensitive   = false
}

output "connection_info" {
  description = "Connection information for Ubuntu instance"
  value = <<-EOT
    ========================================
    Ubuntu EC2 Instance - Practice Environment
    ========================================
    Instance ID: ${aws_instance.ubuntu.id}
    Public IP:   ${aws_instance.ubuntu.public_ip}
    Instance Type: ${var.instance_type}
    Region:      ${var.aws_region}
    
    SSH Command:
    ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.ubuntu.public_ip}
    
    Or wait a moment for the instance to be ready, then run:
    ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.ubuntu.public_ip}
    
    ========================================
  EOT
}

