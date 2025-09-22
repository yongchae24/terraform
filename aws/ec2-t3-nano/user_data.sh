#!/bin/bash

# Update system packages
sudo yum update -y

# Install essential tools including curl
sudo yum install -y httpd curl wget unzip

# Install and configure web server
sudo systemctl start httpd
sudo systemctl enable httpd

# Create simple web page for verification
sudo tee /var/www/html/index.html > /dev/null << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>AWS EC2 Instance - Cost Optimized</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
        .header { background: #f4f4f4; padding: 20px; border-radius: 5px; }
        .info { margin: 20px 0; }
        .code { background: #f8f8f8; padding: 10px; border-radius: 3px; font-family: monospace; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>AWS EC2 Instance</h1>
            <p>Successfully deployed using Terraform!</p>
        </div>
        
        <div class="info">
            <h2>Instance Information</h2>
            <p><strong>Instance ID:</strong> $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
            <p><strong>Public IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)</p>
            <p><strong>Private IP:</strong> $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</p>
            <p><strong>Region:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/region)</p>
            <p><strong>Availability Zone:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
            <p><strong>Instance Type:</strong> t3.nano (Cost Optimized)</p>
        </div>
        
        <div class="info">
            <h2>Cost Information</h2>
            <p>This instance is configured for maximum cost efficiency:</p>
            <ul>
                <li>t3.nano instance type (~$3.80/month)</li>
                <li>8GB root volume (minimum required)</li>
                <li>Default VPC (free)</li>
                <li>Dynamic public IP (free)</li>
            </ul>
        </div>
    </div>
</body>
</html>
EOF

# Set proper permissions
sudo chown -R apache:apache /var/www/html

# Log completion
echo "User data script completed at $(date)" | sudo tee -a /var/log/user-data.log