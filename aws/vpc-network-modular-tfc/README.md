# VPC Network Modular Terraform Configuration

This Terraform configuration creates a complete AWS VPC networking setup using modular design and Terraform Cloud as remote backend.

## Architecture

### Components
- **VPC**: `yongchae-vpc-lab` (10.0.0.0/16)
- **Public Subnet**: `yongchae-public-subnet-1a` (10.0.1.0/24)
- **Private Subnet**: `yongchae-private-subnet-1a` (10.0.2.0/24)
- **Internet Gateway**: `yongchae-igw` (FREE)
- **Route Tables**: Public and Private
- **Security Groups**: Web and Database

### Network Flow
```
Internet
    ↕
[Internet Gateway]
    ↕
[VPC: 10.0.0.0/16]
    ├── [Public Subnet: 10.0.1.0/24]  ← Internet accessible
    │   └── Route: 0.0.0.0/0 → IGW
    │
    └── [Private Subnet: 10.0.2.0/24] ← No internet access
        └── Route: Local only
```

## Prerequisites

1. **Terraform Cloud Account**
   - Organization: `yongchae-terraform`
   - Workspace: `vpc-network-modular`

2. **AWS Credentials** (Set in Terraform Cloud workspace)
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_DEFAULT_REGION`

3. **Terraform CLI** (>= 1.0)

## Module Structure

```
vpc-network-modular-tfc/
├── main.tf                    # Root configuration with module calls
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── providers.tf               # Provider configuration
├── backend.tf                 # Terraform Cloud backend
├── README.md                  # This file
└── modules/
    ├── vpc/                   # VPC module
    ├── subnets/              # Public and private subnets
    ├── internet-gateway/     # Internet Gateway
    ├── route-tables/         # Route tables and associations
    └── security-groups/      # Web and database security groups
```

## Usage

### Step 1: Initialize Terraform
```bash
cd vpc-network-modular-tfc
terraform init
```

### Step 2: Review the Plan
```bash
terraform plan
```

### Step 3: Apply Configuration
```bash
terraform apply
```

### Step 4: View Outputs
```bash
terraform output
```

### Step 5: Destroy Resources (when done)
```bash
terraform destroy
```

## Security Groups

### Web Security Group
- **SSH**: Port 22 (configurable source)
- **HTTP**: Port 80 (open to internet)
- **HTTPS**: Port 443 (open to internet)
- **Egress**: All traffic allowed

### Database Security Group
- **MySQL**: Port 3306 (VPC only)
- **PostgreSQL**: Port 5432 (VPC only)
- **Egress**: All traffic allowed

## Cost Considerations

All components are **FREE** or minimal cost:
- ✅ VPC: Free
- ✅ Subnets: Free
- ✅ Internet Gateway: Free
- ✅ Route Tables: Free
- ✅ Security Groups: Free
- ❌ NAT Gateway: **NOT INCLUDED** (would cost ~$32/month)

## Customization

Edit `variables.tf` or pass variables during apply:

```bash
terraform apply -var="vpc_cidr=172.16.0.0/16" -var="vpc_name=my-custom-vpc"
```

## Learning Objectives

This configuration demonstrates:
- Modular Terraform design
- VPC networking fundamentals
- Public vs Private subnet patterns
- Internet Gateway setup
- Route table associations
- Security group best practices
- Terraform Cloud remote backend
- Output propagation through modules

## Notes

- State is stored remotely in Terraform Cloud
- All resources are created in `us-east-1` by default
- Resources are tagged for easy identification
- No NAT Gateway = private subnet cannot reach internet

