terraform {
  backend "s3" {
    # IMPORTANT: Replace 'your-terraform-state-bucket' with your actual S3 bucket name
    # The bucket must be created before running terraform init
    bucket  = "s3-bucket-yongchae-terraform"
    key     = "ec2-redhat-modular/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true

    # Note: No DynamoDB table for state locking (working alone)
    # If you need state locking later, add:
    # dynamodb_table = "terraform-state-lock"
  }
}

