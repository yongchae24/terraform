variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "yongchae"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.10.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Subnet CIDR blocks
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24", "10.10.14.0/24"]
}

# Second VPC for peering
variable "vpc2_cidr" {
  description = "CIDR block for second VPC (for peering)"
  type        = string
  default     = "10.20.0.0/16"
}

variable "vpc2_subnet_cidr" {
  description = "CIDR block for second VPC subnet"
  type        = string
  default     = "10.20.1.0/24"
}

# EC2 Configuration
variable "bastion_instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "ec2_instance_type" {
  description = "Instance type for private EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_name" {
  description = "Name for SSH key pair"
  type        = string
  default     = "vpc-networking-key"
}

variable "your_ip_cidr" {
  description = "Your IP address CIDR for SSH access (get from whatismyip.com)"
  type        = string
  default     = "0.0.0.0/0" # CHANGE THIS to your IP for better security
}

# RDS Configuration
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "rds_database_name" {
  description = "Initial database name"
  type        = string
  default     = "myappdb"
}

variable "rds_username" {
  description = "RDS master username"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
  default     = "Change-Me-123456" # CHANGE THIS!
}

# S3 Configuration
variable "s3_bucket_name" {
  description = "S3 bucket name (must be globally unique)"
  type        = string
  default     = "yongchae-vpc-networking-bucket"
}

# Tags
variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Project     = "VPC-Networking-Practice"
    ManagedBy   = "Terraform"
    Environment = "Learning"
    Owner       = "Yongchae"
  }
}

