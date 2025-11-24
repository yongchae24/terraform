# EKS Minimal Practice Configuration
# This is a minimal-cost EKS setup for interview preparation and hands-on practice
#
# Architecture:
# - VPC with public subnets (no NAT Gateway to save cost)
# - EKS Control Plane (managed by AWS)
# - 2x t3.small worker nodes in public subnets
# - All necessary IAM roles and security groups
#
# Estimated Cost: ~$103/month (destroy when not using!)
# - Control Plane: $0.10/hr (~$73/month)
# - Worker Nodes: 2 x t3.small = ~$30/month
#
# Created: 2025-11-23
# Purpose: Terraform + Kubernetes interview preparation

locals {
  common_tags = {
    Project     = "EKS-Minimal-Practice"
    Environment = "learning"
    ManagedBy   = "Terraform"
    Owner       = "yongchae"
    Purpose     = "interview-preparation"
    CostCenter  = "learning"
  }

  cluster_name = var.cluster_name
  region       = var.aws_region
}

