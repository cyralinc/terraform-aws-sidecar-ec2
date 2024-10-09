output "ami_id" {
  value       = local.ami_id
  description = "EC2 AMI id"
}

output "autoscaling_group_arn" {
  value       = aws_autoscaling_group.asg.arn
  description = "Auto scaling group ARN"
}

output "ca_certificate_secret_arn" {
  value       = local.ca_certificate_secret_arn
  description = "ARN of the CA certificate secret used by the sidecar"
}

output "cloudwatch_log_group_name" {
  value       = aws_cloudwatch_log_group.lg.name
  description = "Name of the CloudWatch log group where sidecar logs are stored"
}

output "dns" {
  value       = local.sidecar_endpoint
  description = "Sidecar DNS endpoint"
}

output "iam_role_arn" {
  value       = local.create_sidecar_role ? aws_iam_role.sidecar_role[0].arn : null
  description = "Sidecar IAM role ARN"
}

output "launch_template_arn" {
  value       = aws_launch_template.lt.arn
  description = "Launch template ARN"
}

output "load_balancer_arn" {
  value       = var.deploy_load_balancer ? aws_lb.lb[0].arn : null
  description = "Load balancer ARN"
}

output "load_balancer_dns" {
  value       = var.deploy_load_balancer ? aws_lb.lb[0].dns_name : null
  description = "Sidecar load balancer DNS endpoint"
}

output "secret_arn" {
  value       = local.secret_arn
  description = "ARN of the secret with the credentials used by the sidecar"
}

output "security_group_id" {
  value       = aws_security_group.instance.id
  description = "Sidecar security group id"
}

output "tls_certificate_secret_arn" {
  value       = local.tls_certificate_secret_arn
  description = "ARN of the TLS certificate secret used by the sidecar"
}

