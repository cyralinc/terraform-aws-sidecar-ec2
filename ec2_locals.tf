# Get AWS Partition, Region, and Account ID defined by the user in `provider` section.
data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_partition  = data.aws_partition.current.partition
  aws_region     = data.aws_region.current.name
  aws_account_id = data.aws_caller_identity.current.account_id

  sidecar_endpoint = var.deploy_load_balancer ? (
    (length(aws_route53_record.cyral-sidecar-dns-record) == 0 && length(var.sidecar_dns_name) > 0) ? (
      var.sidecar_dns_name
      ) : (
      length(aws_route53_record.cyral-sidecar-dns-record) == 1 ? aws_route53_record.cyral-sidecar-dns-record[0].fqdn : aws_lb.lb[0].dns_name
    )
  ) : ""

  curl                      = var.tls_skip_verify ? "curl -k" : "curl"
  name_prefix               = var.name_prefix == "" ? "cyral-${substr(lower(var.sidecar_id), -6, -1)}" : var.name_prefix
  cloudwatch_log_group_name = var.cloudwatch_log_group_name == "" ? local.name_prefix : var.cloudwatch_log_group_name

  templatevars = {
    sidecar_id                            = var.sidecar_id
    name_prefix                           = local.name_prefix
    controlplane_host                     = var.control_plane
    container_registry                    = var.container_registry
    container_registry_username           = var.container_registry_username
    curl                                  = local.curl
    sidecar_endpoint                      = local.sidecar_endpoint
    aws_region                            = local.aws_region
    aws_account_id                        = local.aws_account_id
    log_group_name                        = aws_cloudwatch_log_group.lg.name
    sidecar_secret_name                   = local.sidecar_secret_name
    idp_sso_login_url                     = var.idp_sso_login_url
    load_balancer_tls_ports               = join(",", var.load_balancer_tls_ports)
    sidecar_version                       = var.sidecar_version
    repositories_supported                = join(",", var.repositories_supported)
    cloudwatch_log_group_name             = local.cloudwatch_log_group_name
    sidecar_tls_certificate_secret_arn = (
      var.sidecar_tls_certificate_secret_arn != "" ?
      var.sidecar_tls_certificate_secret_arn :
      aws_secretsmanager_secret.self_signed_tls_cert.arn
    )
    sidecar_tls_certificate_role_arn = var.sidecar_tls_certificate_role_arn
    sidecar_ca_certificate_secret_arn = (
      var.sidecar_ca_certificate_secret_arn != "" ?
      var.sidecar_ca_certificate_secret_arn :
      aws_secretsmanager_secret.self_signed_ca.arn
    )
    sidecar_ca_certificate_role_arn   = var.sidecar_ca_certificate_role_arn
    tls_skip_verify                   = var.tls_skip_verify ? "tls-skip-verify" : "tls"
    recycle_health_check_interval_sec = var.recycle_health_check_interval_sec
  }

  cloud_init_func = templatefile("${path.module}/files/cloud-init-functions.sh.tmpl", local.templatevars)
  cloud_init_pre  = templatefile("${path.module}/files/cloud-init-pre.sh.tmpl", local.templatevars)
  cloud_init_post = templatefile("${path.module}/files/cloud-init-post.sh.tmpl", local.templatevars)
}
