resource "aws_cloudwatch_log_group" "cyral-sidecar-lg" {
  name              = local.name_prefix
  retention_in_days = var.cloudwatch_logs_retention
}
