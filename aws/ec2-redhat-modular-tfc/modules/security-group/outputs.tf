output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.redhat_sg.id
}

output "security_group_arn" {
  description = "ARN of the security group"
  value       = aws_security_group.redhat_sg.arn
}
