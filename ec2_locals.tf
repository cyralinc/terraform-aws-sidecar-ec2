# Get AWS Region defined by the user in `provider` section.
data "aws_region" "current" {}

locals {
  sidecar_endpoint = (length(aws_route53_record.cyral-sidecar-dns-record) == 0 && length(var.sidecar_dns_name) > 0) ? (
    var.sidecar_dns_name
    ) : (
      length(aws_route53_record.cyral-sidecar-dns-record) == 1 ? aws_route53_record.cyral-sidecar-dns-record[0].fqdn : aws_lb.cyral-lb.dns_name
    )

  templatevars = {
    sidecar_id                  = var.sidecar_id
    name_prefix                 = var.name_prefix
    controlplane_host           = var.control_plane
    container_registry          = var.container_registry
    container_registry_username = var.container_registry_username
    elk_address                 = var.elk_address
    elk_username                = var.elk_username
    elk_password                = var.elk_password
    sidecar_endpoint            = local.sidecar_endpoint
    dd_api_key                  = var.dd_api_key
    aws_region                  = data.aws_region.current.name
    log_integration             = var.log_integration
    metrics_integration         = var.metrics_integration
    log_group_name              = aws_cloudwatch_log_group.cyral-sidecar-lg.name
    secrets_location            = var.secrets_location
    splunk_index                = var.splunk_index
    splunk_host                 = var.splunk_host
    splunk_port                 = var.splunk_port
    splunk_tls                  = var.splunk_tls
    splunk_token                = var.splunk_token
    sumologic_host              = var.sumologic_host
    sumologic_uri               = var.sumologic_uri
    idp_sso_login_url           = var.idp_sso_login_url
    idp_certificate             = var.idp_certificate
  }

  cloud_init_pre  = templatefile("${path.module}/files/cloud-init-pre.sh.tmpl", local.templatevars)
  cloud_init_post = templatefile("${path.module}/files/cloud-init-post.sh.tmpl", local.templatevars)

  security_groups = concat(
    [aws_security_group.instance.id],
    var.additional_security_groups
  )

  # Flat list of all ports allowed to connect to the sidecar
  sidecar_ports = toset(concat(var.sidecar_tcp_ports, var.sidecar_tls_ports))

  sidecar_tls_ports = toset(
    contains(var.repositories_supported, "snowflake") && var.load_balancer_certificate_arn != "" ? var.sidecar_tls_ports : []
  )
}
