# Site-to-Site VPN Practice Configuration
# This configuration creates a Site-to-Site VPN setup for BGP routing practice
#
# Architecture:
# - VPC with CIDR block
# - Virtual Private Gateway (VGW) with BGP ASN
# - Customer Gateway (CGW) representing on-premises router
# - VPN Connection with Dynamic BGP routing
#
# Estimated Cost: ~$0.05/hour (~$36/month if running 24/7)
# - VPN Connection: ~$0.05/hour
# - Data transfer: Additional charges
#
# Created: 2025-11-24
# Purpose: Direct Connect & BGP interview preparation

locals {
  common_tags = {
    Project     = "Site-to-Site-VPN-Practice"
    Environment = "learning"
    ManagedBy   = "Terraform"
    Owner       = "yongchae"
    Purpose     = "interview-preparation"
    CostCenter  = "learning"
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    {
      Name = var.vpc_name
    }
  )
}

# Virtual Private Gateway
resource "aws_vpn_gateway" "main" {
  amazon_side_asn = var.vgw_asn

  tags = merge(
    local.common_tags,
    {
      Name = var.vgw_name
    }
  )
}

# Attach VGW to VPC
resource "aws_vpn_gateway_attachment" "main" {
  vpc_id         = aws_vpc.main.id
  vpn_gateway_id = aws_vpn_gateway.main.id
}

# Customer Gateway (represents on-premises router)
resource "aws_customer_gateway" "main" {
  bgp_asn    = var.cgw_bgp_asn
  ip_address = var.cgw_ip_address
  type       = "ipsec.1"

  tags = merge(
    local.common_tags,
    {
      Name = var.cgw_name
    }
  )
}

# VPN Connection
resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = aws_vpn_gateway.main.id
  customer_gateway_id = aws_customer_gateway.main.id
  type                = "ipsec.1"
  static_routes_only  = var.static_routes_only

  # Local and Remote CIDR blocks (for static routing or BGP route filtering)
  # Note: For BGP, these are used for route filtering, not static routes
  local_ipv4_network_cidr  = var.local_ipv4_network_cidr
  remote_ipv4_network_cidr = var.remote_ipv4_network_cidr

  tags = merge(
    local.common_tags,
    {
      Name = var.vpn_connection_name
    }
  )
}

# Get default route table for VPC
data "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}

# Route to on-premises network via VPN (for static routing)
# Note: With BGP, routes are automatically propagated
resource "aws_route" "to_onprem" {
  count                  = var.static_routes_only ? 1 : 0
  route_table_id         = data.aws_route_table.main.id
  destination_cidr_block = var.local_ipv4_network_cidr
  gateway_id             = aws_vpn_gateway.main.id
}

