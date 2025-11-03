# Amazon Linux 2023 EC2 Practice Environment (RHEL-based)

Minimal Terraform configuration to create an Amazon Linux 2023 EC2 instance (t3.nano) for command practice.
Amazon Linux 2023 is RHEL-based and uses the same commands as Red Hat Enterprise Linux (yum, systemctl, etc.).

## Usage

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Create the instance
terraform apply

# Get connection info
terraform output ssh_command

# SSH into the instance
ssh ec2-user@<public-ip>

# Destroy when done practicing
terraform destroy
```

## Notes

- Default user: `ec2-user`
- Instance type: t3.nano (~$3.80/month)
- Make sure you have AWS credentials configured

