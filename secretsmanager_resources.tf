locals {
  sidecar_secret = {
    clientId                    = var.client_id
    clientSecret                = var.client_secret
    containerRegistryKey        = var.container_registry_key
    sidecarPublicIdpCertificate = replace(var.sidecar_public_idp_certificate, "\n", "\\n")
    sidecarPrivateIdpKey        = replace(var.sidecar_private_idp_key, "\n", "\\n")
    idpCertificate              = replace(var.idp_certificate, "\n", "\\n")
  }

  deploy_sidecar_secret = length(var.secret_arn) == 0
  secret_arn            = local.deploy_sidecar_secret ? aws_secretsmanager_secret.sidecar_secrets[0].arn : var.secret_arn

  self_signed_cert_country               = "US"
  self_signed_cert_province              = "CA"
  self_signed_cert_locality              = "Redwood City"
  self_signed_cert_organization          = "Cyral Inc."
  self_signed_cert_validity_period_hours = 10 * 365 * 24
}

resource "aws_secretsmanager_secret" "sidecar_secrets" {
  count                   = local.deploy_sidecar_secret ? 1 : 0
  name                    = "/cyral/sidecars/${var.sidecar_id}/secrets"
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
  tags                    = var.custom_tags
}

resource "aws_secretsmanager_secret_version" "sidecar_secrets" {
  count         = local.deploy_sidecar_secret ? 1 : 0
  secret_id     = aws_secretsmanager_secret.sidecar_secrets[0].id
  secret_string = jsonencode(local.sidecar_secret)
}

resource "aws_secretsmanager_secret" "self_signed_tls_cert" {
  name                    = "/cyral/sidecars/${var.sidecar_id}/self-signed-certificate"
  description             = "Self-signed TLS certificate used by sidecar in case a custom certificate is not provided."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
  tags                    = var.custom_tags
}

resource "aws_secretsmanager_secret" "self_signed_ca" {
  name                    = "/cyral/sidecars/${var.sidecar_id}/ca-certificate"
  description             = "CA certificate used by sidecar in case a custom CA certificate is not provided."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
  tags                    = var.custom_tags
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

resource "aws_secretsmanager_secret_version" "self_signed_ca" {
  secret_id = aws_secretsmanager_secret.self_signed_ca.id
  secret_string = jsonencode({
    key  = tls_private_key.ca.private_key_pem
    cert = tls_self_signed_cert.ca.cert_pem
  })
}

resource "aws_secretsmanager_secret_version" "self_signed_tls_cert" {
  secret_id = aws_secretsmanager_secret.self_signed_tls_cert.id
  secret_string = jsonencode({
    key  = tls_private_key.tls.private_key_pem
    cert = tls_self_signed_cert.tls.cert_pem
  })
}
