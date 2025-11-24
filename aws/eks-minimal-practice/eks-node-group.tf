# EKS Managed Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = aws_subnet.public[*].id

  # Instance types and sizing
  instance_types = [var.node_instance_type]
  disk_size      = var.node_disk_size

  # Scaling configuration
  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  # Update configuration
  update_config {
    max_unavailable = 1
  }

  # Latest AMI for the EKS version
  # ami_type = "AL2_x86_64" # Amazon Linux 2 (default)

  # Capacity type (ON_DEMAND is more reliable than SPOT for learning)
  capacity_type = "ON_DEMAND"

  # Labels for node selection
  labels = {
    role        = "general"
    environment = "learning"
  }

  # Ensure IAM role and policies are created before node group
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_policy,
  ]

  tags = {
    Name = "${var.cluster_name}-node-group"
  }

  # Ignore changes to desired size (allows autoscaling)
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

