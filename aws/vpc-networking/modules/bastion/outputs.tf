output "bastion_id" {
  description = "ID of bastion instance"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Public IP of bastion"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Private IP of bastion"
  value       = aws_instance.bastion.private_ip
}

