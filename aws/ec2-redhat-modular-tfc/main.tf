# Get default VPC (cost-free)
data "aws_vpc" "default" {
  default = true
}

# Get default subnets (cost-free)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group for EC2 Instance 1
module "security_group_1" {
  source = "./modules/security-group"

  vpc_id   = data.aws_vpc.default.id
  vpc_cidr = data.aws_vpc.default.cidr_block

  tags = {
    Name = "amazon-linux-sg-1"
  }
}

# Security Group for EC2 Instance 2
module "security_group_2" {
  source = "./modules/security-group"

  vpc_id   = data.aws_vpc.default.id
  vpc_cidr = data.aws_vpc.default.cidr_block

  tags = {
    Name = "amazon-linux-sg-2"
  }
}

# EC2 Instance 1
module "ec2_instance_1" {
  source = "./modules/ec2-instance"

  instance_type     = var.instance_type
  security_group_id = module.security_group_1.security_group_id
  subnet_id         = data.aws_subnets.default.ids[0]
  root_volume_size  = var.root_volume_size

  tags = {
    Name = "amazon-linux-instance-1"
    OS   = "Amazon Linux 2023"
  }

  depends_on = [
    module.security_group_1
  ]
}

# EC2 Instance 2
module "ec2_instance_2" {
  source = "./modules/ec2-instance"

  instance_type     = var.instance_type
  security_group_id = module.security_group_2.security_group_id
  subnet_id         = data.aws_subnets.default.ids[0]
  root_volume_size  = var.root_volume_size

  tags = {
    Name = "amazon-linux-instance-2"
    OS   = "Amazon Linux 2023"
  }

  depends_on = [
    module.security_group_2
  ]
}
