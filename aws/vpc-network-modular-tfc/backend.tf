terraform {
  cloud {
    organization = "yongchae-terraform"
    
    workspaces {
      name = "vpc-network-modular"
    }
  }
}

