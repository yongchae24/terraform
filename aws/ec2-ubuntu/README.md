# Ubuntu EC2 Practice Environment

Minimal Terraform configuration to create an Ubuntu EC2 instance (t3.nano) for command practice.

## Features

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
ssh -i ubuntu-practice-key.pem ubuntu@$(terraform output -raw public_ip)

# Or use the SSH command from output:
terraform output ssh_command

# Destroy when done practicing
terraform destroy
```

## Notes

- Default user: `ubuntu`
- Instance type: t3.nano (~$3.80/month)
- SSH key file: `ubuntu-practice-key.pem` (auto-generated, stored in current directory)
- Make sure you have AWS credentials configured

