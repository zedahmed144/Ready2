output "workspace" {
  value = aws_prometheus_workspace.main
}

output "workspace_id" {
  value = aws_prometheus_workspace.main.id
}

output "prometheus_endpoint" {
  value = aws_prometheus_workspace.main.prometheus_endpoint
}

output "remote_write_url" {
  value = "${aws_prometheus_workspace.main.prometheus_endpoint}api/v1/remote_write"
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.amp.arn
}

output "amp_datasource_iam_role_arn" {
  value = aws_iam_role.datasource.arn
}
