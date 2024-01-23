locals {
  sidecar_secrets = {
    clientId                    = var.client_id
    clientSecret                = var.client_secret
    containerRegistryKey        = var.container_registry_key
    sidecarPublicIdpCertificate = replace(var.sidecar_public_idp_certificate, "\n", "\\n")
    sidecarPrivateIdpKey        = replace(var.sidecar_private_idp_key, "\n", "\\n")
  }
  create_sidecar_custom_certificate_secret = var.sidecar_custom_certificate_account_id != ""
  sidecar_secrets_secret_name                = var.secrets_location != "" ? var.secrets_location : "/cyral/sidecars/${var.sidecar_id}/secrets"
  
  self_signed_ca_secret_name       = "/cyral/sidecars/${var.sidecar_id}/ca-certificate"
  self_signed_tls_cert_secret_name = "/cyral/sidecars/${var.sidecar_id}/self-signed-certificate"


  self_signed_cert_country               = "US"
  self_signed_cert_province              = "CA"
  self_signed_cert_locality              = "Redwood City"
  self_signed_cert_organization          = "Cyral Inc."
  self_signed_cert_validity_period_hours = 10 * 365 * 24

  self_signed_ca_payload = {
    key  = local.deploy_lambda ? "" : tls_private_key.ca[0].private_key_pem
    cert = local.deploy_lambda ? "" : tls_self_signed_cert.ca[0].cert_pem
  }
  self_signed_tls_cert_payload = {
    key  = local.deploy_lambda ? "" : tls_private_key.tls[0].private_key_pem
    cert = local.deploy_lambda ? "" : tls_self_signed_cert.tls[0].cert_pem
  }

  # Regions the lambda is currently supported by the
  # certificate lambda.
  lambda_regions = [
    "ap-northeast-1",
    "ap-northeast-2",
    "ap-northeast-3",
    "ap-south-1",
    "ap-southeast-1",
    "ap-southeast-2",
    "ca-central-1",
    "eu-central-1",
    "eu-north-1",
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
    "il-central-1",
    "me-central-1",
    "me-south-1",
    "sa-east-1",
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2"
  ]

  # Deploys the lambda in those regions it is supported and uses the
  # TLS provider for those regions that it does not exist. In version
  # v5 of this module we should remove the lambda completely and just
  # rely on the TLS provider to create the self-signed certificates.
  # We should be able to 
  deploy_lambda = contains(local.lambda_regions, local.aws_region)
}

# TODO: Remove `moved` in next major
moved {
  from = aws_secretsmanager_secret.cyral-sidecar-secret
  to   = aws_secretsmanager_secret.sidecar_secrets
}
resource "aws_secretsmanager_secret" "sidecar_secrets" {
  count                   = var.deploy_secrets ? 1 : 0
  name                    = local.sidecar_secrets_secret_name
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}

# TODO: Remove `moved` in next major
moved {
  from = aws_secretsmanager_secret_version.cyral-sidecar-secret-version
  to   = aws_secretsmanager_secret_version.sidecar_secrets
}
resource "aws_secretsmanager_secret_version" "sidecar_secrets" {
  count         = var.deploy_secrets ? 1 : 0
  secret_id     = aws_secretsmanager_secret.sidecar_secrets[0].id
  secret_string = jsonencode(local.sidecar_secrets)
}

# TODO: Remove `moved` in next major
moved {
  from = aws_secretsmanager_secret.sidecar_created_certificate
  to   = aws_secretsmanager_secret.self_signed_tls_cert
}
resource "aws_secretsmanager_secret" "self_signed_tls_cert" {
  name                    = local.self_signed_tls_cert_secret_name
  description             = "Self-signed TLS certificate used by sidecar in case a custom certificate is not provided."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}

# TODO: Remove `moved` in next major
moved {
  from = aws_secretsmanager_secret.sidecar_ca_certificate
  to   = aws_secretsmanager_secret.self_signed_ca
}
resource "aws_secretsmanager_secret" "self_signed_ca" {
  name                    = local.self_signed_ca_secret_name
  description             = "CA certificate used by sidecar in case a custom CA certificate is not provided."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}

# TODO: Remove `moved` in next major
moved {
  from = aws_secretsmanager_secret.sidecar_custom_certificate
  to   = aws_secretsmanager_secret.custom_tls_certificate
}
resource "aws_secretsmanager_secret" "custom_tls_certificate" {
  count                   = local.create_sidecar_custom_certificate_secret ? 1 : 0
  name                    = "/cyral/sidecars/certificate/${local.name_prefix}"
  description             = "Custom certificate used by Cyral sidecar for TLS. This secret will be controlled by the Sidecar Custom Certificate module."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}

resource "aws_lambda_function" "self_signed_certificate" {
  count = local.deploy_lambda ? 1 : 0
  function_name    = "${local.name_prefix}-self_signed_certificate"
  description      = "Generates certificates for the sidecar when needed"
  role             = aws_iam_role.self_signed_certificate.arn
  runtime          = "python3.10"
  filename         = "${path.module}/files/self-signed-certificate-lambda.zip"
  source_code_hash = filebase64sha256("${path.module}/files/self-signed-certificate-lambda.zip")
  handler          = "index.handler"
  layers = [
    "arn:aws:lambda:${local.aws_region}:155826672581:layer:pyopenssl:1"
  ]
  timeout = 120
}

resource "aws_lambda_invocation" "self_signed_tls_certificate" {
  count = local.deploy_lambda ? 1 : 0
  function_name = aws_lambda_function.self_signed_certificate[0].function_name
  input = jsonencode({
    SecretId        = aws_secretsmanager_secret.self_signed_tls_cert.id
    Hostname        = local.sidecar_endpoint
    IsCACertificate = false
  })
}

resource "aws_lambda_invocation" "self_signed_ca_certificate" {
  count = local.deploy_lambda ? 1 : 0
  function_name = aws_lambda_function.self_signed_certificate[0].function_name
  input = jsonencode({
    SecretId        = aws_secretsmanager_secret.self_signed_ca.id
    Hostname        = local.sidecar_endpoint
    IsCACertificate = true
  })
}


resource "tls_private_key" "tls" {
  count = local.deploy_lambda ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "ca" {
  count = local.deploy_lambda ? 0 : 1
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "tls" {
  count = local.deploy_lambda ? 0 : 1
  private_key_pem   = tls_private_key.tls[0].private_key_pem
  is_ca_certificate = false

  subject {
    country      = local.self_signed_cert_country
    province     = local.self_signed_cert_province
    locality     = local.self_signed_cert_locality
    organization = local.self_signed_cert_organization
    common_name  = local.sidecar_endpoint
  }

  validity_period_hours = local.self_signed_cert_validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "tls_self_signed_cert" "ca" {
  count = local.deploy_lambda ? 0 : 1
  private_key_pem   = tls_private_key.ca[0].private_key_pem
  is_ca_certificate = true

  subject {
    country      = local.self_signed_cert_country
    province     = local.self_signed_cert_province
    locality     = local.self_signed_cert_locality
    organization = local.self_signed_cert_organization
    common_name  = local.sidecar_endpoint
  }

  validity_period_hours = local.self_signed_cert_validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

resource "aws_secretsmanager_secret_version" "self_signed_ca" {
  count = local.deploy_lambda ? 0 : 1
  secret_id     = aws_secretsmanager_secret.self_signed_ca.id
  secret_string = jsonencode(local.self_signed_ca_payload)
}

resource "aws_secretsmanager_secret_version" "self_signed_tls_cert" {
  count = local.deploy_lambda ? 0 : 1
  secret_id     = aws_secretsmanager_secret.self_signed_tls_cert.id
  secret_string = jsonencode(local.self_signed_tls_cert_payload)
}
