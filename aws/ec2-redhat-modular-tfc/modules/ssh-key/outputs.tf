output "key_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "key_pair_id" {
  description = "ID of the AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_pair_id
}

output "vault_path" {
  description = "Vault path where private key is stored"
  value       = vault_kv_secret_v2.ssh_key.path
}

output "vault_secret_path" {
  description = "Full Vault secret path for retrieving the private key"
  value       = "secret/data/ec2/ssh-keys/${var.key_pair_name}"
}
