# Azure Linux Minimal Practice - Interview Preparation

Cost-optimized Azure infrastructure with Red Hat Enterprise Linux for Terraform interview preparation.

## 📊 Architecture

```
Azure Resource Group
│
├── Virtual Network (10.0.0.0/16)
│   └── Subnet (10.0.1.0/24)
│
├── Network Security Group (NSG)
│   ├── Allow SSH (port 22)
│   └── Allow Outbound
│
├── Public IP (Static)
│
├── Network Interface
│
├── Linux VM (Red Hat Enterprise Linux 9)
│   ├── Size: B2s (2 vCPU, 4 GB RAM)
│   ├── OS Disk: 30 GB Standard HDD
│   └── SSH Key authentication
│
└── Data Disk (32 GB Standard HDD)
    └── Attached to VM (like AWS EBS)
```

## 💰 Cost Breakdown

| Resource | Cost | Notes |
|----------|------|-------|
| VM (B2s) | ~$30/month | 2 vCPU, 4 GB RAM |
| OS Disk (30 GB) | ~$1.50/month | Standard HDD |
| Data Disk (32 GB) | ~$1.50/month | Standard HDD |
| Public IP | ~$0.50/month | Static Basic IP |
| Network (VNet/NSG) | Free | No charge |
| **Total** | **~$33/month** | **Destroy when not using!** |

### Cost Saving Tips:
```bash
# Practice 4 hours/day = ~$4.40/month
# Weekend only = ~$9/month
# Always destroy after practice!
terraform destroy
```

## 📋 Prerequisites

### 1. Install Required Tools

```bash
# Azure CLI
brew install azure-cli

# Terraform
brew install terraform

# Verify installations
az --version
terraform --version
```

### 2. Azure Authentication

```bash
# Login to Azure
az login

# Set subscription (if you have multiple)
az account list --output table
az account set --subscription "<subscription-id>"

# Verify
az account show
```

### 3. Create SSH Key Pair (if you don't have one)

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa

# This creates:
# - ~/.ssh/id_rsa (private key)
# - ~/.ssh/id_rsa.pub (public key)

# Verify public key exists
ls -la ~/.ssh/id_rsa.pub
```

## 🚀 Deployment Steps

### Step 1: Initialize Terraform

```bash
cd /Users/yongchae.ko/Documents/projects/terraform/azure/linux-minimal-practice

# Initialize Terraform
terraform init
```

### Step 2: Review the Plan

```bash
# See what will be created
terraform plan

# You should see:
# - Resource Group
# - Virtual Network & Subnet
# - Network Security Group
# - Public IP
# - Network Interface
# - Linux VM (RHEL 9)
# - OS Disk
# - Data Disk
```

### Step 3: Deploy Infrastructure

```bash
# Apply the configuration
terraform apply

# Type: yes

# ⏰ This will take 3-5 minutes!
```

### Step 4: Get Connection Info

```bash
# Get SSH command
terraform output ssh_command

# Get Public IP
terraform output vm_public_ip

# Example output:
# ssh azureuser@20.123.45.67
```

### Step 5: Connect to VM

```bash
# SSH into your VM
ssh azureuser@<PUBLIC_IP>

# Or use the output command directly:
$(terraform output -raw ssh_command)

# First time connection will ask to verify fingerprint:
# Type: yes
```

## 🗄️ Mount Data Disk

After SSH into the VM, mount the data disk:

```bash
# 1. List available disks
lsblk

# You'll see:
# NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
# sda      8:0    0  30G  0 disk           <- OS disk
# ├─sda1   8:1    0  30G  0 part /
# sdb      8:16   0   8G  0 disk           <- Temporary disk
# sdc      8:32   0  32G  0 disk           <- Your data disk (unmounted)

# 2. Partition the data disk (sdc)
sudo fdisk /dev/sdc
# Commands:
# n (new partition)
# p (primary)
# 1 (partition number)
# Enter (default first sector)
# Enter (default last sector)
# w (write changes)

# 3. Create ext4 filesystem
sudo mkfs.ext4 /dev/sdc1

# 4. Create mount point
sudo mkdir -p /mnt/data

# 5. Mount the disk
sudo mount /dev/sdc1 /mnt/data

# 6. Verify mount
df -h | grep data
# Should show: /dev/sdc1  31G  ... /mnt/data

# 7. Set permissions
sudo chown -R azureuser:azureuser /mnt/data

# 8. Test write access
echo "Hello from data disk!" > /mnt/data/test.txt
cat /mnt/data/test.txt

# 9. Auto-mount on boot (optional)
echo '/dev/sdc1 /mnt/data ext4 defaults 0 0' | sudo tee -a /etc/fstab

# 10. Verify fstab
cat /etc/fstab
```

## 🎯 Practice Scenarios

### 1. System Information

```bash
# OS version
cat /etc/redhat-release

# System resources
free -h
lsblk
df -h

# Network interfaces
ip addr show
```

### 2. Package Management

```bash
# Update system
sudo dnf update -y

# Install packages
sudo dnf install -y vim git wget curl

# List installed packages
sudo dnf list installed
```

### 3. Disk Operations

```bash
# Check disk usage
du -sh /mnt/data/*

# Create test files on data disk
for i in {1..10}; do
  echo "Test file $i" > /mnt/data/file$i.txt
done

# List files
ls -la /mnt/data/
```

### 4. Network Testing

```bash
# Check public IP
curl ifconfig.me

# Test outbound connectivity
ping -c 4 google.com
curl https://www.google.com
```

## 📊 Useful Commands

### Terraform Commands

```bash
# View all outputs
terraform output

# View specific output
terraform output vm_public_ip

# Refresh state
terraform refresh

# Show current state
terraform show

# Destroy everything (SAVES MONEY!)
terraform destroy
```

### Azure CLI Commands

```bash
# List resource groups
az group list --output table

# List VMs
az vm list --output table

# Get VM details
az vm show --resource-group rg-linux-practice --name vm-redhat-practice

# List disks
az disk list --output table

# Stop VM (saves compute cost but not disk cost)
az vm stop --resource-group rg-linux-practice --name vm-redhat-practice

# Start VM
az vm start --resource-group rg-linux-practice --name vm-redhat-practice

# Deallocate VM (saves all compute cost)
az vm deallocate --resource-group rg-linux-practice --name vm-redhat-practice
```

## 🎓 What You Can Practice

### Terraform Skills:
- ✅ Azure resource provisioning
- ✅ Virtual Network setup
- ✅ Network Security Groups
- ✅ VM creation and configuration
- ✅ Disk management
- ✅ Resource dependencies
- ✅ Terraform state management

### Azure Skills:
- ✅ Resource Groups
- ✅ Virtual Networks & Subnets
- ✅ Network Security Groups (NSG)
- ✅ Virtual Machines (VMs)
- ✅ Managed Disks
- ✅ Public IPs
- ✅ Azure CLI commands

### Linux Skills:
- ✅ Red Hat Enterprise Linux
- ✅ Disk partitioning & mounting
- ✅ Filesystem management
- ✅ Package management (dnf)
- ✅ Network configuration
- ✅ SSH key authentication

## ⚠️ Important Notes

### Security
- Default NSG allows SSH from anywhere (0.0.0.0/0)
- Change `allowed_ssh_cidr` in variables.tf to your IP for better security
- SSH key authentication only (no password)

### Costs
- VM is charged per hour when running
- Disks are charged even when VM is stopped
- **Always destroy resources when done practicing!**

### Data Persistence
- Data disk persists even if VM is destroyed
- If you want to keep data, comment out data disk in terraform destroy
- Or take a snapshot before destroying

## 🧹 Cleanup

### Option 1: Destroy Everything

```bash
# Destroy all resources
terraform destroy

# Type: yes

# ⏰ Takes 3-5 minutes

# Verify in Azure Portal or CLI:
az group list --output table
# rg-linux-practice should be gone
```

### Option 2: Stop VM (Keep Infrastructure)

```bash
# Deallocate VM (stops compute charges)
az vm deallocate --resource-group rg-linux-practice --name vm-redhat-practice

# Start again when needed
az vm start --resource-group rg-linux-practice --name vm-redhat-practice
```

## 🐛 Troubleshooting

### Issue: SSH connection refused

```bash
# Check if VM is running
az vm get-instance-view --resource-group rg-linux-practice --name vm-redhat-practice

# Check NSG rules
az network nsg rule list --resource-group rg-linux-practice --nsg-name vm-redhat-practice-nsg --output table

# Verify public IP
terraform output vm_public_ip
```

### Issue: Data disk not showing

```bash
# SSH into VM and check
lsblk

# If disk is not attached, check in Azure Portal:
# Virtual Machines → vm-redhat-practice → Disks

# Or via CLI:
az vm show --resource-group rg-linux-practice --name vm-redhat-practice --query storageProfile.dataDisks
```

### Issue: Terraform apply fails

```bash
# Check Azure login
az account show

# Re-login if needed
az login

# Check subscription
az account list --output table
```

## 🎓 Interview Topics Covered

This setup demonstrates:
- ✅ Infrastructure as Code (Terraform)
- ✅ Azure networking (VNet, Subnet, NSG)
- ✅ Virtual Machine provisioning
- ✅ Disk management (OS + Data disks)
- ✅ Security (SSH keys, NSG rules)
- ✅ Resource organization (Resource Groups)
- ✅ Cost optimization strategies
- ✅ Linux system administration

## 📚 Comparison: Azure vs AWS

| Azure | AWS | Purpose |
|-------|-----|---------|
| Resource Group | Tags/OU | Organization |
| Virtual Network | VPC | Network isolation |
| Subnet | Subnet | Network segmentation |
| NSG | Security Group | Firewall rules |
| VM | EC2 Instance | Compute |
| Managed Disk | EBS Volume | Block storage |
| Public IP | Elastic IP | External access |

## 💡 Tips

- **Practice regularly** - 1-2 hours daily
- **Destroy after practice** - Save money!
- **Take snapshots** - Preserve important data
- **Use Azure Portal** - Visual verification
- **Check costs** - Azure Cost Management daily
- **Try different VM sizes** - B1s vs B2s

## 📞 Next Steps

1. Deploy the infrastructure
2. SSH into the VM
3. Mount and use the data disk
4. Practice Linux commands
5. Explore Azure Portal
6. Destroy when done

---

**Good luck with your Azure + Terraform interview preparation! 🚀**

Remember: **`terraform destroy`** when done practicing!

