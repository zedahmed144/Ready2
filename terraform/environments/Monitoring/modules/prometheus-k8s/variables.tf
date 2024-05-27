variable "namespace" {
  type        = string
  default     = "monitoring"
  description = "Namespace to deploy prometheus into"
}

variable "prometheus_image" {
  type        = string
  default     = "quay.io/prometheus/prometheus:v2.31.1"
  description = "Image to use for prometheus"
}

variable "config" {
  type        = string
  description = "Prometheus YAML configuration. One will be generated for you if not provided"
  default     = null
}

variable "remote_write_url" {
  type        = string
  description = "Prometheus remote_write URL, such as for AMP"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name, for extra labeling purposes"
}

variable "region" {
  type        = string
  description = "Region being deployed within"
}

variable "limits" {
  type        = map(string)
  description = "CPU and memory resource limit map for the Prometheus statefulset"
  default = {
    "cpu" = "75m"
  }
}

variable "requests" {
  type        = map(string)
  description = "CPU and memory resource requests map for the Prometheus statefulset"
  default = {
    "cpu"    = "50m"
    "memory" = "400Mi"
  }
}

variable "ebs_volume_size" {
  type        = string
  description = "Size of the EBS volume to request for Prometheus data"
  default     = "50Gi"
}
