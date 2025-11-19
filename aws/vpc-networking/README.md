# AWS VPC Networking - Terraform Infrastructure

A comprehensive AWS networking infrastructure built with Terraform modules for hands-on practice and learning.

## 🏗️ Architecture Overview

```
Internet
    ↕
[Internet Gateway]
    ↕
┌─────────────────────────────────────────────────────────────┐
│ VPC: 10.10.0.0/16                                           │
│                                                              │
│  ┌──────────────┐    ┌──────────────┐                      │
│  │ Public Sub 1 │    │ Public Sub 2 │                      │
│  │ 10.10.1.0/24 │    │ 10.10.2.0/24 │                      │
│  │              │    │              │                      │
│  │  [Bastion]   │    │ [NAT Gateway]│                      │
│  └──────────────┘    └──────────────┘                      │
│         ↓                    ↓                              │
│  ┌──────────────────────────────┐                          │
│  │  Application Load Balancer   │                          │
│  └──────────────────────────────┘                          │
│         ↓                                                   │
│  ┌──────────────┐    ┌──────────────┐                      │
│  │ Private Sub1 │    │ Private Sub2 │                      │
│  │ 10.10.11.0/24│    │ 10.10.12.0/24│                      │
│  │              │    │              │                      │
│  │   [EC2-1]    │    │   [EC2-2]    │                      │
│  │   Red Hat    │    │   Red Hat    │                      │
│  └──────────────┘    └──────────────┘                      │
│                                                              │
│  ┌──────────────┐    ┌──────────────┐                      │
│  │ Private Sub3 │    │ Private Sub4 │                      │
│  │ 10.10.13.0/24│    │ 10.10.14.0/24│                      │
│  │              │    │              │                      │
│  │  [RDS MySQL] │    │   (empty)    │                      │
│  └──────────────┘    └──────────────┘                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
         │                                     │
         ↓                                     ↓
  [VPC Endpoint]  ────────────────────→   [S3 Bucket]
   (Gateway)
         │
         ↓
  [VPC Peering]
         ↓
   [VPC2: 10.20.0.0/16]
```

## 📋 Components

### Networking
| Component | Details | Cost |
|-----------|---------|------|
| VPC | 10.10.0.0/16 | Free |
| Internet Gateway | For public subnet internet access | Free |
| NAT Gateway | In Public Subnet 2 | ~$32/month |
| Public Subnets | 2 subnets (10.10.1.0/24, 10.10.2.0/24) | Free |
| Private Subnets | 4 subnets (10.10.11-14.0/24) | Free |

### Compute
| Component | Details | Cost |
|-----------|---------|------|
| Bastion Host | t3.nano Red Hat in Public Subnet 1 | ~$3.80/month |
| EC2 Instance 1 | t3.micro Red Hat in Private Subnet 1 | ~$7.50/month |
| EC2 Instance 2 | t3.micro Red Hat in Private Subnet 2 | ~$7.50/month |

### Load Balancing
| Component | Details | Cost |
|-----------|---------|------|
| Application Load Balancer | Across 2 public subnets | ~$16/month |
| Target Group | With 2 EC2 instances | Included |

### Database
| Component | Details | Cost |
|-----------|---------|------|
| RDS MySQL | db.t3.micro in Private Subnet 3 | ~$12/month |

### Storage & Additional
| Component | Details | Cost |
|-----------|---------|------|
| S3 Bucket | Private bucket with versioning | ~$0 |
| VPC Endpoint | Gateway type for S3 | Free |
| VPC Peering | Second VPC (10.20.0.0/16) | Free |

### **Total Monthly Cost: ~$79/month** (if running 24/7)
### **Practice Session Cost: ~$0.44** (for 4 hours)

## 🚀 Getting Started

### Prerequisites

1. **Terraform Cloud Account**
   - Organization: `yongchae-terraform`
   - Workspace: `vpc-networking`

2. **AWS Credentials**
   Set these as environment variables in Terraform Cloud workspace:
   ```
   AWS_ACCESS_KEY_ID
   AWS_SECRET_ACCESS_KEY
   AWS_DEFAULT_REGION=us-east-1
   ```

3. **Your IP Address**
   Update `your_ip_cidr` in `variables.tf` or pass as variable:
   ```bash
   # Get your IP
   curl https://checkip.amazonaws.com
   ```

4. **RDS Password**
   Change the default password in `variables.tf` or pass as variable

5. **S3 Bucket Name**
   Ensure bucket name is globally unique in `variables.tf`

### Installation Steps

#### Step 1: Create Terraform Cloud Workspace
```bash
# Login to Terraform Cloud
terraform login

# The backend.tf already configured for workspace: vpc-networking
```

#### Step 2: Add AWS Credentials
Go to: https://app.terraform.io/app/yongchae-terraform/vpc-networking/variables

Add Environment Variables:
- `AWS_ACCESS_KEY_ID` (sensitive)
- `AWS_SECRET_ACCESS_KEY` (sensitive)
- `AWS_DEFAULT_REGION` = `us-east-1`

#### Step 3: Initialize Terraform
```bash
cd /Users/yongchae.ko/Documents/projects/terraform/aws/vpc-networking
terraform init
```

#### Step 4: Review Plan
```bash
terraform plan
```

#### Step 5: Apply Configuration
```bash
terraform apply
```

⏱️ **Provisioning Time: ~15-20 minutes** (RDS takes longest)

## 🔐 Access Instructions

### 1. SSH to Bastion Host
```bash
# Use the SSH key generated by Terraform
ssh -i vpc-networking-key.pem ec2-user@<BASTION_PUBLIC_IP>

# Or use the output command
terraform output ssh_to_bastion_command
```

### 2. SSH to Private EC2 Instances
```bash
# Via bastion (jump host)
ssh -i vpc-networking-key.pem -J ec2-user@<BASTION_IP> ec2-user@<EC2_PRIVATE_IP>

# Or use the output commands
terraform output ssh_to_ec2_via_bastion
```

### 3. Connect to RDS MySQL

**Option A: Via SSH Tunnel (from your laptop)**
```bash
# Create SSH tunnel
ssh -i vpc-networking-key.pem -L 3306:<RDS_ENDPOINT>:3306 ec2-user@<BASTION_IP>

# Or use the output command
terraform output mysql_tunnel_command
```

Then connect MySQL Workbench to:
- Host: `localhost`
- Port: `3306`
- Username: `admin`
- Password: `<your_password>`

**Option B: From Private EC2**
```bash
# SSH to private EC2
ssh -i vpc-networking-key.pem -J ec2-user@<BASTION_IP> ec2-user@<EC2_PRIVATE_IP>

# Install MySQL client
sudo yum install -y mysql

# Connect to RDS
mysql -h <RDS_ENDPOINT> -u admin -p
```

### 4. Access Application Load Balancer
```bash
# Get ALB URL
terraform output alb_url

# Open in browser or curl
curl http://<ALB_DNS_NAME>
```

### 5. Test S3 Access via VPC Endpoint
```bash
# SSH to private EC2
ssh -i vpc-networking-key.pem -J ec2-user@<BASTION_IP> ec2-user@<EC2_PRIVATE_IP>

# Install AWS CLI
sudo yum install -y aws-cli

# Test S3 access (goes through VPC Endpoint, not internet)
aws s3 ls s3://<BUCKET_NAME>
```

## 📁 Project Structure

```
vpc-networking/
├── main.tf                          # Root module orchestration
├── variables.tf                     # Input variables
├── outputs.tf                       # Output values
├── providers.tf                     # Provider configuration
├── backend.tf                       # Terraform Cloud backend
├── README.md                        # This file
└── modules/
    ├── vpc/                         # VPC + Internet Gateway
    ├── subnets/                     # 2 public + 4 private subnets
    ├── nat-gateway/                 # NAT Gateway + EIP
    ├── route-tables/                # Public & private route tables
    ├── security-groups/             # All security groups
    ├── ssh-key/                     # SSH key pair generation
    ├── bastion/                     # Bastion host (jump server)
    ├── alb/                         # Application Load Balancer
    ├── ec2-instances/               # Private EC2 instances
    ├── rds/                         # RDS MySQL database
    ├── s3/                          # S3 bucket
    ├── vpc-endpoint/                # VPC Endpoint Gateway (S3)
    └── vpc-peering/                 # VPC Peering connection
```

## 🎯 Learning Objectives

This infrastructure demonstrates:

1. **VPC Design Patterns**
   - Public vs Private subnets
   - Multi-AZ architecture
   - Internet Gateway for public access
   - NAT Gateway for private subnet internet access

2. **Security Best Practices**
   - Bastion host for SSH access
   - Security groups with least privilege
   - Private subnets for sensitive resources
   - No public IPs for EC2/RDS

3. **High Availability**
   - Application Load Balancer
   - Multi-AZ subnet distribution
   - Target group health checks

4. **Networking Concepts**
   - Route tables and associations
   - VPC Endpoint Gateway (AWS PrivateLink)
   - VPC Peering
   - SSH tunneling

5. **Terraform Modularity**
   - Reusable modules
   - Module dependencies
   - Output propagation
   - Remote state (Terraform Cloud)

## 💰 Cost Management

### To Minimize Costs:

**Option 1: Practice Session (Recommended)**
```bash
# Start practice
terraform apply

# Practice for 2-4 hours (~$0.22-0.44)

# Destroy when done
terraform destroy
```

**Option 2: Pause Resources**
```bash
# Stop EC2 instances when not in use
aws ec2 stop-instances --instance-ids <EC2_IDS>

# Stop RDS instance (still charged for storage)
aws rds stop-db-instance --db-instance-identifier vpc-networking-mysql
```

**Option 3: Remove Expensive Components**
Comment out in `main.tf`:
- NAT Gateway module (~$32/month savings)
- ALB module (~$16/month savings)

### Cost Breakdown Per Hour:
- NAT Gateway: $0.045/hour
- ALB: $0.022/hour
- EC2 t3.micro (×2): $0.021/hour
- Bastion t3.nano: $0.005/hour
- RDS db.t3.micro: $0.017/hour
- **Total: ~$0.11/hour**

## 🧪 Testing Scenarios

### 1. Test Load Balancing
```bash
# Get ALB URL
ALB_URL=$(terraform output -raw alb_url)

# Send multiple requests
for i in {1..10}; do
  curl $ALB_URL
  echo ""
done
```

### 2. Test NAT Gateway
```bash
# SSH to private EC2
ssh -i vpc-networking-key.pem -J ec2-user@<BASTION_IP> ec2-user@<EC2_PRIVATE_IP>

# Test internet access (via NAT Gateway)
curl https://httpbin.org/ip
```

### 3. Test VPC Endpoint
```bash
# SSH to private EC2
# S3 traffic should go through VPC Endpoint, not NAT Gateway

aws s3 ls --region us-east-1

# Check route
curl https://ip-ranges.amazonaws.com/ip-ranges.json | jq -r '.prefixes[] | select(.service=="S3") | select(.region=="us-east-1") | .ip_prefix'
```

### 4. Test VPC Peering
```bash
# From VPC1 private EC2, try to reach VPC2 subnet
ping 10.20.1.10

# (Note: You'd need an instance in VPC2 for full testing)
```

### 5. Test Database Connection
```bash
# Via SSH tunnel from laptop
ssh -i vpc-networking-key.pem -L 3306:<RDS_ENDPOINT>:3306 ec2-user@<BASTION_IP>

# In another terminal
mysql -h 127.0.0.1 -P 3306 -u admin -p

# Test commands
SHOW DATABASES;
CREATE DATABASE testdb;
USE testdb;
CREATE TABLE users (id INT, name VARCHAR(50));
INSERT INTO users VALUES (1, 'Yongchae');
SELECT * FROM users;
```

## 🔧 Customization

### Change Instance Sizes
Edit `variables.tf`:
```hcl
variable "ec2_instance_type" {
  default = "t3.small"  # Change from t3.micro
}
```

### Add More EC2 Instances
Edit `main.tf`:
```hcl
module "ec2_instances" {
  ...
  private_subnet_ids = slice(module.subnets.private_subnet_ids, 0, 4) # Use all 4 subnets
}
```

### Change Region
Edit `variables.tf`:
```hcl
variable "aws_region" {
  default = "us-west-2"  # Change from us-east-1
}
```

## 🗑️ Cleanup

### Destroy All Resources
```bash
terraform destroy
```

⚠️ **Warning**: This will delete:
- All EC2 instances
- RDS database (data will be lost!)
- NAT Gateway and EIP
- Application Load Balancer
- VPC and all networking components
- S3 bucket (if empty)

### Partial Destroy
```bash
# Destroy specific module
terraform destroy -target=module.alb
terraform destroy -target=module.rds
```

## 📝 Important Notes

1. **SSH Key**: The private key file (`vpc-networking-key.pem`) is generated locally. Keep it safe!

2. **RDS Password**: Change the default password before applying!

3. **S3 Bucket Name**: Must be globally unique. Update in `variables.tf`.

4. **Security**: Update `your_ip_cidr` to restrict SSH access to your IP only.

5. **State File**: Stored remotely in Terraform Cloud (workspace: `vpc-networking`).

6. **Red Hat Instances**: Using official Red Hat AMI (requires Red Hat license for production).

## 🐛 Troubleshooting

### Issue: Terraform Cloud Credentials Error
```bash
# Solution: Login to Terraform Cloud
terraform login
```

### Issue: S3 Bucket Name Already Exists
```bash
# Solution: Change bucket name in variables.tf
s3_bucket_name = "yongchae-vpc-networking-bucket-unique-123"
```

### Issue: Cannot SSH to Bastion
```bash
# Solution: Check security group and your IP
terraform output bastion_public_ip
curl https://checkip.amazonaws.com  # Compare with your_ip_cidr
```

### Issue: Private EC2 Can't Access Internet
```bash
# Solution: Verify NAT Gateway is running
terraform output nat_gateway_id
aws ec2 describe-nat-gateways --nat-gateway-ids <NAT_GW_ID>
```

### Issue: RDS Connection Timeout
```bash
# Solution: Verify security group allows port 3306
# Check that you're using SSH tunnel or connecting from EC2
```

## 📚 Resources

- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Networking Best Practices](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-design.html)

## 🎓 Next Steps

After completing this setup, try:

1. Add Auto Scaling Group for EC2 instances
2. Enable RDS Multi-AZ for high availability
3. Add CloudWatch monitoring and alarms
4. Implement VPN connection (Site-to-Site VPN)
5. Add AWS WAF for ALB protection
6. Create Route53 hosted zone and records
7. Enable VPC Flow Logs
8. Add Systems Manager Session Manager

## 📞 Support

For Terraform certification study questions or infrastructure help, refer to your study materials and AWS documentation.

---

**Created for**: AWS Networking Practice & Terraform Certification Study  
**Author**: Yongchae  
**Last Updated**: 2025  
**Terraform Version**: >= 1.0  
**AWS Provider Version**: ~> 5.0

