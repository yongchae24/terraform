#!/bin/bash

# Terraform Auto Deploy Script
# This script runs terraform init, plan, and apply in sequence

set -e  # Exit on any error

echo "🚀 Starting Terraform Auto Deploy..."
echo "=================================="

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "❌ Error: main.tf not found. Please run this script from the terraform directory."
    exit 1
fi

# Step 1: Initialize Terraform
echo "📦 Step 1: Initializing Terraform..."
terraform init
echo "✅ Terraform initialized successfully!"
echo ""

# Step 2: Plan the deployment
echo "📋 Step 2: Planning deployment..."
terraform plan
echo "✅ Plan completed successfully!"
echo ""

# Step 3: Apply the configuration
echo "🔧 Step 3: Applying configuration..."
echo "⚠️  Creating AWS resources (t3.nano ~$4.60/month)..."
terraform apply -auto-approve
echo "✅ Deployment completed successfully!"
echo ""

echo "🎉 Your EC2 instance is now running!"
echo "📊 Check the outputs above for connection details."
echo ""
echo "🔗 Quick Access:"
PUBLIC_IP=$(terraform output -raw instance_public_ip)
echo "- Web Server: http://$PUBLIC_IP"
echo "- Status Page: http://$PUBLIC_IP/status.html"
echo ""
echo "�� To destroy resources: terraform destroy"