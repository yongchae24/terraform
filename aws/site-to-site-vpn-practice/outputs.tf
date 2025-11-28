output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "vpn_gateway_id" {
  description = "ID of the Virtual Private Gateway"
  value       = aws_vpn_gateway.main.id
}

output "vpn_gateway_asn" {
  description = "BGP ASN of the Virtual Private Gateway"
  value       = aws_vpn_gateway.main.amazon_side_asn
}

output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = aws_customer_gateway.main.id
}

output "customer_gateway_bgp_asn" {
  description = "BGP ASN of the Customer Gateway"
  value       = aws_customer_gateway.main.bgp_asn
}

output "vpn_connection_id" {
  description = "ID of the VPN Connection"
  value       = aws_vpn_connection.main.id
}

output "vpn_connection_tunnel1_address" {
  description = "Tunnel 1 outside IP address (AWS side)"
  value       = aws_vpn_connection.main.tunnel1_address
}

output "vpn_connection_tunnel2_address" {
  description = "Tunnel 2 outside IP address (AWS side)"
  value       = aws_vpn_connection.main.tunnel2_address
}

output "vpn_connection_tunnel1_cgw_inside_address" {
  description = "Tunnel 1 inside IP address (Customer Gateway side)"
  value       = aws_vpn_connection.main.tunnel1_cgw_inside_address
}

output "vpn_connection_tunnel1_vgw_inside_address" {
  description = "Tunnel 1 inside IP address (Virtual Private Gateway side)"
  value       = aws_vpn_connection.main.tunnel1_vgw_inside_address
}

output "vpn_connection_tunnel2_cgw_inside_address" {
  description = "Tunnel 2 inside IP address (Customer Gateway side)"
  value       = aws_vpn_connection.main.tunnel2_cgw_inside_address
}

output "vpn_connection_tunnel2_vgw_inside_address" {
  description = "Tunnel 2 inside IP address (Virtual Private Gateway side)"
  value       = aws_vpn_connection.main.tunnel2_vgw_inside_address
}

output "vpn_connection_tunnel1_preshared_key" {
  description = "Tunnel 1 pre-shared key (for IPSec)"
  value       = aws_vpn_connection.main.tunnel1_preshared_key
  sensitive   = true
}

output "vpn_connection_tunnel2_preshared_key" {
  description = "Tunnel 2 pre-shared key (for IPSec)"
  value       = aws_vpn_connection.main.tunnel2_preshared_key
  sensitive   = true
}

output "bgp_configuration" {
  description = "BGP configuration summary"
  value = {
    vgw_asn = aws_vpn_gateway.main.amazon_side_asn
    cgw_asn = aws_customer_gateway.main.bgp_asn
    routing = var.static_routes_only ? "Static" : "Dynamic (BGP)"
  }
}

output "instructions" {
  description = "Instructions for next steps"
  value = <<-EOT
    VPN Connection created successfully!
    
    Next steps:
    1. Download VPN configuration:
       aws ec2 describe-vpn-connections --vpn-connection-ids ${aws_vpn_connection.main.id} --query 'VpnConnections[0].Options.TunnelOptions'
    
    2. Or use AWS Console:
       VPC → Site-to-Site VPN Connections → ${aws_vpn_connection.main.id} → Download configuration
    
    3. Check Route Tables:
       VPC → Route Tables → Check routes for BGP-learned routes
    
    4. To destroy all resources:
       terraform destroy
  EOT
}

