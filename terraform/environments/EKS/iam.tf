// IAM role for the EKS cluster
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-${var.service_name}-${var.env}-${data.aws_region.regional.name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  tags = {
    Name = "eks-cluster-${var.service_name}-${var.env}-${data.aws_region.regional.name}"
  }
}

resource "aws_iam_role_policy_attachment" "eks_core_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role" "eks_node" {
  name = "eks-node-${var.service_name}-${var.env}-${data.aws_region.regional.name}"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
    Version = "2012-10-17"
  })
  tags = {
    Name = "eks-node-${var.service_name}-${var.env}-${data.aws_region.regional.name}"
  }
}

resource "aws_iam_policy" "eks" {
  name_prefix = "${var.service_name}-${var.env}"
  path        = "/"
  policy      = data.aws_iam_policy_document.task_policy.json
  tags = {
    Name = "${var.service_name}-${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "lb_controller_policy" {
  policy_arn = aws_iam_policy.lb-controller.arn
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = aws_iam_policy.eks.arn
  role       = aws_iam_role.eks_node.name
}

