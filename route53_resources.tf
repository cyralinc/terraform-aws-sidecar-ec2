resource "aws_route53_record" "cyral-sidecar-dns-record" {
  count           = var.deploy_load_balancer && var.dns_hosted_zone_id != "" && var.dns_name != "" ? 1 : 0
  zone_id         = var.dns_hosted_zone_id
  name            = var.dns_name
  type            = "CNAME"
  ttl             = "300"
  records         = [aws_lb.lb[0].dns_name]
  allow_overwrite = var.dns_overwrite
}
