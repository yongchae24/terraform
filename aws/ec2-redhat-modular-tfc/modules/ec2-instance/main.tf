# Data source to get Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"] # Amazon official account

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# User data script (optional - Amazon Linux 2023 has EC2 Instance Connect pre-installed)
locals {
  user_data = <<-EOF
#!/bin/bash
# Amazon Linux 2023 comes with EC2 Instance Connect pre-installed
# Just ensure the system is updated
yum update -y

# Log completion
echo "User data script completed at $(date)" >> /var/log/user-data.log
EOF
}

# Create EC2 instance
resource "aws_instance" "amazon_linux" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  user_data              = base64encode(local.user_data)

  # Enable public IP
  associate_public_ip_address = true

  # Root volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = false
  }

  tags = var.tags
}
