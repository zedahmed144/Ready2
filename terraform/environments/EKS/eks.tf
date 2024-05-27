resource "aws_eks_cluster" "core" {
  name                      = "Swish2"
  role_arn                  = aws_iam_role.eks_cluster.arn
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  depends_on                = [aws_cloudwatch_log_group.eks]
  version                   = var.eks_version

  vpc_config {
    subnet_ids              = module.private-subnets.subnet_ids
    public_access_cidrs     = var.k8s_api_public_access_cidrs
    endpoint_public_access  = true
    endpoint_private_access = true
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.secrets.arn
    }
  }

  tags = {
    Service   = var.service_name
    Component = "EKS"
    Name      = "Swish2"
  }
}

locals {
  eks_autoscaling_groups = toset(flatten(aws_eks_node_group.core.resources[*].autoscaling_groups[*].name))
}

data "aws_default_tags" "main" {}

resource "aws_key_pair" "eks_admin" {
  public_key = var.admin_public_key
}

resource "aws_security_group" "eks_remote_access" {
  name_prefix = "${var.service_name}-${var.env}-remote"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "k8s API server ingress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] //This should be more restrictive (VPN)
  }

  egress {
    description = "AllEgress"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Used for resources that specify "create before destroy" setting
resource "random_id" "core-eks-node-group" {
  keepers = {
    instance_type = var.instance_type
  }

  byte_length = 2
}

resource "aws_eks_node_group" "core" {
  cluster_name    = aws_eks_cluster.core.name
  node_group_name = "core-${random_id.core-eks-node-group.id}"
  node_role_arn   = aws_iam_role.eks_node.arn
  subnet_ids      = module.private-subnets.subnet_ids
  instance_types  = [var.instance_type]

  remote_access {
    ec2_ssh_key               = aws_key_pair.eks_admin.key_name
    source_security_group_ids = [aws_security_group.eks_remote_access.id]
  }

  scaling_config {
    desired_size = var.node_desired
    max_size     = var.node_max
    min_size     = var.node_min
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node_group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node_group-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.lb_controller_policy,
    module.aws-auth # Create AWS-Auth manually first, otherwise it will make its own.
  ]


  # Allow external changes without Terraform plan difference
  lifecycle {
    // noinspection HILUnresolvedReference
    ignore_changes        = [scaling_config[0].desired_size]
    create_before_destroy = true
  }
}

# tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/Swish2/cluster"
  retention_in_days = var.cloudwatch_log_group_retention_period
  tags = {
    Name = "/aws/eks/Swish2/cluster"
  }
}

resource "aws_security_group_rule" "eks" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = module.private-subnets.subnet_cidrs
  security_group_id = aws_eks_cluster.core.vpc_config[0].cluster_security_group_id
  description       = "Self ingress"
}

data "aws_eks_cluster_auth" "core" {
  name = aws_eks_cluster.core.name
}

output "eks_node_arn" {
  value = aws_iam_role.eks_node.arn
}
