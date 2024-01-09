locals {
  sidecar_secrets = {
    clientId                    = var.client_id
    clientSecret                = var.client_secret
    containerRegistryKey        = var.container_registry_key
    sidecarPublicIdpCertificate = replace(var.sidecar_public_idp_certificate, "\n", "\\n")
    sidecarPrivateIdpKey        = replace(var.sidecar_private_idp_key, "\n", "\\n")
  }
  create_custom_tls_certificate_secret = var.sidecar_custom_certificate_account_id != ""
  sidecar_secrets_secret_name          = var.secrets_location != "" ? var.secrets_location : "/cyral/sidecars/${var.sidecar_id}/secrets"
  
  self_signed_ca_secret_name       = "/cyral/sidecars/${var.sidecar_id}/ca-certificate"
  self_signed_tls_cert_secret_name = "/cyral/sidecars/${var.sidecar_id}/self-signed-certificate"

  self_signed_cert_country               = "US"
  self_signed_cert_province              = "CA"
  self_signed_cert_locality              = "Redwood City"
  self_signed_cert_organization          = "Cyral Inc."
  self_signed_cert_validity_period_hours = 10 * 365 * 24

  self_signed_ca_payload = {
    key  = tls_private_key.ca.private_key_pem
    cert = tls_self_signed_cert.ca.cert_pem
  }
  self_signed_tls_cert_payload = {
    key  = tls_private_key.tls.private_key_pem
    cert = tls_self_signed_cert.tls.cert_pem
  }

  previous_ca_secret_exists = length(data.aws_secretsmanager_secrets.previous_ca.arns) > 0
  previous_ca_exists        = local.previous_ca_secret_exists ? (
      data.aws_secretsmanager_secret_version.previous_ca_contents[0].secret_string != "" ? true : false
  ) : false

  previous_tls_cert_secret_exists = length(data.aws_secretsmanager_secrets.previous_tls_cert.arns) > 0
  previous_tls_cert_exists        = local.previous_tls_cert_secret_exists ? (
      data.aws_secretsmanager_secret_version.previous_tls_cert_contents[0].secret_string != "" ? true : false
  ) : false
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

moved {
  from = aws_secretsmanager_secret.sidecar_custom_certificate
  to   = aws_secretsmanager_secret.custom_tls_certificate
}
resource "aws_secretsmanager_secret" "custom_tls_certificate" {
  count                   = local.create_custom_tls_certificate_secret ? 1 : 0
  name                    = "/cyral/sidecars/certificate/${local.name_prefix}"
  description             = "Custom certificate used by Cyral sidecar for TLS. This secret will be controlled by the Sidecar Custom Certificate module."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}

resource "tls_private_key" "tls" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "tls" {
  private_key_pem   = tls_private_key.tls.private_key_pem
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
  private_key_pem   = tls_private_key.ca.private_key_pem
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

data "aws_secretsmanager_secrets" "previous_ca" {
  filter {
    name   = "name"
    values = [local.self_signed_ca_secret_name]
  }
}

data "aws_secretsmanager_secret_version" "previous_ca_contents" {
  count = local.previous_ca_secret_exists ? 1 : 0
  secret_id = aws_secretsmanager_secret.self_signed_ca.id
}

resource "aws_secretsmanager_secret_version" "self_signed_ca" {
  secret_id     = aws_secretsmanager_secret.self_signed_ca.id
  secret_string = local.previous_ca_secret_exists ? data.aws_secretsmanager_secret_version.previous_ca_contents[0].secret_string : jsonencode(local.self_signed_ca_payload)
}

data "aws_secretsmanager_secrets" "previous_tls_cert" {
  filter {
    name   = "name"
    values = [local.self_signed_tls_cert_secret_name]
  }
}

data "aws_secretsmanager_secret_version" "previous_tls_cert_contents" {
  count = local.previous_tls_cert_secret_exists ? 1 : 0
  secret_id = aws_secretsmanager_secret.self_signed_tls_cert.id
}

resource "aws_secretsmanager_secret_version" "self_signed_tls_cert" {
  secret_id     = aws_secretsmanager_secret.self_signed_tls_cert.id
  secret_string = local.previous_tls_cert_secret_exists ? data.aws_secretsmanager_secret_version.previous_tls_cert_contents[0].secret_string : jsonencode(local.self_signed_tls_cert_payload)
}
