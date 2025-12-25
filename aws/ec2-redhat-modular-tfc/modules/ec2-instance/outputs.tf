output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.amazon_linux.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.amazon_linux.arn
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = aws_instance.amazon_linux.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = aws_instance.amazon_linux.private_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = aws_instance.amazon_linux.public_dns
}
