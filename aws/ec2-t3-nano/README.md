# AWS EC2 t3.nano Instance - Minimal Cost Configuration

This Terraform configuration creates a cost-effective AWS EC2 instance using t3.nano with minimal resource requirements.

## Overview

This configuration deploys:
- **EC2 Instance**: t3.nano (most cost-effective instance type)
- **Default VPC**: Uses AWS default VPC (no additional cost)
- **Security Group**: Minimal security group (free)
- **Public IP**: Dynamic public IP (free)
- **User Data**: Automated system setup and web server

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured
- AWS account with appropriate permissions

## Quick Start

### 1. Clone and Navigate
```bash
git clone <repository-url>
cd terraform/aws/ec2-t3-nano
```

### 2. Configure Variables
```bash
# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Edit if needed (defaults are already cost-optimized)
nano terraform.tfvars
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan Deployment
```bash
terraform plan
```

### 5. Deploy Infrastructure
```bash
terraform apply
```

### 6. Connect to Instance
```bash
# Use the SSH command from the output
ssh -i ~/.ssh/id_rsa ec2-user@<public-ip>

# Or access the web server
curl http://<public-ip>
```

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

## File Structure

```
ec2-t3-nano/
├── main.tf              # Core infrastructure (minimal)
├── variables.tf           # Essential variables only
├── outputs.tf            # Essential outputs only
├── terraform.tfvars      # Variable values
├── terraform.tfvars.example # Example configuration
├── user_data.sh          # EC2 initialization script
├── .gitignore           # Essential ignore rules
└── README.md            # This file
```

## Configuration Options

### Instance Types (Cost Order)
- `t3.nano` (default) - $3.80/month
- `t3.micro` - $7.60/month
- `t3.small` - $15.20/month

### Network Configuration
- Uses default VPC (free)
- Uses default subnets (free)
- Dynamic public IP (free)

### Security
- SSH access (port 22)
- HTTP access (port 80)
- All outbound traffic allowed

## Outputs

After deployment, you'll get:
- Instance ID and IP addresses
- SSH connection command
- Web server URL
- Cost information
- Connection instructions

## Monitoring

The instance includes:
- Basic system monitoring tools
- Web server for health checks
- Status endpoint at `/status.html`
- Welcome page with instance details

## Customization

### Changing Instance Type
```hcl
# In terraform.tfvars
instance_type = "t3.micro"  # or t3.small
```

### Adding More Storage
```hcl
# In terraform.tfvars
root_volume_size = 20  # GB
```

### Adding HTTPS
```hcl
# In main.tf security group
ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "HTTPS access"
}
```

## Security Notes

- **SSH access** is open to all IPs (restrict in production)
- **No encryption** enabled (enable for production)
- **Default VPC** used (create custom VPC for production)
- **No monitoring** enabled (enable for production)

## Best Practices

- **Cost Optimization**: Minimum required resources
- **Version Control**: All code is version controlled
- **Documentation**: Clear and concise
- **Security**: Basic security group
- **Monitoring**: Basic health checks
- **Cleanup**: Easy destroy command