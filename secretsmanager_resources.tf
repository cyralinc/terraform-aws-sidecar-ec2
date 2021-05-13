locals {
  sidecar_secrets = {
    clientId             = var.client_id
    clientSecret         = var.client_secret
    containerRegistryKey = var.container_registry_key
  }
}

resource "aws_secretsmanager_secret" "cyral-sidecar-secret" {
  count = var.deploy_secrets ? 1 : 0
  name  = var.secrets_location
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "cyral-sidecar-secret-version" {
  count         = var.deploy_secrets ? 1 : 0
  secret_id     = aws_secretsmanager_secret.cyral-sidecar-secret[0].id
  secret_string = jsonencode(local.sidecar_secrets)
}
