output "key_name" {
  description = "Name of the AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "key_pair_id" {
  description = "ID of the AWS key pair"
  value       = aws_key_pair.ec2_key_pair.key_pair_id
}

output "private_key_path" {
  description = "Path to the private key file"
  value       = "${path.root}/${var.key_pair_name}.pem"
}

