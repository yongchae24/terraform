# SSH Key Pair Module
module "ssh_key" {
  source = "./modules/ssh-key"

  key_name = var.ssh_key_name
  tags     = var.common_tags
}

# VPC Module (includes Internet Gateway)
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  tags         = var.common_tags
}

# Subnets Module
module "subnets" {
  source = "./modules/subnets"

  vpc_id               = module.vpc.vpc_id
  project_name         = var.project_name
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  tags                 = var.common_tags

  depends_on = [module.vpc]
}

# NAT Gateway Module (in Public Subnet 2)
module "nat_gateway" {
  source = "./modules/nat-gateway"

  project_name     = var.project_name
  public_subnet_id = module.subnets.public_subnet_ids[1] # Public Subnet 2
  igw_id           = module.vpc.igw_id
  tags             = var.common_tags

  depends_on = [module.vpc, module.subnets]
}

# Route Tables Module
module "route_tables" {
  source = "./modules/route-tables"

  vpc_id             = module.vpc.vpc_id
  project_name       = var.project_name
  igw_id             = module.vpc.igw_id
  nat_gateway_id     = module.nat_gateway.nat_gateway_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  tags               = var.common_tags

  depends_on = [module.nat_gateway]
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id        = module.vpc.vpc_id
  project_name  = var.project_name
  your_ip_cidr  = var.your_ip_cidr
  tags          = var.common_tags

  depends_on = [module.vpc]
}

# Bastion Host Module
module "bastion" {
  source = "./modules/bastion"

  project_name      = var.project_name
  instance_type     = var.bastion_instance_type
  key_name          = module.ssh_key.key_name
  public_subnet_id  = module.subnets.public_subnet_ids[0] # Public Subnet 1
  security_group_id = module.security_groups.bastion_sg_id
  tags              = var.common_tags

  depends_on = [module.ssh_key, module.security_groups]
}

# EC2 Instances Module (2 instances in first 2 private subnets)
module "ec2_instances" {
  source = "./modules/ec2-instances"

  project_name       = var.project_name
  instance_type      = var.ec2_instance_type
  key_name           = module.ssh_key.key_name
  private_subnet_ids = slice(module.subnets.private_subnet_ids, 0, 2) # First 2 private subnets
  security_group_id  = module.security_groups.ec2_sg_id
  tags               = var.common_tags

  depends_on = [module.ssh_key, module.security_groups, module.nat_gateway]
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.security_groups.alb_sg_id
  public_subnet_ids = module.subnets.public_subnet_ids
  instance_ids      = module.ec2_instances.instance_ids
  tags              = var.common_tags

  depends_on = [module.ec2_instances]
}

# RDS MySQL Module (in Private Subnet 3)
module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  private_subnet_ids = [module.subnets.private_subnet_ids[2], module.subnets.private_subnet_ids[3]] # Subnet 3 & 4 for subnet group
  security_group_id  = module.security_groups.rds_sg_id
  instance_class     = var.rds_instance_class
  allocated_storage  = var.rds_allocated_storage
  engine_version     = var.rds_engine_version
  database_name      = var.rds_database_name
  username           = var.rds_username
  password           = var.rds_password
  tags               = var.common_tags

  depends_on = [module.security_groups]
}

# S3 Bucket Module
module "s3" {
  source = "./modules/s3"

  bucket_name = var.s3_bucket_name
  tags        = var.common_tags
}

# VPC Endpoint Gateway Module (for S3)
module "vpc_endpoint" {
  source = "./modules/vpc-endpoint"

  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  region                 = var.aws_region
  private_route_table_id = module.route_tables.private_route_table_id
  tags                   = var.common_tags

  depends_on = [module.route_tables, module.s3]
}

# VPC Peering Module
module "vpc_peering" {
  source = "./modules/vpc-peering"

  project_name                = var.project_name
  vpc1_id                     = module.vpc.vpc_id
  vpc1_cidr                   = module.vpc.vpc_cidr
  vpc1_private_route_table_id = module.route_tables.private_route_table_id
  vpc2_cidr                   = var.vpc2_cidr
  vpc2_subnet_cidr            = var.vpc2_subnet_cidr
  availability_zone           = var.availability_zones[0]
  tags                        = var.common_tags

  depends_on = [module.route_tables]
}

