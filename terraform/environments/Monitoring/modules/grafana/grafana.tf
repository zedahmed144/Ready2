resource "aws_grafana_workspace" "main" {
  name                = "${var.env}-${var.name}"
  description         = "Central unified Grafana for observability"
  account_access_type = "CURRENT_ACCOUNT"
  authentication_providers = [
    "AWS_SSO" // For now, this can only be SSO or SAML
  ]
  permission_type = "SERVICE_MANAGED"
  role_arn        = aws_iam_role.grafana.arn

  // Predefined available data sources
  data_sources = [
    "CLOUDWATCH",
    "PROMETHEUS",
    "XRAY",

  ]
  notification_destinations = ["SNS"]

  vpc_configuration {
    subnet_ids = data.aws_subnets.private.ids
    security_group_ids = [
      aws_security_group.grafana.id
    ]
  }

  tags = {
    "Name" = "${var.env}-${var.name}"
  }
}

