output "key_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.main.key_name
}

output "private_key_path" {
  description = "Path to private key file"
  value       = local_file.private_key.filename
}

