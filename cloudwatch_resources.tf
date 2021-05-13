resource "aws_cloudwatch_log_group" "cyral-sidecar-lg" {
  name  = var.name_prefix
  retention_in_days = var.cloudwatch_logs_retention
}
