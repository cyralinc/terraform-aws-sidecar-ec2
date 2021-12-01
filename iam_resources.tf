# Gets the ARN from a resource that is deployed by this module in order to
# get the proper partition, region and account number for the aws account
# where the resources are actually deployed. This prevents issues with
# deployment pipelines that runs on AWS and deploys to different accounts.
data "aws_arn" "cw_lg" {
  arn = aws_cloudwatch_log_group.cyral-sidecar-lg.arn
}

data "aws_iam_policy_document" "init_script_policy" {
  # Policy doc to allow sidecar to function inside an ASG
  statement {
    actions = [
      "ec2:DescribeTags",
      "autoscaling:CompleteLifecycleAction"
    ]
    resources = [
      "*"
    ]
  }

  # Cloudwatch permissions
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.cyral-sidecar-lg.arn}:*"
    ]
  }

  # Secrets Manager permissions
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = compact([
      "arn:${data.aws_arn.cw_lg.partition}:secretsmanager:${data.aws_arn.cw_lg.region}:${data.aws_arn.cw_lg.account}:secret:/cyral/*",
      "arn:${data.aws_arn.cw_lg.partition}:secretsmanager:${data.aws_arn.cw_lg.region}:${data.aws_arn.cw_lg.account}:secret:${var.secrets_location}*"
    ])
  }
}

data "aws_iam_policy_document" "sidecar" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "sidecar_profile" {
  name = "${var.name_prefix}-sidecar_profile"
  role = aws_iam_role.sidecar_role.name
}

resource "aws_iam_role" "sidecar_role" {
  name               = "${var.name_prefix}-sidecar_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sidecar.json
}

resource "aws_iam_policy" "init_script_policy" {
  name        = "${var.name_prefix}-init_script_policy"
  path        = "/"
  description = "Allow EC2 to update ASG when init complete"
  policy      = data.aws_iam_policy_document.init_script_policy.json
}

resource "aws_iam_role_policy_attachment" "init_script_policy" {
  role       = aws_iam_role.sidecar_role.name
  policy_arn = aws_iam_policy.init_script_policy.arn
}

resource "aws_iam_role_policy_attachment" "user_policies" {
  for_each   = toset(var.iam_policies)
  role       = aws_iam_role.sidecar_role.name
  policy_arn = each.value
}
