# Quick Start Guide

## ⚡ Fast Track Setup

### Before You Start (5 minutes)

1. **Create Terraform Cloud Workspace**
   - Go to: https://app.terraform.io
   - Organization: `yongchae-terraform`
   - Workspace name: `vpc-networking`

2. **Add AWS Credentials**
   - Go to workspace → Variables
   - Add **Environment Variables**:
     - `AWS_ACCESS_KEY_ID` (✓ Sensitive)
     - `AWS_SECRET_ACCESS_KEY` (✓ Sensitive)
     - `AWS_DEFAULT_REGION` = `us-east-1`

3. **Update Variables** (in `variables.tf`)
   ```bash
   # Change these before applying:
   your_ip_cidr       = "<YOUR_IP>/32"  # Get from: curl https://checkip.amazonaws.com
   rds_password       = "YourSecurePassword123!"
   s3_bucket_name     = "your-unique-bucket-name-12345"
   ```

### Launch Infrastructure (20 minutes)

```bash
cd /Users/yongchae.ko/Documents/projects/terraform/aws/vpc-networking

# Initialize
terraform init

# Review what will be created
terraform plan

# Create everything
terraform apply

# Wait ~15-20 minutes (RDS is slow)
```

### Access Your Resources

```bash
# Get all important outputs
terraform output

# SSH to bastion
terraform output -raw ssh_to_bastion_command | bash

# SSH to private EC2 (copy command from output)
terraform output ssh_to_ec2_via_bastion

# Access Load Balancer
terraform output -raw alb_url
# Open in browser

# Connect to MySQL via tunnel
terraform output -raw mysql_tunnel_command
# Then use MySQL Workbench: localhost:3306
```

### Practice & Learn (2-4 hours)

**Test Load Balancing:**
```bash
ALB_URL=$(terraform output -raw alb_url)
for i in {1..10}; do curl $ALB_URL && echo ""; done
```

**Test Database:**
```bash
# Create tunnel (from output command)
terraform output -raw mysql_tunnel_command

# In another terminal:
mysql -h 127.0.0.1 -P 3306 -u admin -p
> SHOW DATABASES;
> CREATE DATABASE testdb;
> USE testdb;
> CREATE TABLE users (id INT, name VARCHAR(50));
> INSERT INTO users VALUES (1, 'Yongchae');
> SELECT * FROM users;
```

**Test S3 via VPC Endpoint:**
```bash
# SSH to private EC2
ssh -i vpc-networking-key.pem -J ec2-user@<BASTION> ec2-user@<PRIVATE_EC2>

# List S3 buckets (goes through VPC Endpoint, not internet!)
aws s3 ls
```

### Destroy Everything

```bash
terraform destroy
# Type: yes

# Verify in AWS Console that everything is gone
```

## 💰 Cost Calculator

| Duration | Estimated Cost |
|----------|----------------|
| 1 hour   | $0.11 |
| 2 hours  | $0.22 |
| 4 hours  | $0.44 |
| 8 hours  | $0.88 |
| 24 hours | $2.64 |
| 1 week   | $18.48 |
| 1 month  | $79.20 |

**💡 Tip**: Destroy after each practice session to save money!

## ⚠️ Common Issues

**Issue**: `Error: No valid credential sources`
```bash
# Fix: Add AWS credentials in Terraform Cloud workspace variables
```

**Issue**: `S3 bucket already exists`
```bash
# Fix: Change s3_bucket_name in variables.tf to something unique
```

**Issue**: `Cannot connect to bastion`
```bash
# Fix: Update your_ip_cidr in variables.tf with your current IP
curl https://checkip.amazonaws.com
```

## 📋 Checklist

- [ ] Created Terraform Cloud workspace: `vpc-networking`
- [ ] Added AWS credentials as environment variables
- [ ] Updated `your_ip_cidr` with my IP address
- [ ] Changed `rds_password` to secure password
- [ ] Changed `s3_bucket_name` to unique name
- [ ] Ran `terraform init`
- [ ] Ran `terraform plan` (reviewed resources)
- [ ] Ran `terraform apply` (created infrastructure)
- [ ] Tested SSH to bastion
- [ ] Tested SSH to private EC2
- [ ] Tested ALB URL in browser
- [ ] Tested MySQL connection
- [ ] Tested S3 access from EC2
- [ ] Ran `terraform destroy` (cleaned up)

## 🎯 What You'll Learn

After completing this exercise, you'll understand:

✅ VPC design with public/private subnets  
✅ Internet Gateway vs NAT Gateway  
✅ Bastion host for secure SSH access  
✅ Application Load Balancer configuration  
✅ RDS MySQL in private subnet  
✅ VPC Endpoint for S3 (AWS PrivateLink)  
✅ VPC Peering between two VPCs  
✅ Security groups and network ACLs  
✅ Route tables and associations  
✅ SSH tunneling for database access  
✅ Terraform modules and dependencies  
✅ Terraform Cloud remote state  

---

**Ready? Let's build! 🚀**

```bash
cd /Users/yongchae.ko/Documents/projects/terraform/aws/vpc-networking
terraform init
```

