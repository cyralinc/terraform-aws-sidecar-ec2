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

  # Flat list of all ports allowed to connect to the sidecar
  sidecar_ports = toset(
    concat(
      contains(var.repositories_supported, "dremio") ? var.sidecar_dremio_ports : [],
      contains(var.repositories_supported, "mongodb") ? var.sidecar_mongodb_ports : [],
      contains(var.repositories_supported, "mysql") ? var.sidecar_mysql_ports : [],
      contains(var.repositories_supported, "oracle") ? var.sidecar_oracle_ports : [],
      contains(var.repositories_supported, "postgresql") ? var.sidecar_postgresql_ports : [],
      contains(var.repositories_supported, "rest") ? var.sidecar_rest_ports : [],
      contains(var.repositories_supported, "snowflake") && var.load_balancer_certificate_arn != "" ? var.sidecar_snowflake_ports : [],
      contains(var.repositories_supported, "sqlserver") ? var.sidecar_sqlserver_ports : [],
      contains(var.repositories_supported, "s3") ? var.sidecar_s3_ports : [],
      contains(var.repositories_supported, "snowflake") || contains(var.repositories_supported, "rest") ? var.sidecar_http_ports : []
    )
  )

  sidecar_tls_ports = toset(
    concat(
      contains(var.repositories_supported, "snowflake") && var.load_balancer_certificate_arn != "" ? concat(var.sidecar_snowflake_ports, var.load_balancer_tls_ports) : [],
    )
  )

  # List of pairs of min/max ports per db allowed to connect to the sidecar
  sidecar_ports_range = [
    # Loop through the list and remove ports from disabled wires
    for v in [
      contains(var.repositories_supported, "dremio") ? [min(var.sidecar_dremio_ports...), max(var.sidecar_dremio_ports...)] : [],
      contains(var.repositories_supported, "mongodb") ? [min(var.sidecar_mongodb_ports...), max(var.sidecar_mongodb_ports...)] : [],
      contains(var.repositories_supported, "mysql") ? [min(var.sidecar_mysql_ports...), max(var.sidecar_mysql_ports...)] : [],
      contains(var.repositories_supported, "oracle") ? [min(var.sidecar_oracle_ports...), max(var.sidecar_oracle_ports...)] : [],
      contains(var.repositories_supported, "postgresql") ? [min(var.sidecar_postgresql_ports...), max(var.sidecar_postgresql_ports...)] : [],
      contains(var.repositories_supported, "rest") ? [min(var.sidecar_rest_ports...), max(var.sidecar_rest_ports...)] : [],
      contains(var.repositories_supported, "snowflake") ? [min(var.sidecar_snowflake_ports...), max(var.sidecar_snowflake_ports...)] : [],
      contains(var.repositories_supported, "sqlserver") ? [min(var.sidecar_sqlserver_ports...), max(var.sidecar_sqlserver_ports...)] : [],
      contains(var.repositories_supported, "s3") ? [min(var.sidecar_s3_ports...), max(var.sidecar_s3_ports...)] : []
    ] : v if length(v) > 0 ]
}
