# Generate SSH key pair for EC2 access
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Store private key in Vault (not in Terraform state)
resource "vault_kv_secret_v2" "ssh_key" {
  mount = "secret"
  name  = "ec2/ssh-keys/${var.key_pair_name}"

  data_json = jsonencode({
    private_key = tls_private_key.ec2_key.private_key_pem
    public_key  = tls_private_key.ec2_key.public_key_openssh
  })

  depends_on = [tls_private_key.ec2_key]
}

# Upload public key to AWS
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.ec2_key.public_key_openssh

  tags = {
    Name = "${var.key_pair_name}-key"
  }
}
