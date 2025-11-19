output "vpc2_id" {
  description = "ID of the second VPC"
  value       = aws_vpc.secondary.id
}

output "vpc2_cidr" {
  description = "CIDR of the second VPC"
  value       = aws_vpc.secondary.cidr_block
}

output "peering_connection_id" {
  description = "ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.main.id
}

output "peering_status" {
  description = "Status of the VPC peering connection"
  value       = aws_vpc_peering_connection.main.accept_status
}

