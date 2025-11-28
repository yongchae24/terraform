# Site-to-Site VPN Practice with Terraform

This Terraform configuration creates a complete Site-to-Site VPN setup for practicing BGP routing concepts, which are essential for understanding AWS Direct Connect.

## Architecture

- **VPC**: Virtual network with CIDR block (default: `10.0.0.0/16`)
- **Virtual Private Gateway (VGW)**: VPN concentrator on AWS side with BGP ASN (default: `64512`)
- **Customer Gateway (CGW)**: Represents on-premises router with BGP ASN (default: `65000`)
- **VPN Connection**: Site-to-Site VPN with Dynamic BGP routing enabled

## Cost Estimate

- **VPN Connection**: ~$0.05/hour (~$36/month if running 24/7)
- **Data Transfer**: Additional charges apply
- **Total**: Very low cost for practice (destroy when not using!)

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.3.0
- AWS provider >= 5.0

## Quick Start

### 1. Initialize Terraform

```bash
cd site-to-site-vpn-practice
terraform init
```

### 2. Review Variables (Optional)

Edit `variables.tf` to customize:
- AWS region
- VPC CIDR
- BGP ASNs
- On-premises network CIDR

### 3. Plan and Apply

```bash
# Review what will be created
terraform plan

# Create resources
terraform apply
```

### 4. Verify Resources

After `terraform apply`, check the outputs:

```bash
terraform output
```

Key outputs:
- `vpn_connection_id`: Use this to download configuration
- `bgp_configuration`: Shows ASN settings
- `instructions`: Next steps guide

### 5. Download VPN Configuration

**Option 1: AWS Console**
1. Go to VPC → Site-to-Site VPN Connections
2. Select your VPN connection
3. Click "Download configuration"
4. Select Vendor: `Generic`, Platform: `Generic`
5. Download and review BGP settings

**Option 2: AWS CLI**
```bash
aws ec2 describe-vpn-connections \
  --vpn-connection-ids $(terraform output -raw vpn_connection_id) \
  --query 'VpnConnections[0].Options.TunnelOptions'
```

### 6. Check Route Tables

1. Go to VPC → Route Tables
2. Select your VPC's default route table
3. Check "Routes" tab
4. With BGP, routes are automatically propagated when BGP session is established

### 7. Clean Up

```bash
terraform destroy
```

## Key Configuration Details

### BGP Settings

- **Virtual Private Gateway ASN**: `64512` (AWS default)
- **Customer Gateway ASN**: `65000` (on-premises)
- **Routing**: Dynamic (BGP) - routes are automatically exchanged

### Network Configuration

- **VPC CIDR**: `10.0.0.0/16` (default)
- **On-premises CIDR**: `192.168.0.0/16` (default, simulated)
- **Tunnels**: 2 tunnels created for high availability

## What You'll Learn

1. **BGP Configuration**: Understand ASN, peer IPs, and route exchange
2. **VPN Setup Process**: Complete workflow from VPC to VPN Connection
3. **Route Propagation**: How BGP automatically adds routes to Route Tables
4. **Direct Connect Concepts**: Same BGP principles apply to Direct Connect

## Comparison: Site-to-Site VPN vs Direct Connect

| Feature | Site-to-Site VPN | Direct Connect |
|---------|------------------|----------------|
| **Connection** | Internet (IPsec tunnel) | Dedicated fiber |
| **BGP Configuration** | Same (ASN, Peer IPs) | Same |
| **Route Exchange** | Automatic via BGP | Automatic via BGP |
| **Cost** | ~$0.05/hour | ~$200-300/month |
| **Latency** | Variable | Low, consistent |

## Troubleshooting

### VPN Connection State is "Pending"
- Normal during initial creation
- Wait 2-3 minutes for state to change
- Tunnels will be "Down" until on-premises router is configured

### Routes Not Appearing
- BGP routes only appear when BGP session is established
- Requires actual on-premises router configuration
- For practice, focus on understanding the configuration file

### BGP Session Not Established
- Verify BGP ASN matches on both sides
- Check BGP peer IPs in configuration file
- Ensure on-premises router is configured correctly

## Files Structure

```
site-to-site-vpn-practice/
├── main.tf          # Main resources (VPC, VGW, CGW, VPN Connection)
├── providers.tf     # Terraform and AWS provider configuration
├── variables.tf     # Input variables
├── outputs.tf       # Output values
└── README.md        # This file
```

## Interview Preparation

This setup helps you understand:
- How to configure BGP for hybrid cloud connectivity
- Virtual Private Gateway and Customer Gateway concepts
- VPN Connection creation and configuration
- Route propagation with BGP
- Direct Connect virtual interface concepts (same BGP principles)

## Notes

- This is a **practice environment** - not for production use
- On-premises router is **simulated** (no actual connection)
- Tunnels will be "Down" until real router is configured
- **Always destroy resources** when done to avoid costs

## References

- [AWS Site-to-Site VPN Documentation](https://docs.aws.amazon.com/vpn/latest/s2svpn/)
- [BGP Configuration Guide](https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNRoutingTypes.html)
- [Direct Connect User Guide](https://docs.aws.amazon.com/directconnect/)

