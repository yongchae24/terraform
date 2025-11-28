variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
  default     = "vpn-practice-vpc"
}

variable "vgw_name" {
  description = "Name tag for Virtual Private Gateway"
  type        = string
  default     = "vpn-practice-vgw"
}

variable "vgw_asn" {
  description = "BGP ASN for Virtual Private Gateway (default AWS ASN: 64512)"
  type        = number
  default     = 64512
}

variable "cgw_name" {
  description = "Name tag for Customer Gateway"
  type        = string
  default     = "vpn-practice-cgw"
}

variable "cgw_ip_address" {
  description = "Public IP address of on-premises router (simulated for practice)"
  type        = string
  default     = "203.0.113.1"
}

variable "cgw_bgp_asn" {
  description = "BGP ASN for Customer Gateway (on-premises ASN)"
  type        = number
  default     = 65000
}

variable "vpn_connection_name" {
  description = "Name tag for VPN Connection"
  type        = string
  default     = "vpn-practice-connection"
}

variable "local_ipv4_network_cidr" {
  description = "Local IPv4 network CIDR (on-premises network)"
  type        = string
  default     = "192.168.0.0/16"
}

variable "remote_ipv4_network_cidr" {
  description = "Remote IPv4 network CIDR (VPC CIDR)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "static_routes_only" {
  description = "Whether to use static routes only (false = Dynamic BGP routing)"
  type        = bool
  default     = false
}

