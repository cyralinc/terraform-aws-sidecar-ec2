locals {
  output_sidecar_custom_certificate_secret_arn = var.sidecar_custom_certificate_account_id != ""
  output_sidecar_custom_certificate_role_arn   = local.output_sidecar_custom_certificate_secret_arn
}

output "sidecar_dns" {
  value       = local.sidecar_endpoint
  description = "Sidecar DNS endpoint"
}

output "sidecar_load_balancer_dns" {
  value       = aws_lb.cyral-lb.dns_name
  description = "Sidecar load balancer DNS endpoint"
}

output "aws_iam_role_arn" {
  value       = local.create_sidecar_role ? aws_iam_role.sidecar_role[0].arn : null
  description = "Sidecar IAM role ARN"
}

output "aws_security_group_id" {
  value       = aws_security_group.instance.id
  description = "Sidecar security group id"
}

output "sidecar_custom_certificate_secret_arn" {
  value = local.output_sidecar_custom_certificate_secret_arn ? (
    aws_secretsmanager_secret.sidecar_custom_certificate[0].id
    ) : (
    null
  )
  description = "Secret ARN to use in the Sidecar Custom Certificate modules."
}

output "sidecar_custom_certificate_role_arn" {
  value = local.output_sidecar_custom_certificate_role_arn ? (
    aws_iam_role.sidecar_custom_certificate[0].arn
    ) : (
    null
  )
  description = "IAM role ARN to use in the Sidecar Custom Certificate modules."
}
