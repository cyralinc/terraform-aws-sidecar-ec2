locals {
  sidecar_secrets = {
    clientId                    = var.client_id
    clientSecret                = var.client_secret
    containerRegistryKey        = var.container_registry_key
    sidecarPublicIdpCertificate = replace(var.sidecar_public_idp_certificate, "\n", "\\n")
    sidecarPrivateIdpKey        = replace(var.sidecar_private_idp_key, "\n", "\\n")
  }
  create_sidecar_custom_certificate_secret = var.sidecar_custom_certificate_account_id != ""
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

resource "aws_secretsmanager_secret" "sidecar_custom_certificate" {
  count                   = local.create_sidecar_custom_certificate_secret ? 1 : 0
  name                    = "/cyral/sidecars/certificate/${local.name_prefix}"
  description             = "Custom certificate used by Cyral sidecar for TLS. This secret will be controlled by the Sidecar Custom Certificate module."
  recovery_window_in_days = 0
  kms_key_id              = var.secrets_kms_arn
}
