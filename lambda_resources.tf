locals {
  sidecar_created_certificate_s3bucket = var.sidecar_certificate_lambda_bucket != "" ? (
    var.sidecar_certificate_lambda_bucket
  ) : "cyral-public-assets-${data.aws_arn.cw_lg.region}"
  sidecar_created_certificate_s3key = var.sidecar_certificate_lambda_key != "" ? (
    var.sidecar_certificate_lambda_key
  ) : "sidecar-created-certificate/${var.sidecar_certificate_lambda_version}/sidecar-created-certificate-lambda-${var.sidecar_certificate_lambda_version}.zip"
}

resource "aws_lambda_function" "sidecar_created_certificate" {
  function_name = "${var.name_prefix}-sidecar_created_certificate"
  role          = aws_iam_role.sidecar_created_certificate_lambda_execution.arn
  runtime       = "go1.x"
  handler       = "certmgr-lambda"
  timeout       = 180
  s3_bucket     = local.sidecar_created_certificate_s3bucket
  s3_key        = local.sidecar_created_certificate_s3key

  environment {
    variables = {
      SIDECAR_CREATED_CERTIFICATE_AWS_REGION = data.aws_arn.cw_lg.region
      SIDECAR_CREATED_CERTIFICATE_SIDECAR_ID = var.sidecar_id
      SIDECAR_CREATED_CERTIFICATE_SIDECAR_HOSTS = "${var.sidecar_dns_name}" != "" ? (
        "${var.sidecar_dns_name}"
        ) : (
        "sidecar.app.cyral.com"
      )
    }
  }

  # Need permissions by inner policy to be created before lambda invocation can
  # execute.
  depends_on = [
    aws_iam_role_policy.sidecar_created_certificate_lambda_execution
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_invocation" "sidecar_created_certificate" {
  function_name = aws_lambda_function.sidecar_created_certificate.function_name
  input         = jsonencode({})
  depends_on = [
    aws_iam_role_policy.sidecar_created_certificate_lambda_execution
  ]
}
