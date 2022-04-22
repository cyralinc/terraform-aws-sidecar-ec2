locals {
  output_certificate_casigned_secret_arn = var.sidecar_certficate_casigned_account_id != ""
  output_certificate_casigned_role_arn   = local.output_certificate_casigned_secret_arn
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
  value       = aws_iam_role.sidecar_role.arn
  description = "Sidecar IAM role ARN"
}

output "aws_security_group_id" {
  value       = aws_security_group.instance.id
  description = "Sidecar security group id"
}

output "sidecar_certificate_casigned_secret_arn" {
  value = local.output_certificate_casigned_secret_arn ? (
    aws_secretsmanager_secret.casigned_certificate[0].id
    ) : (
    null
  )
  description = "Secret ARN to use in the Sidecar Certificate CA-signed module"
}

output "sidecar_certificate_casigned_role_arn" {
  value = local.output_certificate_casigned_role_arn ? (
    aws_iam_role.casigned_certificate[0].arn
    ) : (
    null
  )
  description = "IAM role ARN to use in the Sidecar Certificate CA-signed module"
}
