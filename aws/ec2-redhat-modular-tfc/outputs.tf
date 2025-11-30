output "instance_id" {
  description = "Amazon Linux 2023 EC2 Instance ID (RHEL-based)"
  value       = module.ec2_instance.instance_id
}

output "public_ip" {
  description = "Public IP address of the Amazon Linux 2023 instance"
  value       = module.ec2_instance.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the Amazon Linux 2023 instance (key must be retrieved from Vault first)"
  value       = "ssh -i <key-from-vault> ec2-user@${module.ec2_instance.public_ip}"
}

output "vault_path" {
  description = "Vault path where private key is stored"
  value       = module.ssh_key.vault_path
}

output "vault_secret_path" {
  description = "Full Vault secret path for retrieving the private key"
  value       = module.ssh_key.vault_secret_path
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
    
    SSH Command (retrieve key from Vault first):
    vault kv get -field=private_key secret/ec2/ssh-keys/${var.key_pair_name} > ${var.key_pair_name}.pem
    chmod 400 ${var.key_pair_name}.pem
    ssh -i ${var.key_pair_name}.pem ec2-user@${module.ec2_instance.public_ip}
    
    Vault Path: ${module.ssh_key.vault_secret_path}
    
    ========================================
  EOT
}
