resource "aws_iam_role" "grafana" {
  name               = "${var.env}-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.grafana-assume-role.json
}

data "aws_iam_policy_document" "grafana-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "grafana.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy" "grafana" {
  name_prefix = "${var.env}-${var.name}"

  // Policy derived from the following documentation:
  // https://docs.aws.amazon.com/grafana/latest/userguide/AMG-manage-permissions.html#AMG-service-managed-account
  policy = file("${path.module}/grafana-iam-role-policy.json")
  role   = aws_iam_role.grafana.id
}
