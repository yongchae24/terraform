# Azure Linux Minimal Practice Configuration
# Cost-optimized setup for learning and interview preparation
#
# Architecture:
# - Resource Group
# - Virtual Network + Subnet
# - Network Security Group (like AWS Security Group)
# - RedHat Linux VM (B2s - minimal cost)
# - OS Disk (Standard HDD)
# - Data Disk (like AWS EBS) - can attach to VM
# - Public IP for SSH access
#
# Estimated Cost: ~$30-35/month (destroy when not using!)
# - VM B2s: ~$30/month
# - Disks: ~$3/month
# - Network: ~$1/month
#
# Created: 2025-11-24
# Purpose: Azure + Terraform interview preparation

locals {
  common_tags = {
    Project     = "Azure-Linux-Practice"
    Environment = "learning"
    ManagedBy   = "Terraform"
    Owner       = "yongchae"
    Purpose     = "interview-preparation"
  }

  resource_prefix = "practice"
}

