output "instance_ids" {
  description = "IDs of EC2 instances"
  value       = aws_instance.private[*].id
}

output "instance_private_ips" {
  description = "Private IPs of EC2 instances"
  value       = aws_instance.private[*].private_ip
}

