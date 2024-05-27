
provider "aws" {
  alias               = "us-east-1"
  allowed_account_ids = [local.account]
  region              = "us-east-1"

  default_tags {
    tags = {
      "DeployedBy"  = "Terraform"
      "Squad"       = "DevOps"
      "Component"   = "Monitoring"
    }
  }
}

// Configure the Kubernetes terraform provider to connect to the shared cluster.
provider "kubernetes" {
  host                   = data.aws_eks_cluster.us-east-1.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.us-east-1.certificate_authority[0].data)
  alias                  = "us-east-1"

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args = [
      "--region",
      "us-east-1",
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.us-east-1.name
    ]
    command = "aws"
    env = {
      AWS_PROFILE = local.account
      // you MUST have the matching account number defined as a profile in your ~/.aws/config
    }
  }
}


provider "random" {}

// Automatically query the shared kubernetes cluster from EKS.
// We'll pass this to the kubernetes provider to be able to
// get the cluster endpoint and Certificate Authority (CA) cert.
data "aws_eks_cluster" "us-east-1" {
  name     = local.cluster_name
  provider = aws.us-east-1

  tags = {
    Component   = "EKS"
    DeployedBy  = "Terraform"
    Name        = local.cluster_name
  }
}


