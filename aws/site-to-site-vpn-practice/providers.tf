terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Site-to-Site-VPN-Practice"
      Environment = "learning"
      ManagedBy   = "Terraform"
      Owner       = "yongchae"
      Purpose     = "interview-preparation"
    }
  }
}

