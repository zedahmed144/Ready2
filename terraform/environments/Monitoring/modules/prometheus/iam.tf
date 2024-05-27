// Creates an IAM role that the central Grafana
// can assume, and whose access is limited to just
// the necessary aps (prometheus) actions required
// for the Grafana server to query from the Prometheus.
resource "aws_iam_role" "datasource" {
  name               = "${var.env}-${var.name}-datasource"
  assume_role_policy = data.aws_iam_policy_document.datasource-assume-role.json
}

data "aws_iam_policy_document" "datasource-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.grafana_arns
    }
  }
}

data "aws_iam_policy_document" "datasource-policy" {
  statement {
    sid = "ObservabilityReadOnlyAccess"
    actions = [
      "aps:List*",
      "aps:Get*",
      "aps:Query*",
      "aps:Describe*",
      "autoscaling:Describe*",
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*",
      "logs:Get*",
      "logs:List*",
      "logs:StartQuery",
      "logs:StopQuery",
      "logs:Describe*",
      "logs:TestMetricFilter",
      "logs:FilterLogEvents",
      "sns:Get*",
      "sns:List*"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "datasource" {
  name_prefix = "${var.env}-${var.name}"
  policy      = data.aws_iam_policy_document.datasource-policy.json
  role        = aws_iam_role.datasource.id
}
