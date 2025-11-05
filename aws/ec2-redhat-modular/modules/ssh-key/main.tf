# Generate SSH key pair for EC2 access
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save private key to local file (in root directory)
resource "local_file" "private_key" {
  content         = tls_private_key.ec2_key.private_key_pem
  filename        = "${path.root}/${var.key_pair_name}.pem"
  file_permission = "0400"

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

