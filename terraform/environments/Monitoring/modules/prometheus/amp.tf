resource "aws_prometheus_workspace" "main" {
  alias = "${var.env}-${var.name}"

  tags = {
    "Name" = "${var.env}-${var.name}"
  }

  logging_configuration {
    log_group_arn = "${aws_cloudwatch_log_group.amp.arn}:*"
  }
}
