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

# User data script to install Apache
locals {
  user_data = <<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from $(hostname)</h1>" > /var/www/html/index.html
EOF
}

# Private EC2 Instances
resource "aws_instance" "private" {
  count = length(var.private_subnet_ids)

  ami                    = data.aws_ami.redhat.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_ids[count.index]
  vpc_security_group_ids = [var.security_group_id]
  user_data              = local.user_data

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 10
    delete_on_termination = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ec2-${count.index + 1}"
      Role = "WebServer"
    }
  )
}

