output "grafana_arn" {
  value = aws_grafana_workspace.main.arn
}

output "grafana_version" {
  value = aws_grafana_workspace.main.grafana_version
}

output "grafana_endpoint" {
  value = aws_grafana_workspace.main.endpoint
}

output "security_group_id" {
  value = aws_security_group.grafana.id
}

output "grafana_iam_role_arn" {
  value = aws_iam_role.grafana.arn
}
