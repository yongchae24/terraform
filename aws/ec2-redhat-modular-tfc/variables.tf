variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (t3.small for better performance)"
  type        = string
  default     = "t3.small"
}

variable "root_volume_size" {
  description = "Size of the root volume in GB (Red Hat minimum 10GB)"
  type        = number
  default     = 20
}

variable "key_pair_name" {
  description = "Name for the SSH key pair that will be auto-generated"
  type        = string
  default     = "redhat-practice-key"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH (use your IP like '1.2.3.4/32' or '0.0.0.0/0' for anywhere). Use '0.0.0.0/0' for practice, restrict IP for better security."
  type        = string
  default     = "0.0.0.0/0"
}
