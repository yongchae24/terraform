terraform {
  cloud {
    organization = "yongchae-terraform"

    workspaces {
      name = "eks-minimal-practice"
    }
  }
}

