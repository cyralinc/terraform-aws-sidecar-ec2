locals {
  output_sidecar_custom_certificate_secret_arn = var.sidecar_custom_certificate_account_id != ""
  output_sidecar_custom_certificate_role_arn   = local.output_sidecar_custom_certificate_secret_arn
}

output "autoscaling_group_arn" {
  value       = aws_autoscaling_group.asg[0].arn
  description = "Auto scaling group ARN"
}

# TODO: Rename to `cloudwatch_log_group_name` in next major version
output "aws_cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.lg.name
  description = "Name of the CloudWatch log group where sidecar logs are stored"
}

# TODO: Rename to `iam_role_arn` in next major version
output "aws_iam_role_arn" {
  value       = local.create_sidecar_role ? aws_iam_role.sidecar_role[0].arn : null
  description = "Sidecar IAM role ARN"
}

# TODO: Rename to `security_group_id` in next major version
output "aws_security_group_id" {
  value       = aws_security_group.instance.id
  description = "Sidecar security group id"
}

output "custom_tls_certificate_secret_arn" {
  value       = local.create_custom_tls_certificate_secret ? aws_secretsmanager_secret.custom_tls_certificate[0].arn : null
  description = "Sidecar custom certificate secret ARN"
}

output "launch_template_arn" {
  value       = aws_launch_template.lt.arn
  description = "Launch template ARN"
}

output "load_balancer_arn" {
  value       = var.deploy_load_balancer ? aws_lb.lb[0].arn : null
  description = "Load balancer ARN"
}

output "self_signed_ca_cert_secret_arn" {
  value       = aws_secretsmanager_secret.self_signed_ca.arn
  description = "Sidecar self signed CA certificate secret ARN"
}

output "self_signed_tls_cert_secret_arn" {
  value       = aws_secretsmanager_secret.self_signed_tls_cert.arn
  description = "Sidecar self signed TLS certificate secret ARN"
}

output "sidecar_credentials_secret_arn" {
  value       = var.deploy_secrets ? aws_secretsmanager_secret.sidecar_secrets[0].arn : null
  description = "Sidecar secret ARN"
}

# TODO: Rename to `custom_certificate_role_arn` in next major version
output "sidecar_custom_certificate_role_arn" {
  value = local.output_sidecar_custom_certificate_role_arn ? (
    aws_iam_role.sidecar_custom_certificate[0].arn
    ) : (
    null
  )
  description = "IAM role ARN to use in the Sidecar Custom Certificate modules"
}

# TODO: Rename to `custom_certificate_secret_arn` in next major version
output "sidecar_custom_certificate_secret_arn" {
  value = local.output_sidecar_custom_certificate_secret_arn ? (
    aws_secretsmanager_secret.custom_tls_certificate[0].id
    ) : (
    null
  )
  description = "Secret ARN to use in the Sidecar Custom Certificate modules"
}

# TODO: Rename to `dns` in next major version
output "sidecar_dns" {
  value       = local.sidecar_endpoint
  description = "Sidecar DNS endpoint"
}

# TODO: Rename to `load_balancer_dns` in next major version
output "sidecar_load_balancer_dns" {
  value       = var.deploy_load_balancer ? aws_lb.lb[0].dns_name : null
  description = "Sidecar load balancer DNS endpoint"
}
