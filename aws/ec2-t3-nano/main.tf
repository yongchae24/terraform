
# Configure the AWS Provider
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  # Default tags for cost tracking
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = var.owner
      CostCenter  = var.cost_center
    }
  }
}

# Data source to get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
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

# Create minimal security group for EC2 instance
# Cost: $0 (security groups are free)
resource "aws_security_group" "ec2_sg" {
  name_prefix = "${var.project_name}-ec2-"
  vpc_id      = data.aws_vpc.default.id

  # SSH access (restrict to your IP in production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # HTTP access for web server
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
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
    Name = "${var.project_name}-ec2-sg"
  }
}

# Create EC2 instance with minimal configuration
# Cost: ~$3.80/month (t3.nano only)
resource "aws_instance" "main" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  subnet_id              = data.aws_subnets.default.ids[0]

  # Enable public IP (free with default VPC)
  associate_public_ip_address = true

  # Disable monitoring to save costs
  monitoring = false

  # User data for initial setup
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    project_name = var.project_name
  }))

  # Minimal root volume (8GB minimum)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = false # Disable encryption to save costs

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  tags = {
    Name          = "ec2-instance-t3-nano"
    Type          = "EC2"
    InstanceType  = var.instance_type
    CostOptimized = "true"
  }
}
