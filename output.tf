output "autoscaling_group_arn" {
  value       = aws_autoscaling_group.asg.arn
  description = "Auto scaling group ARN"
}

output "cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.lg.name
  description = "Name of the CloudWatch log group where sidecar logs are stored"
}

output "iam_role_arn" {
  value       = local.create_sidecar_role ? aws_iam_role.sidecar_role[0].arn : null
  description = "Sidecar IAM role ARN"
}

output "security_group_id" {
  value       = aws_security_group.instance.id
  description = "Sidecar security group id"
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

output "secret_arn" {
  value       = local.deploy_sidecar_secret ? aws_secretsmanager_secret.sidecar_secrets[0].arn : null
  description = "Sidecar secret ARN"
}

output "dns" {
  value       = local.sidecar_endpoint
  description = "Sidecar DNS endpoint"
}

output "load_balancer_dns" {
  value       = var.deploy_load_balancer ? aws_lb.lb[0].dns_name : null
  description = "Sidecar load balancer DNS endpoint"
}
