# EC2 RedHat Modular - Practice Environment

Modular Terraform configuration for creating an Amazon Linux 2023 EC2 instance (RHEL-based) for command practice.

## Structure

This project uses Terraform modules for better organization:

```
ec2-redhat-modular/
├── main.tf              # Root module - calls child modules
├── providers.tf         # Provider configuration
├── variables.tf         # Root variables
├── outputs.tf          # Root outputs
└── modules/
    ├── ssh-key/        # SSH key generation module
    ├── security-group/ # Security group module
    └── ec2-instance/   # EC2 instance module
```

## Features

- **Modular architecture**: Separated into reusable modules
- **Auto-generated SSH keys**: SSH key pair is automatically created and saved locally
- **Ready to use**: After `terraform apply`, you can immediately SSH into the instance
- **Automatic cleanup**: Key pair is removed when you run `terraform destroy`

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Create the instance (SSH keys will be auto-generated)
terraform apply

# Wait a moment for the instance to boot, then SSH:
ssh -i redhat-practice-key.pem ec2-user@$(terraform output -raw public_ip)

# Destroy when done practicing
terraform destroy
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
- Make sure you have AWS credentials configured

## Benefits of Modular Structure

- **Reusability**: Modules can be reused in other projects
- **Maintainability**: Easier to update individual components
- **Testability**: Each module can be tested independently
- **Organization**: Clear separation of concerns
- **Industry standard**: Matches production patterns

