resource "aws_cloudwatch_log_group" "lg" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention
  tags              = var.custom_tags
}
