output "instance_1_id" {
  description = "EC2 Instance 1 ID"
  value       = module.ec2_instance_1.instance_id
}

output "instance_1_public_ip" {
  description = "Public IP address of EC2 Instance 1"
  value       = module.ec2_instance_1.public_ip
}

output "instance_1_private_ip" {
  description = "Private IP address of EC2 Instance 1 (use this for ping testing)"
  value       = module.ec2_instance_1.private_ip
}

output "instance_2_id" {
  description = "EC2 Instance 2 ID"
  value       = module.ec2_instance_2.instance_id
}

output "instance_2_public_ip" {
  description = "Public IP address of EC2 Instance 2"
  value       = module.ec2_instance_2.public_ip
}

output "instance_2_private_ip" {
  description = "Private IP address of EC2 Instance 2 (use this for ping testing)"
  value       = module.ec2_instance_2.private_ip
}

output "ping_test_info" {
  description = "Information for ping testing between instances"
  value       = <<-EOT
    ========================================
    EC2 Instances - Ping Test Configuration
    ========================================
    Instance 1:
      Instance ID: ${module.ec2_instance_1.instance_id}
      Private IP:  ${module.ec2_instance_1.private_ip}
      Public IP:   ${module.ec2_instance_1.public_ip}
    
    Instance 2:
      Instance ID: ${module.ec2_instance_2.instance_id}
      Private IP:  ${module.ec2_instance_2.private_ip}
      Public IP:   ${module.ec2_instance_2.public_ip}
    
    To test ping:
    1. Connect to Instance 1 via AWS Console (Session Manager or EC2 Instance Connect)
    2. Run: ping ${module.ec2_instance_2.private_ip}
    
    Or connect to Instance 2 and run:
    ping ${module.ec2_instance_1.private_ip}
    
    ========================================
  EOT
}
