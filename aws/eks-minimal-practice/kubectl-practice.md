# kubectl Practice Guide - Interview Preparation

Hands-on kubectl commands and scenarios for Kubernetes interview preparation.

## 📋 Prerequisites

```bash
# Verify kubectl is configured
kubectl get nodes

# Should show 2 nodes in Ready state
```

---

## 🎯 Practice Scenario 1: Deploy Simple Pod

### Create a Pod

```bash
# Method 1: Imperative (quick)
kubectl run nginx-pod --image=nginx:latest

# Method 2: Declarative (better for production)
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
EOF
```

### Check Pod Status

```bash
# List pods
kubectl get pods
kubectl get pods -o wide

# Describe pod (detailed info)
kubectl describe pod nginx-pod

# View logs
kubectl logs nginx-pod

# Follow logs
kubectl logs -f nginx-pod
```

### Interact with Pod

```bash
# Execute command in pod
kubectl exec nginx-pod -- nginx -v

# Get a shell inside pod
kubectl exec -it nginx-pod -- /bin/bash

# Inside the pod:
curl localhost
exit
```

### Delete Pod

```bash
kubectl delete pod nginx-pod
```

---

## 🎯 Practice Scenario 2: Deployments

### Create Deployment

```bash
# Create deployment with 3 replicas
kubectl create deployment nginx-deploy --image=nginx:latest --replicas=3

# Or declarative way:
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
EOF
```

### Check Deployment

```bash
# List deployments
kubectl get deployments
kubectl get deploy

# List replica sets
kubectl get rs

# List pods created by deployment
kubectl get pods -l app=nginx

# Describe deployment
kubectl describe deployment nginx-deploy
```

### Scale Deployment

```bash
# Scale to 5 replicas
kubectl scale deployment nginx-deploy --replicas=5

# Verify
kubectl get pods -l app=nginx

# Scale down to 2
kubectl scale deployment nginx-deploy --replicas=2
```

### Update Deployment (Rolling Update)

```bash
# Update image
kubectl set image deployment/nginx-deploy nginx=nginx:1.25

# Check rollout status
kubectl rollout status deployment/nginx-deploy

# View rollout history
kubectl rollout history deployment/nginx-deploy

# Rollback if needed
kubectl rollout undo deployment/nginx-deploy
```

### Delete Deployment

```bash
kubectl delete deployment nginx-deploy
```

---

## 🎯 Practice Scenario 3: Services

### Create Deployment + Service

```bash
# Create deployment
kubectl create deployment web-app --image=nginx:latest --replicas=3

# Expose as ClusterIP service (internal only)
kubectl expose deployment web-app --port=80 --target-port=80 --name=web-service

# Check service
kubectl get svc web-service
kubectl describe svc web-service

# Get service endpoint
kubectl get endpoints web-service
```

### Test Service (from another pod)

```bash
# Create a test pod
kubectl run test-pod --image=busybox --rm -it -- sh

# Inside test-pod:
wget -q -O- web-service
exit
```

### NodePort Service (external access)

```bash
# Expose as NodePort
kubectl expose deployment web-app --port=80 --target-port=80 --type=NodePort --name=web-nodeport

# Get service details
kubectl get svc web-nodeport

# Note the NodePort (e.g., 30000-32767)
# Access via: http://<node-public-ip>:<nodeport>

# Get node IPs
kubectl get nodes -o wide
```

### LoadBalancer Service (AWS ELB)

```bash
# Expose as LoadBalancer (creates AWS ELB)
kubectl expose deployment web-app --port=80 --target-port=80 --type=LoadBalancer --name=web-lb

# Wait for external IP (takes 2-3 minutes)
kubectl get svc web-lb -w

# Once EXTERNAL-IP shows (AWS ELB DNS):
# Access via: http://<external-ip>

# ⚠️ Remember to delete LoadBalancer service (costs money!)
kubectl delete svc web-lb
```

### Cleanup

```bash
kubectl delete svc web-service web-nodeport
kubectl delete deployment web-app
```

---

## 🎯 Practice Scenario 4: ConfigMaps and Secrets

### ConfigMap

```bash
# Create ConfigMap from literal values
kubectl create configmap app-config \
  --from-literal=DATABASE_HOST=mysql.example.com \
  --from-literal=DATABASE_PORT=3306

# View ConfigMap
kubectl get configmap app-config
kubectl describe configmap app-config

# Create pod using ConfigMap
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-test-pod
spec:
  containers:
  - name: test
    image: busybox
    command: ["sh", "-c", "echo DATABASE_HOST=\$DATABASE_HOST && sleep 3600"]
    env:
    - name: DATABASE_HOST
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: DATABASE_HOST
EOF

# Check logs
kubectl logs config-test-pod
```

### Secret

```bash
# Create Secret
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=supersecret

# View Secret (values are base64 encoded)
kubectl get secret db-secret
kubectl describe secret db-secret

# Decode secret
kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 --decode

# Create pod using Secret
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: secret-test-pod
spec:
  containers:
  - name: test
    image: busybox
    command: ["sh", "-c", "echo USERNAME=\$USERNAME && sleep 3600"]
    env:
    - name: USERNAME
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: username
    - name: PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
EOF

# Check logs
kubectl logs secret-test-pod
```

### Cleanup

```bash
kubectl delete pod config-test-pod secret-test-pod
kubectl delete configmap app-config
kubectl delete secret db-secret
```

---

## 🎯 Practice Scenario 5: Namespaces

### Create and Use Namespaces

```bash
# List namespaces
kubectl get namespaces
kubectl get ns

# Create namespace
kubectl create namespace dev
kubectl create namespace prod

# Create deployment in specific namespace
kubectl create deployment nginx-dev --image=nginx --namespace=dev

# List resources in namespace
kubectl get all -n dev

# Set default namespace (optional)
kubectl config set-context --current --namespace=dev

# Now commands run in 'dev' namespace by default
kubectl get pods

# Switch back to default
kubectl config set-context --current --namespace=default
```

### Cleanup

```bash
# Delete namespace (deletes all resources inside)
kubectl delete namespace dev prod
```

---

## 🎯 Practice Scenario 6: Labels and Selectors

### Working with Labels

```bash
# Create pods with labels
kubectl run pod1 --image=nginx --labels="app=web,env=dev"
kubectl run pod2 --image=nginx --labels="app=web,env=prod"
kubectl run pod3 --image=nginx --labels="app=api,env=dev"

# List all pods with labels
kubectl get pods --show-labels

# Filter by label
kubectl get pods -l app=web
kubectl get pods -l env=dev
kubectl get pods -l 'app=web,env=dev'

# Label selector with multiple conditions
kubectl get pods -l 'app in (web,api)'
kubectl get pods -l 'env!=prod'

# Add label to existing pod
kubectl label pod pod1 tier=frontend

# Remove label
kubectl label pod pod1 tier-

# Cleanup
kubectl delete pod pod1 pod2 pod3
```

---

## 🎯 Practice Scenario 7: Resource Limits

### Pod with Resource Requests and Limits

```bash
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: resource-demo
spec:
  containers:
  - name: demo
    image: nginx
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
      limits:
        memory: "128Mi"
        cpu: "500m"
EOF

# Check resource usage
kubectl top pods resource-demo

# Describe to see requests/limits
kubectl describe pod resource-demo

# Cleanup
kubectl delete pod resource-demo
```

---

## 🎯 Common Interview Commands

### Cluster Info

```bash
# Cluster information
kubectl cluster-info
kubectl version
kubectl api-resources

# Node information
kubectl get nodes
kubectl describe node <node-name>
kubectl top nodes
```

### Debugging

```bash
# Check pod logs
kubectl logs <pod-name>
kubectl logs <pod-name> -c <container-name>  # multi-container pod
kubectl logs <pod-name> --previous           # previous instance

# Describe resources
kubectl describe pod <pod-name>
kubectl describe svc <service-name>
kubectl describe node <node-name>

# Events
kubectl get events
kubectl get events --sort-by=.metadata.creationTimestamp

# Port forwarding (access pod locally)
kubectl port-forward pod/<pod-name> 8080:80
# Access via: http://localhost:8080
```

### Resource Management

```bash
# Get all resources
kubectl get all
kubectl get all --all-namespaces

# Delete multiple resources
kubectl delete pods,services -l app=myapp

# Export resource as YAML
kubectl get pod <pod-name> -o yaml
kubectl get deployment <deploy-name> -o yaml > deployment.yaml

# Apply from file
kubectl apply -f deployment.yaml

# Dry run (see what would be created)
kubectl create deployment test --image=nginx --dry-run=client -o yaml
```

---

## 🎓 Interview Questions to Practice

### Basic Questions:

1. **What is a Pod?**
   - Smallest deployable unit in Kubernetes
   - Can contain one or more containers
   - Shared network namespace and storage

2. **Difference between Deployment and Pod?**
   - Pod: Single instance
   - Deployment: Manages multiple pod replicas, rolling updates, rollbacks

3. **What are Services?**
   - Stable network endpoint for pods
   - Load balancing across pod replicas
   - Types: ClusterIP, NodePort, LoadBalancer

4. **What is a ConfigMap?**
   - Store non-sensitive configuration data
   - Inject as environment variables or volumes

5. **What is a Secret?**
   - Store sensitive data (passwords, tokens)
   - Base64 encoded
   - Should be encrypted at rest

### Advanced Questions:

1. **How does rolling update work?**
   - Create new ReplicaSet with new version
   - Gradually scale down old ReplicaSet
   - Rollback if issues detected

2. **How to debug a failing pod?**
   ```bash
   kubectl describe pod <name>
   kubectl logs <name>
   kubectl get events
   kubectl exec -it <name> -- sh
   ```

3. **What is a namespace?**
   - Virtual cluster within physical cluster
   - Resource isolation
   - RBAC boundaries

---

## 💡 Pro Tips for Interviews

### Quick Aliases

```bash
# Add to ~/.zshrc or ~/.bashrc
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kl='kubectl logs'
alias kx='kubectl exec -it'
alias ka='kubectl apply -f'
```

### Must-Know Commands

```bash
# Top 10 most used:
kubectl get pods
kubectl describe pod <name>
kubectl logs <name>
kubectl exec -it <name> -- sh
kubectl apply -f <file>
kubectl delete <resource> <name>
kubectl get all
kubectl scale deployment <name> --replicas=<n>
kubectl rollout status deployment <name>
kubectl get events
```

---

## 🧹 Cleanup All Practice Resources

```bash
# Delete all in default namespace
kubectl delete all --all

# Or delete specific resources
kubectl delete deployments --all
kubectl delete services --all
kubectl delete pods --all
kubectl delete configmaps --all
kubectl delete secrets --all

# Verify
kubectl get all
```

---

## 📚 Next Steps

1. Practice each scenario multiple times
2. Try creating YAML files from scratch
3. Experiment with different configurations
4. Read Kubernetes documentation
5. Practice explaining concepts out loud

---

**Good luck with your Kubernetes interview! 🚀**

Remember: Practice makes perfect!

