# Data source to get Red Hat Enterprise Linux 9 AMI
data "aws_ami" "redhat" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat official account

  filter {
    name   = "name"
    values = ["RHEL-9*_HVM-*-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Get private key from Vault
data "vault_kv_secret_v2" "ssh_key" {
  mount = "secret"
  name  = replace(var.vault_secret_path, "secret/data/", "")
}

# Create EC2 instance
resource "aws_instance" "redhat" {
  ami                    = data.aws_ami.redhat.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  # Enable public IP
  associate_public_ip_address = true

  # Root volume (Red Hat Linux minimum 10GB)
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = false
  }

  # SSH connection for remote-exec
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = jsondecode(data.vault_kv_secret_v2.ssh_key.data_json).private_key
    host        = self.public_ip
    timeout     = "2m"
  }

  # Lightweight remote-exec commands (practice only)
  provisioner "remote-exec" {
    inline = [
      # 1. Display system information (instant)
      "echo '=== System Info ==='",
      "hostname",
      "uname -a",
      "cat /etc/redhat-release",

      # 2. Create practice directory (instant)
      "mkdir -p ~/terraform-practice",
      "echo 'Terraform remote-exec practice directory created' > ~/terraform-practice/README.txt",

      # 3. Log instance creation (instant)
      "echo 'Instance created at $(date)' >> ~/terraform-practice/creation.log",
      "echo 'Public IP: ${self.public_ip}' >> ~/terraform-practice/creation.log",

      # 4. Set environment variable (instant)
      "echo 'export TERRAFORM_MANAGED=true' >> ~/.bashrc",

      # 5. Display completion message (instant)
      "echo 'Remote-exec provisioning completed successfully!'"
    ]
  }

  tags = var.tags
}
