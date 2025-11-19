# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  tags     = var.common_tags
}

# Subnets Module
module "subnets" {
  source = "./modules/subnets"

  vpc_id              = module.vpc.vpc_id
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  availability_zone   = var.availability_zone
  tags                = var.common_tags

  depends_on = [module.vpc]
}

# Internet Gateway Module
module "internet_gateway" {
  source = "./modules/internet-gateway"

  vpc_id = module.vpc.vpc_id
  tags   = var.common_tags

  depends_on = [module.vpc]
}

# Route Tables Module
module "route_tables" {
  source = "./modules/route-tables"

  vpc_id            = module.vpc.vpc_id
  igw_id            = module.internet_gateway.igw_id
  public_subnet_id  = module.subnets.public_subnet_id
  private_subnet_id = module.subnets.private_subnet_id
  tags              = var.common_tags

  depends_on = [module.subnets, module.internet_gateway]
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = module.vpc.vpc_cidr
  allowed_ssh_cidr = var.allowed_ssh_cidr
  tags             = var.common_tags

  depends_on = [module.vpc]
}

