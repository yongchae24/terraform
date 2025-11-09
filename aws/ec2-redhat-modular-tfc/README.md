# EC2 RedHat Modular - Remote Backend (S3)

Modular Terraform configuration for creating an Amazon Linux 2023 EC2 instance (RHEL-based) with **S3 remote backend** for state management.

## Key Differences from Local Backend Version

- **Remote Backend**: State stored in S3 (not local `terraform.tfstate` file)
- **State Management**: State is stored remotely in AWS S3 bucket
- **Team Ready**: Can be easily shared with team members (add DynamoDB for state locking)

## Prerequisites

**IMPORTANT: Create S3 bucket before running terraform init**

1. Create an S3 bucket for Terraform state:
   ```bash
   aws s3 mb s3://your-terraform-state-bucket --region us-east-1
   ```

2. Enable versioning (recommended):
   ```bash
   aws s3api put-bucket-versioning \
     --bucket your-terraform-state-bucket \
     --versioning-configuration Status=Enabled
   ```

3. Enable encryption (recommended):
   ```bash
   aws s3api put-bucket-encryption \
     --bucket your-terraform-state-bucket \
     --server-side-encryption-configuration '{
       "Rules": [{
         "ApplyServerSideEncryptionByDefault": {
           "SSEAlgorithm": "AES256"
         }
       }]
     }'
   ```

4. Update `backend.tf` with your bucket name:
   ```hcl
   bucket = "your-terraform-state-bucket"  # Replace with your bucket name
   ```

## Structure

```
ec2-redhat-modular-remote-backend/
├── backend.tf         # S3 remote backend configuration
├── main.tf            # Root module - calls child modules
├── providers.tf      # Provider configuration
├── variables.tf      # Root variables
├── outputs.tf        # Root outputs
└── modules/
    ├── ssh-key/      # SSH key generation module
    ├── security-group/ # Security group module
    └── ec2-instance/ # EC2 instance module
```

## Features

- **Remote State**: State stored in S3 (no local `terraform.tfstate` file)
- **Modular architecture**: Separated into reusable modules
- **Auto-generated SSH keys**: SSH key pair is automatically created and saved locally
- **Ready to use**: After `terraform apply`, you can immediately SSH into the instance
- **Automatic cleanup**: Key pair is removed when you run `terraform destroy`
- **S3 Backend**: State management in AWS S3

## Usage

```bash
# Step 1: Create S3 bucket (see Prerequisites above)
# Step 2: Update backend.tf with your bucket name

# Step 3: Initialize Terraform
terraform init

# Step 4: Plan the deployment
terraform plan

# Step 5: Create the instance (SSH keys will be auto-generated)
terraform apply

# Wait a moment for the instance to boot, then SSH:
ssh -i redhat-practice-key.pem ec2-user@$(terraform output -raw public_ip)

# Destroy when done practicing
terraform destroy
```

## Backend Configuration

The state file will be stored at:
```
S3 Bucket: your-terraform-state-bucket
└── ec2-redhat-modular/terraform.tfstate
```

**Note**: No DynamoDB table is configured (working alone). If you need state locking for team collaboration, add:
```hcl
dynamodb_table = "terraform-state-lock"
```

## Modules

### SSH Key Module
- Generates RSA key pair
- Saves private key locally
- Uploads public key to AWS

### Security Group Module
- Creates security group with SSH access
- Configurable CIDR blocks

### EC2 Instance Module
- Creates EC2 instance with Amazon Linux 2023
- Handles AMI lookup
- Configures root volume

## Notes

- Default user: `ec2-user`
- Instance type: t3.nano (~$3.80/month)
- Root volume: 30GB minimum (Amazon Linux 2023 requirement)
- SSH key file: `redhat-practice-key.pem` (auto-generated, stored in root directory)
- State file: Stored in S3 (not locally)
- Make sure you have AWS credentials configured

## Benefits of Remote Backend

- **Centralized State**: State stored in S3, accessible from anywhere
- **Backup**: S3 versioning provides automatic backups
- **Team Collaboration**: Can be shared with team (add DynamoDB for locking)
- **Security**: Encryption at rest in S3
- **No Local State File**: No `terraform.tfstate` file in project directory

## Adding State Locking (Optional)

If you need state locking for team collaboration:

1. Create DynamoDB table:
   ```bash
   aws dynamodb create-table \
     --table-name terraform-state-lock \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST
   ```

2. Update `backend.tf`:
   ```hcl
   dynamodb_table = "terraform-state-lock"
   ```
