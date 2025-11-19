# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = merge(
    var.tags,
    {
      Name = "yongchae-public-rt"
      Type = "Public"
    }
  )
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = "yongchae-private-rt"
      Type = "Private"
    }
  )
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_id
  route_table_id = aws_route_table.private.id
}

