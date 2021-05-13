output "sidecar_dns" {
  value       = local.sidecar_endpoint
  description = "Sidecar DNS endpoint"
}

output "sidecar_load_balancer_dns" {
  value       = aws_lb.cyral-lb.dns_name
  description = "Sidecar load balancer DNS endpoint"
}

output "aws_iam_role_arn" {
	value = aws_iam_role.sidecar_role.arn
	description = "Sidecar IAM role ARN"
}

output "aws_security_group_id" {
	value = aws_security_group.instance.id
	description = "Sidecar security group id"
}