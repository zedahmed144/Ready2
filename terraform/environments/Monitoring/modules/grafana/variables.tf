variable "name" {
  type        = string
  description = "Name label"
  default     = "Ready-grafana"
}

variable "env" {
  type        = string
  description = "Environment label"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy managed services into"
}
