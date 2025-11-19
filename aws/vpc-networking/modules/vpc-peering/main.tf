# Second VPC for peering
resource "aws_vpc" "secondary" {
  cidr_block           = var.vpc2_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpc2"
    }
  )
}

# Subnet in second VPC
resource "aws_subnet" "secondary" {
  vpc_id            = aws_vpc.secondary.id
  cidr_block        = var.vpc2_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpc2-subnet"
    }
  )
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "main" {
  vpc_id      = var.vpc1_id
  peer_vpc_id = aws_vpc.secondary.id
  auto_accept = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-peering"
    }
  )
}

# Add route in VPC1 route table to VPC2
resource "aws_route" "vpc1_to_vpc2" {
  route_table_id            = var.vpc1_private_route_table_id
  destination_cidr_block    = var.vpc2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

# Route table for VPC2
resource "aws_route_table" "vpc2" {
  vpc_id = aws_vpc.secondary.id

  route {
    cidr_block                = var.vpc1_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpc2-rt"
    }
  )
}

# Associate VPC2 subnet with route table
resource "aws_route_table_association" "vpc2" {
  subnet_id      = aws_subnet.secondary.id
  route_table_id = aws_route_table.vpc2.id
}

