terraform {
  cloud {
    organization = "yongchae-terraform"

    workspaces {
      name = "ec2-redhat-modular"
    }
  }
}
