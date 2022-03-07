locals {
  self_signed_certificate_lambda_code_version = "v0.1.0"
  self_signed_certificate_sidecar_hosts = "${var.sidecar_dns_name}" != "" ? (
    "${var.sidecar_dns_name}"
    ) : (
    "poc.cyral.com"
  )
}

resource "aws_lambda_function" "self_signed_certificate" {
  function_name = "${var.name_prefix}-self_signed_certificate"
  role          = aws_iam_role.self_signed_certificate_lambda_execution.arn
  runtime       = "go1.x"
  handler       = "selfsigned-lambda"
  timeout       = 120
  s3_bucket     = "cyral-public-assets-${data.aws_arn.cw_lg.region}"
  s3_key        = "sidecar-certificate-selfsigned/${local.self_signed_certificate_lambda_code_version}/sidecar-certificate-selfsigned-lambda-${local.self_signed_certificate_lambda_code_version}.zip"

  environment {
    variables = {
      SIDECAR_SELFSIGNED_CERTIFICATE_AWS_REGION    = data.aws_arn.cw_lg.region
      SIDECAR_SELFSIGNED_CERTIFICATE_SIDECAR_ID    = var.sidecar_id
      SIDECAR_SELFSIGNED_CERTIFICATE_SIDECAR_HOSTS = local.self_signed_certificate_sidecar_hosts
    }
  }
}

resource "aws_lambda_invocation" "self_signed_certificate" {
  function_name = aws_lambda_function.self_signed_certificate.function_name
  input         = jsonencode({})
}
