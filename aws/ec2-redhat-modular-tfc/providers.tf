terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {                     # Local name (used everywhere else)
      source  = "hashicorp/aws" # Source address (only here in required_providers)
      version = "~> 5.0"
    }
    tls = {                     # Local name
      source  = "hashicorp/tls" # Source address
      version = "~> 4.0"
    }
    vault = {                     # Local name
      source  = "hashicorp/vault" # Source address
      version = "~> 3.0"
    }
  }
}

provider "aws" { # Local name only (outside required_providers)
  region = var.aws_region
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}
