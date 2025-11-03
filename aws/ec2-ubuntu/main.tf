# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

# Generate SSH key pair for EC2 access
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save private key to local file
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.module}/${var.key_pair_name}.pem"
  file_permission = "0400"
}

# Upload public key to AWS
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name = "${var.key_pair_name}-key"
  }
}

# Data source to get the latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Get default VPC (cost-free)
data "aws_vpc" "default" {
  default = true
}

# Get default subnets (cost-free)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create security group for SSH access
resource "aws_security_group" "ubuntu_sg" {
  name_prefix = "ubuntu-ec2-"
  vpc_id      = data.aws_vpc.default.id

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "ubuntu-ec2-sg"
  }
}

# Create Ubuntu EC2 instance
resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.ec2_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.ubuntu_sg.id]
  subnet_id              = data.aws_subnets.default.ids[0]

  # Enable public IP
  associate_public_ip_address = true

  # Minimal root volume (8GB minimum)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = false
  }

  tags = {
    Name = "ubuntu-ec2-practice"
    OS   = "Ubuntu"
  }
}

