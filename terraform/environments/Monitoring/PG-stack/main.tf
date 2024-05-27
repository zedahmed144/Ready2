provider "aws" {
  region              = local.main_region
  allowed_account_ids = [local.account]

  default_tags {
    tags = {
      "DeployedBy"  = "Terraform"
      "Squad"       = "DevOps"
      "Component"   = "Monitoring"
    }
  }
}

locals {
  env          = "Ready-PROD"
  main_region  = "us-east-1"
  region       = "us-east-1"
  cluster_name = "Swish2"
  account      = "381492184593"
}

module "prometheus-us-east-1" {
  source = "../../../../modules/prometheus-k8s"
  providers = {
    kubernetes = kubernetes.us-east-1
  }
  cluster_name     = local.cluster_name
  region           = "us-east-1"
  remote_write_url = module.amp.remote_write_url
}

// Amazon Managed Prometheus (AMP) deployment for metrics and AlertManager
module "amp" {
  source = "../modules/prometheus"
  env    = local.env
}

module "grafana" {
  source = "../modules/grafana"
  env    = local.env
  vpc_id = "vpc-0e64d5784f34b1056" // main-vpc
}
// This output should be used to configure the
// central Grafana server's datasource.
output "amp_datasource_iam_role_arn" {
  value = module.amp.amp_datasource_iam_role_arn
}

// This output should be used to configure the
// remote_write[].url in your local Prometheus server.
output "remote_write_url" {
  value = module.amp.remote_write_url
}

output "workspace_id" {
  value = module.amp.workspace_id
}

// Use the following Grafana ARN to have your respective
// AMP instances to allow it to query them.
output "grafana_iam_role_arn" {
  value = module.grafana.grafana_iam_role_arn
}