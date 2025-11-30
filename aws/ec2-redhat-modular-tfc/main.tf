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

# Module: SSH Key
module "ssh_key" {
  source = "git::https://github.com/yongchae24/terraform.git//aws/ec2-redhat-modular-tfc/modules/ssh-key?ref=v1.0.0"

  key_pair_name = var.key_pair_name
}

# Module: Security Group
module "security_group" {
  source = "git::https://github.com/yongchae24/terraform.git//aws/ec2-redhat-modular-tfc/modules/security-group?ref=v1.0.0"

  vpc_id           = data.aws_vpc.default.id
  allowed_ssh_cidr = var.allowed_ssh_cidr

  tags = {
    Name = "redhat-ec2-sg"
  }
}

# Module: EC2 Instance
module "ec2_instance" {
  source = "git::https://github.com/yongchae24/terraform.git//aws/ec2-redhat-modular-tfc/modules/ec2-instance?ref=v1.0.0"

  instance_type     = var.instance_type
  key_name          = module.ssh_key.key_name
  security_group_id = module.security_group.security_group_id
  subnet_id         = data.aws_subnets.default.ids[0]
  root_volume_size  = var.root_volume_size
  private_key_path  = module.ssh_key.private_key_path

  tags = {
    Name = "redhat-ec2-practice"
    OS   = "Red Hat Enterprise Linux 9"
  }

  depends_on = [
    module.ssh_key,
    module.security_group
  ]
}
