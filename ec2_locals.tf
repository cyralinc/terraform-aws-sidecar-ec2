# Get AWS Region defined by the user in `provider` section.
data "aws_region" "current" {}

locals {
  sidecar_endpoint = (length(aws_route53_record.cyral-sidecar-dns-record) == 0 && length(var.sidecar_dns_name) > 0) ? (
    var.sidecar_dns_name
    ) : (
    length(aws_route53_record.cyral-sidecar-dns-record) == 1 ? aws_route53_record.cyral-sidecar-dns-record[0].fqdn : aws_lb.cyral-lb.dns_name
  )
  protocol    = var.external_tls_type == "no-tls" ? "http" : "https"
  curl        = var.external_tls_type == "tls-skip-verify" ? "curl -k" : "curl"
  name_prefix = var.name_prefix == "" ? "cyral-${substr(lower(var.sidecar_id), -6, -1)}" : var.name_prefix

  templatevars = {
    sidecar_id                            = var.sidecar_id
    name_prefix                           = local.name_prefix
    controlplane_host                     = var.control_plane
    container_registry                    = var.container_registry
    container_registry_username           = var.container_registry_username
    elk_address                           = var.elk_address
    elk_username                          = var.elk_username
    elk_password                          = var.elk_password
    sidecar_endpoint                      = local.sidecar_endpoint
    dd_api_key                            = var.dd_api_key
    aws_region                            = data.aws_region.current.name
    log_integration                       = var.log_integration
    metrics_integration                   = var.metrics_integration
    log_group_name                        = aws_cloudwatch_log_group.cyral-sidecar-lg.name
    secrets_location                      = var.secrets_location
    splunk_index                          = var.splunk_index
    splunk_host                           = var.splunk_host
    splunk_port                           = var.splunk_port
    splunk_tls                            = var.splunk_tls
    splunk_token                          = var.splunk_token
    sumologic_host                        = var.sumologic_host
    sumologic_uri                         = var.sumologic_uri
    idp_sso_login_url                     = var.idp_sso_login_url
    idp_certificate                       = var.idp_certificate
    sidecar_public_idp_certificate        = var.sidecar_public_idp_certificate
    sidecar_private_idp_key               = var.sidecar_private_idp_key
    hc_vault_integration_id               = var.hc_vault_integration_id
    mongodb_port_alloc_range_low          = var.mongodb_port_alloc_range_low
    mongodb_port_alloc_range_high         = var.mongodb_port_alloc_range_high
    mysql_multiplexed_port                = var.mysql_multiplexed_port
    sidecar_created_certificate_secret_id = aws_secretsmanager_secret.sidecar_created_certificate.arn
    load_balancer_tls_ports               = join(",", var.load_balancer_tls_ports)
    protocol                              = local.protocol
    curl                                  = local.curl
    sidecar_version                       = var.sidecar_version
    repositories_supported                = join(",", var.repositories_supported)
    metrics_port                          = var.metrics_port
    sidecar_tls_certificate_secret_arn = (
      var.sidecar_tls_certificate_secret_arn != "" ?
      var.sidecar_tls_certificate_secret_arn :
      aws_secretsmanager_secret.sidecar_created_certificate.arn
    )
    sidecar_tls_certificate_role_arn = var.sidecar_tls_certificate_role_arn
    sidecar_ca_certificate_secret_arn = (
      var.sidecar_ca_certificate_secret_arn != "" ?
      var.sidecar_ca_certificate_secret_arn :
      aws_secretsmanager_secret.sidecar_ca_certificate.arn
    )
    sidecar_ca_certificate_role_arn = var.sidecar_ca_certificate_role_arn
  }

  cloud_init_pre  = templatefile("${path.module}/files/cloud-init-pre.sh.tmpl", local.templatevars)
  cloud_init_post = templatefile("${path.module}/files/cloud-init-post.sh.tmpl", local.templatevars)
}
