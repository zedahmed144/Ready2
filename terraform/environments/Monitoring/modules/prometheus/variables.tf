variable "name" {
  type        = string
  description = "Name label"
  default     = "Ready-amp"
}

variable "env" {
  type        = string
  description = "Environment label"
}

variable "grafana_arns" {
  type        = list(string)
  description = "List of Grafana IAM role ARNs to allow it to use this AMP as a datasource"

  // Default (and generally always set to this) we will allow the Central Data Solutions
  // Grafana to query data from our AMP instance.
  default = [
    "arn:aws:iam::381492184593:role/Ready-grafana"
  ]
}
