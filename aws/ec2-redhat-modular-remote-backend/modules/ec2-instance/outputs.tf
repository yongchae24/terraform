output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.redhat.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.redhat.arn
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.redhat.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.redhat.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.redhat.public_dns
}

