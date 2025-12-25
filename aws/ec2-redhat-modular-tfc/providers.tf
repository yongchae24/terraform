terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {                     # Local name (used everywhere else)
      source  = "hashicorp/aws" # Source address (only here in required_providers)
      version = "~> 5.0"
    }
  }
}

provider "aws" { # Local name only (outside required_providers)
  region = var.aws_region
}
