# Generate SSH key pair
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Save private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.main.private_key_pem
  filename        = "${path.root}/${var.key_name}.pem"
  file_permission = "0400"
}

# Create AWS key pair
resource "aws_key_pair" "main" {
  key_name   = var.key_name
  public_key = tls_private_key.main.public_key_openssh

  tags = merge(
    var.tags,
    {
      Name = var.key_name
    }
  )
}

