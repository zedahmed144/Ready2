resource "aws_cloudwatch_log_group" "amp" {
  name              = "${var.env}-${var.name}"
  retention_in_days = 7

  tags = {
    "Name" = "${var.env}-${var.name}"
  }
}
