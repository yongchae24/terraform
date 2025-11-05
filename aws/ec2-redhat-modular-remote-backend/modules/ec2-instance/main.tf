# Data source to get Amazon Linux 2023 AMI (RHEL-based, free)
data "aws_ami" "redhat" {
  most_recent = true
  owners      = ["amazon"]

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

# Create EC2 instance
resource "aws_instance" "redhat" {
  ami                    = data.aws_ami.redhat.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  # Enable public IP
  associate_public_ip_address = true

  # Root volume (Amazon Linux 2023 requires minimum 30GB)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = false
  }

  tags = var.tags
}

