# Create security group for EC2 instance
resource "aws_security_group" "redhat_sg" {
  name_prefix = "redhat-ec2-"
  vpc_id      = var.vpc_id

  # SSH access for EC2 Instance Connect (from AWS EC2 Instance Connect service)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # EC2 Instance Connect can come from anywhere
    description = "SSH for EC2 Instance Connect"
  }

  # ICMP (ping) from other EC2 instances in the same VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
    description = "ICMP (ping) from VPC"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = var.tags
}
