locals {
  sidecar_secrets = {
    clientId             = var.client_id
    clientSecret         = var.client_secret
    containerRegistryKey = var.container_registry_key
  }
}

resource "aws_secretsmanager_secret" "cyral-sidecar-secret" {
  count                   = var.deploy_secrets ? 1 : 0
  name                    = var.secrets_location
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "cyral-sidecar-secret-version" {
  count         = var.deploy_secrets ? 1 : 0
  secret_id     = aws_secretsmanager_secret.cyral-sidecar-secret[0].id
  secret_string = jsonencode(local.sidecar_secrets)
}

resource "aws_secretsmanager_secret" "self_signed_certificate" {
  name                    = "/cyral/sidecars/${var.sidecar_id}/self-signed-certificate"
  description             = "Self-signed TLS certificate used by sidecar in case CA-signed is not found."
  recovery_window_in_days = 0
}
