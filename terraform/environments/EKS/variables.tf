
locals {
  account = data.aws_caller_identity.current.account_id
  region  = data.aws_region.regional.name
}

data "aws_region" "main" { provider = aws.main }
data "aws_region" "regional" {}
data "aws_caller_identity" "current" {}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "eks_version" {
  default = "1.21"
  type = string
  description = "version of EKS cluster"
}

variable "service_name" {
  description = "Name of the service"
  type        = string
  default     = "Ready-api"
}


variable "hosted_zone_name" {
  description = "Name of the Route53 hosted zone to use"
  type        = string
}


/*
  Cluster configuration variables.
*/
variable "node_desired" {
  description = "Number of ECS nodes desired in the cluster"
  type        = number
  default     = 1
}

variable "node_min" {
  description = "Minimum number of nodes to allow in autoscaling group"
  type        = number
  default     = 1
}

variable "node_max" {
  description = "Maximum number of nodes to allow in autoscaling group"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "Instance type for EKS cluster instances"
  type        = string
  default     = "t3.small"
}

variable "admin_public_key" {
  description = "Public SSH key to use on the EC2 instances being launched. Defaults to a dummy key."
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDYNY6FUM2Pj7z5Xcpyzh+jWMZz41jr1kBKLhwJOFGVMbrClepTg4VDRxYtRiw8G3M/L540DlwcC+twwBwC1mdwDcXGOIM/faR6U1khW6cPjEQwWOCCzyKg3Eth3P5KcGOQGZYF//HTQ0brlO9NtQNbDqjjcFiugnGHoboYpXAENw=="
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks to allow ingress to the cluster"
  type        = list(string)
  default     = []
}

variable "k8s_api_public_access_cidrs" {
  description = "CIDR blocks to allow public access to the kubernetes API server"
  type        = list(string)
  default     = []
}

variable "cidr" {
  description = "IP CIDR block to use for creating subnets"
  type        = string
}


variable "subnet_bits" {
  description = "How many bits (added to VPC CIDR notation) to use when creating subnets"
  type        = number
  default     = 6
}


variable "cloudwatch_log_group_retention_period" {
  description = "The number of days to retain log events in the specified log group"
  type        = number
  default = 30
}





