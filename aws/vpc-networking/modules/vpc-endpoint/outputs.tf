output "vpc_endpoint_id" {
  description = "ID of the VPC endpoint"
  value       = aws_vpc_endpoint.s3.id
}

