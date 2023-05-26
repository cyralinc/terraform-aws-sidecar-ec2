locals {
  sidecar_secrets = {
    clientId                    = var.client_id
    clientSecret                = var.client_secret
    containerRegistryKey        = var.container_registry_key
    sidecarPublicIdpCertificate = replace(var.sidecar_public_idp_certificate, "\n", "\\n")
    sidecarPrivateIdpKey        = replace(var.sidecar_private_idp_key, "\n", "\\n")
  }
  create_sidecar_custom_certificate_secret = var.sidecar_custom_certificate_account_id != ""
  selfsigned_cert_country                  = "US"
  selfsigned_cert_province                 = "CA"
  selfsigned_cert_locality                 = "Redwood City"
  selfsigned_cert_organization             = "Cyral Inc."
  selfsigned_cert_validity_period_hours    = 10 * 365 * 24
  sidecar_created_certificate_payload = {
    key  = tls_private_key.tls.private_key_pem
    cert = tls_self_signed_cert.tls.cert_pem
  }
  sidecar_ca_certificate_payload = {
    key  = tls_private_key.ca.private_key_pem
    cert = tls_self_signed_cert.ca.cert_pem
  }
}

resource "aws_secretsmanager_secret" "cyral-sidecar-secret" {
  count                   = var.deploy_secrets ? 1 : 0
  name                    = var.secrets_location
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}

resource "aws_secretsmanager_secret_version" "cyral-sidecar-secret-version" {
  count         = var.deploy_secrets ? 1 : 0
  secret_id     = aws_secretsmanager_secret.cyral-sidecar-secret[0].id
  secret_string = jsonencode(local.sidecar_secrets)
}

resource "aws_secretsmanager_secret" "sidecar_created_certificate" {
  name                    = "/cyral/sidecars/${var.sidecar_id}/self-signed-certificate"
  description             = "Self-signed TLS certificate used by sidecar in case a custom certificate is not provided."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}

resource "aws_secretsmanager_secret" "sidecar_ca_certificate" {
  name                    = "/cyral/sidecars/${var.sidecar_id}/ca-certificate"
  description             = "CA certificate used by sidecar in case a custom CA certificate is not provided."
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
    country      = local.selfsigned_cert_country
    province     = local.selfsigned_cert_province
    locality     = local.selfsigned_cert_locality
    organization = local.selfsigned_cert_organization
    common_name  = local.sidecar_endpoint
  }

  validity_period_hours = local.selfsigned_cert_validity_period_hours

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
    country      = local.selfsigned_cert_country
    province     = local.selfsigned_cert_province
    locality     = local.selfsigned_cert_locality
    organization = local.selfsigned_cert_organization
    common_name  = local.sidecar_endpoint
  }

  validity_period_hours = local.selfsigned_cert_validity_period_hours

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

data "aws_secretsmanager_secret_version" "existing_sidecar_created_certificate" {
  secret_id = aws_secretsmanager_secret.sidecar_created_certificate.id
}

resource "aws_secretsmanager_secret_version" "sidecar_created_certificate_version" {
  secret_id = aws_secretsmanager_secret.sidecar_created_certificate.id
  secret_string = data.aws_secretsmanager_secret_version.existing_sidecar_created_certificate.secret_string != "" ? (
    data.aws_secretsmanager_secret_version.existing_sidecar_created_certificate.secret_string
  ) : jsonencode(local.sidecar_created_certificate_payload)
}

data "aws_secretsmanager_secret_version" "existing_sidecar_ca_certificate" {
  secret_id = aws_secretsmanager_secret.sidecar_ca_certificate.id
}

resource "aws_secretsmanager_secret_version" "sidecar_ca_certificate_version" {
  secret_id = aws_secretsmanager_secret.sidecar_ca_certificate.id
  secret_string = data.aws_secretsmanager_secret_version.existing_sidecar_ca_certificate.secret_string != "" ? (
    data.aws_secretsmanager_secret_version.existing_sidecar_ca_certificate.secret_string
  ) : jsonencode(local.sidecar_ca_certificate_payload)
}

resource "aws_secretsmanager_secret" "sidecar_custom_certificate" {
  count                   = local.create_sidecar_custom_certificate_secret ? 1 : 0
  name                    = "/cyral/sidecars/certificate/${local.name_prefix}"
  description             = "Custom certificate used by Cyral sidecar for TLS. This secret will be controlled by the Sidecar Custom Certificate module."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}
