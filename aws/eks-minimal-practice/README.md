# EKS Minimal Practice - Interview Preparation

Minimal-cost AWS EKS cluster for Terraform + Kubernetes interview preparation.

## 📊 Architecture

```
AWS EKS Cluster
│
├── Control Plane (Managed by AWS)
│   └── $0.10/hour (~$73/month)
│
├── VPC (10.0.0.0/16)
│   ├── Public Subnet 1 (10.0.0.0/24) - us-east-1a
│   ├── Public Subnet 2 (10.0.1.0/24) - us-east-1b
│   └── Internet Gateway (no NAT Gateway to save $32/month!)
│
├── Node Group (Worker Nodes)
│   ├── 2x t3.small EC2 instances
│   ├── Auto Scaling (min: 2, max: 3)
│   └── $0.0208/hr each (~$30/month total)
│
└── Kubernetes Resources (deployed via kubectl)
    ├── Pods
    ├── Deployments
    ├── Services
    └── ConfigMaps/Secrets
```

## 💰 Cost Breakdown

| Resource | Cost | Notes |
|----------|------|-------|
| EKS Control Plane | ~$73/month | $0.10/hour (can't avoid) |
| Worker Nodes (2x t3.small) | ~$30/month | $0.0416/hour total |
| **Total** | **~$103/month** | **Destroy when not using!** |

### Cost Saving Tips:
```bash
# Practice 4 hours/day = ~$14/month
# Weekend only = ~$25/month
# Always destroy after practice!
terraform destroy
```

## 📋 Prerequisites

### 1. Install Required Tools

```bash
# AWS CLI
brew install awscli

# Terraform
brew install terraform

# kubectl
brew install kubectl

# Verify installations
aws --version
terraform --version
kubectl version --client
```

### 2. Configure AWS Credentials

```bash
# Configure AWS CLI
aws configure

# Enter:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region: us-east-1
# - Default output format: json

# Verify
aws sts get-caller-identity
```

## 🚀 Deployment Steps

### Step 1: Initialize Terraform

```bash
cd /Users/yongchae.ko/Documents/projects/terraform/aws/eks-minimal-practice

# Initialize Terraform
terraform init
```

### Step 2: Review the Plan

```bash
# See what will be created
terraform plan

# You should see:
# - VPC and subnets
# - IAM roles and policies
# - Security groups
# - EKS cluster
# - Node group (2 worker nodes)
```

### Step 3: Deploy EKS Cluster

```bash
# Apply the configuration
terraform apply

# Type: yes

# ⏰ This will take 10-15 minutes!
# - Control plane: ~10 minutes
# - Node group: ~5 minutes
```

### Step 4: Configure kubectl

```bash
# Get the kubectl config command
terraform output configure_kubectl

# Run the command (example):
aws eks update-kubeconfig --region us-east-1 --name eks-minimal-cluster

# Verify connection
kubectl get nodes

# You should see 2 nodes in "Ready" state:
# NAME                         STATUS   ROLES    AGE   VERSION
# ip-10-0-0-xxx.ec2.internal   Ready    <none>   5m    v1.28.x
# ip-10-0-1-xxx.ec2.internal   Ready    <none>   5m    v1.28.x
```

### Step 5: Deploy Sample Application

```bash
# See kubectl-practice.md for detailed examples!

# Quick test:
kubectl run nginx --image=nginx
kubectl get pods
kubectl delete pod nginx
```

## 📊 Useful Commands

### Terraform Commands

```bash
# View outputs
terraform output

# View specific output
terraform output cluster_endpoint

# Refresh state
terraform refresh

# Destroy everything (SAVES MONEY!)
terraform destroy
```

### kubectl Commands

```bash
# Get cluster info
kubectl cluster-info
kubectl get nodes
kubectl get namespaces

# Get all resources
kubectl get all --all-namespaces

# View logs
kubectl logs <pod-name>

# Describe resource
kubectl describe node <node-name>
kubectl describe pod <pod-name>
```

## 🎯 What You Can Practice

### Terraform Skills:
- ✅ EKS cluster provisioning
- ✅ VPC networking setup
- ✅ IAM roles and policies
- ✅ Security group configuration
- ✅ Terraform state management
- ✅ Resource dependencies

### Kubernetes Skills:
- ✅ Deploy pods and deployments
- ✅ Create services (ClusterIP, NodePort, LoadBalancer)
- ✅ ConfigMaps and Secrets
- ✅ Resource limits and requests
- ✅ Rolling updates
- ✅ Scaling applications
- ✅ kubectl commands

## ⚠️ Important Notes

### Public Worker Nodes
This setup uses **public subnets** for worker nodes to save NAT Gateway cost ($32/month).

**Implications:**
- ✅ Works fine for learning/practice
- ✅ Pods can access internet directly
- ❌ Not recommended for production
- ❌ Nodes have public IPs

### Security
- Control plane endpoint is public (accessible from anywhere)
- Worker nodes are in public subnets
- Use this ONLY for learning!

### Cleanup
**Always destroy resources when done practicing!**

```bash
terraform destroy
# Type: yes

# Verify in AWS Console:
# - EC2 instances terminated
# - EKS cluster deleted
# - VPC deleted
```

## 🐛 Troubleshooting

### Issue: kubectl can't connect

```bash
# Reconfigure kubectl
aws eks update-kubeconfig --region us-east-1 --name eks-minimal-cluster

# Verify AWS credentials
aws sts get-caller-identity

# Check cluster status
aws eks describe-cluster --name eks-minimal-cluster --region us-east-1
```

### Issue: Nodes not ready

```bash
# Check node status
kubectl get nodes
kubectl describe node <node-name>

# Check node group in AWS Console
# EKS → Clusters → eks-minimal-cluster → Compute → Node groups
```

### Issue: High costs

```bash
# Destroy immediately!
terraform destroy

# Verify in AWS Console that all resources are deleted
```

## 📚 Next Steps

1. **Deploy sample apps** - See `kubectl-practice.md`
2. **Practice kubectl commands** - Create pods, services, deployments
3. **Learn Kubernetes concepts** - Understand pods, services, deployments
4. **Interview prep** - Practice explaining what you built

## 🎓 Interview Topics Covered

This setup demonstrates:
- ✅ Infrastructure as Code (Terraform)
- ✅ AWS networking (VPC, subnets, routing)
- ✅ IAM roles and policies
- ✅ Container orchestration (Kubernetes/EKS)
- ✅ Security groups and network security
- ✅ High availability (multi-AZ)
- ✅ Auto-scaling concepts
- ✅ Cloud cost optimization

## 💡 Tips

- **Practice regularly** - 1-2 hours daily
- **Destroy after practice** - Save money!
- **Take notes** - Document what you learn
- **Experiment** - Try different configurations
- **Ask questions** - Understand why, not just how

## 📞 Support

For issues or questions:
1. Check AWS CloudWatch logs
2. Review Terraform error messages
3. Check `kubectl describe` output
4. Verify AWS service quotas

---

**Good luck with your interview preparation! 🚀**

Remember: **`terraform destroy`** when done practicing!

