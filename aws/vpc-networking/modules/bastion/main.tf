# Get latest Red Hat AMI
data "aws_ami" "redhat" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat official account

  filter {
    name   = "name"
    values = ["RHEL-9*_HVM-*-x86_64-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.redhat.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-bastion"
      Role = "Bastion"
    }
  )
}

