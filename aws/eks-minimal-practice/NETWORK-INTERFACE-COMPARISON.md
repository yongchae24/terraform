# Network Interface & IP Address Comparison: EC2 vs EKS

## 🎯 Focus: EC2 Instance Network Interfaces & IP Addresses

### EC2 Standalone Instance (Your Current Setup)

```
EC2 Instance
│
├── Network Interface (ENI)
│   ├── Primary Private IP: 172.31.x.x (from default VPC)
│   ├── Primary Public IP: 54.x.x.x (auto-assigned)
│   └── MAC Address: 02:xx:xx:xx:xx:xx
│
└── Security Group
    └── Controls traffic to/from this ENI
```

**What you get:**
- **1 ENI** per instance
- **1 Private IP** per instance (from VPC CIDR)
- **1 Public IP** per instance (if `associate_public_ip_address = true`)
- **Direct IP-to-IP communication** between instances

**Commands to inspect:**
```bash
# Get instance network interface details
aws ec2 describe-instances \
  --instance-ids <instance-id> \
  --query 'Reservations[].Instances[].[
    InstanceId,
    PrivateIpAddress,
    PublicIpAddress,
    NetworkInterfaces[0].NetworkInterfaceId,
    NetworkInterfaces[0].PrivateIpAddresses[0].PrivateIpAddress,
    NetworkInterfaces[0].MacAddress
  ]' \
  --output table

# Get detailed ENI information
aws ec2 describe-network-interfaces \
  --filters "Name=attachment.instance-id,Values=<instance-id>" \
  --query 'NetworkInterfaces[].[
    NetworkInterfaceId,
    PrivateIpAddress,
    Association.PublicIp,
    MacAddress,
    SubnetId,
    Groups[].GroupId
  ]' \
  --output table
```

---

### EKS Worker Node (EC2 Instance Running Kubernetes)

```
EKS Worker Node (EC2 Instance)
│
├── Network Interface (ENI) - Primary
│   ├── Primary Private IP: 10.0.x.x (from custom VPC)
│   ├── Primary Public IP: 54.x.x.x (if in public subnet)
│   └── MAC Address: 02:xx:xx:xx:xx:xx
│
├── Pod IP Addresses (from same subnet!)
│   ├── Pod 1 IP: 10.0.x.x (from VPC CIDR)
│   ├── Pod 2 IP: 10.0.x.x (from VPC CIDR)
│   └── Pod N IP: 10.0.x.x (from VPC CIDR)
│
└── VPC CNI Plugin
    └── Manages pod IP assignment from subnet CIDR
```

**What you get:**
- **1 ENI** per node (same as EC2)
- **1 Private IP** per node (from VPC CIDR)
- **1 Public IP** per node (if in public subnet)
- **Multiple Pod IPs** from the **same subnet CIDR** (managed by VPC CNI)

**Key Difference:**
- **EC2**: 1 instance = 1 IP address
- **EKS**: 1 node = 1 IP address, but **pods get additional IPs from subnet**

**Commands to inspect:**
```bash
# Get EKS node network interface (same as EC2)
aws ec2 describe-instances \
  --filters "Name=tag:kubernetes.io/cluster/<cluster-name>,Values=owned" \
  --query 'Reservations[].Instances[].[
    InstanceId,
    PrivateIpAddress,
    PublicIpAddress,
    NetworkInterfaces[0].NetworkInterfaceId
  ]' \
  --output table

# Get pod IPs (Kubernetes level)
kubectl get pods -o wide
# Shows: Pod IPs are from the same VPC subnet!

# Get node details
kubectl get nodes -o wide
# Shows: Node IPs (same as EC2 instance IPs)

# Detailed pod network info
kubectl describe pod <pod-name> | grep -i ip
```

---

## 📊 Side-by-Side Comparison

| Aspect | EC2 Standalone | EKS Worker Node |
|--------|----------------|-----------------|
| **Network Interfaces** | 1 ENI per instance | 1 ENI per node |
| **Instance Private IP** | ✅ 1 IP | ✅ 1 IP |
| **Instance Public IP** | ✅ 1 IP (if enabled) | ✅ 1 IP (if in public subnet) |
| **Pod IPs** | ❌ N/A | ✅ Multiple IPs from subnet |
| **IP Source** | VPC CIDR | VPC CIDR (same!) |
| **IP Management** | AWS assigns | AWS assigns + VPC CNI for pods |
| **Network Model** | Direct IP-to-IP | IP-per-pod model |

---

## 🔍 What Matters for Networking Comparison

### 1. **IP Address Allocation**

**EC2:**
```
Default VPC: 172.31.0.0/16
├── Instance 1: 172.31.1.10 (private), 54.1.2.3 (public)
└── Instance 2: 172.31.1.11 (private), 54.1.2.4 (public)
```

**EKS:**
```
Custom VPC: 10.0.0.0/16
├── Node 1: 10.0.0.10 (private), 54.5.6.7 (public)
│   ├── Pod 1: 10.0.0.20 (from subnet!)
│   ├── Pod 2: 10.0.0.21 (from subnet!)
│   └── Pod 3: 10.0.0.22 (from subnet!)
└── Node 2: 10.0.1.10 (private), 54.5.6.8 (public)
    ├── Pod 4: 10.0.1.20 (from subnet!)
    └── Pod 5: 10.0.1.21 (from subnet!)
```

**Key Insight:** Pod IPs consume subnet IP space! You need enough IPs in subnet.

### 2. **Network Interface Details**

Both EC2 and EKS nodes have the **same ENI structure**:
- Primary network interface
- Private IP address
- Public IP address (if applicable)
- Security group attachments
- Subnet association

**The difference is what runs on top:**
- EC2: Applications directly use the instance IP
- EKS: Pods get their own IPs, but still use the node's ENI

### 3. **Subnet Requirements**

**EC2:**
- ✅ Can use 1 subnet
- ✅ Can use default VPC
- ✅ Simple: instance = subnet IP

**EKS:**
- ⚠️ **Requires 2+ subnets** (different AZs)
- ⚠️ Needs enough IPs for nodes + pods
- ⚠️ More complex: node IP + pod IPs from same subnet

**Example IP consumption:**
```
Subnet: 10.0.0.0/24 (256 IPs)
├── Reserved: 5 IPs (AWS)
├── Node 1: 1 IP
├── Pods on Node 1: ~10-50 IPs (depends on pod density)
├── Node 2: 1 IP
└── Pods on Node 2: ~10-50 IPs
```

---

## 🧪 Practical Inspection Commands

### Inspect EC2 Instance Network Interface
```bash
# Get instance ID
INSTANCE_ID="i-xxxxxxxxx"

# Get ENI details
aws ec2 describe-network-interfaces \
  --filters "Name=attachment.instance-id,Values=$INSTANCE_ID" \
  --query 'NetworkInterfaces[0].[
    NetworkInterfaceId,
    PrivateIpAddress,
    Association.PublicIp,
    SubnetId,
    VpcId,
    MacAddress,
    Groups[].GroupId
  ]' \
  --output json
```

### Inspect EKS Node Network Interface
```bash
# Get node instance ID from Kubernetes
NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=private-dns-name,Values=$NODE_NAME" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)

# Get ENI details (same command as EC2!)
aws ec2 describe-network-interfaces \
  --filters "Name=attachment.instance-id,Values=$INSTANCE_ID" \
  --query 'NetworkInterfaces[0].[
    NetworkInterfaceId,
    PrivateIpAddress,
    Association.PublicIp,
    SubnetId,
    VpcId,
    MacAddress
  ]' \
  --output json

# Compare with pod IPs
kubectl get pods -o wide --all-namespaces
```

---

## 💡 Key Takeaways

1. **Network Interface Structure is IDENTICAL**
   - Both EC2 and EKS nodes have 1 ENI
   - Both have private + public IPs
   - Same AWS networking primitives

2. **IP Address Model is DIFFERENT**
   - EC2: 1 instance = 1 IP
   - EKS: 1 node = 1 IP + N pod IPs (from subnet)

3. **Subnet Planning Matters for EKS**
   - Need 2+ subnets (different AZs) - **REQUIRED**
   - Need enough IPs for nodes + pods
   - Pod IPs consume subnet IP space

4. **VPC Choice**
   - Default VPC: Can work if it has 2+ subnets in different AZs
   - Custom VPC: Better control, recommended for production
   - **For learning**: Custom VPC helps you understand networking better

---

## 🎓 What to Focus On

When comparing EC2 vs EKS networking:

1. **Network Interface Level** (Same!)
   - ENI structure
   - IP assignment
   - Security groups

2. **IP Address Model** (Different!)
   - EC2: Direct IP usage
   - EKS: IP-per-pod model

3. **Subnet Strategy** (Different!)
   - EC2: Can use 1 subnet
   - EKS: Must use 2+ subnets (multi-AZ)

4. **IP Consumption** (Different!)
   - EC2: 1 IP per instance
   - EKS: 1 IP per node + N IPs per pod

---

## 🔧 Simplification Options

**Can you simplify EKS to use default VPC?**

✅ **Yes, technically possible** if:
- Default VPC has 2+ subnets in different AZs
- Subnets have enough IP space for nodes + pods

⚠️ **But consider:**
- Default VPC CIDR is fixed (usually 172.31.0.0/16)
- Less control over subnet sizing
- Not recommended for production
- **For learning**: Custom VPC teaches you more!

**Recommendation:** Keep custom VPC for learning, but understand that the **network interface structure is the same** - the difference is in IP allocation strategy (pods get IPs too).

