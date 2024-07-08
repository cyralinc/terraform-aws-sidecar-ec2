# TODO: Remove `moved` in next major
moved {
  from = aws_cloudwatch_log_group.cyral-sidecar-lg
  to   = aws_cloudwatch_log_group.lg
}
resource "aws_cloudwatch_log_group" "lg" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention
}
