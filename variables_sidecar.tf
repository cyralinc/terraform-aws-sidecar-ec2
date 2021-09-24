variable "container_registry" {
  description = "Address of the container registry where Cyral images are stored"
  type        = string
}

variable "container_registry_username" {
  description = "Username provided by Cyral for authenticating on Cyral's container registry"
  type        = string
  default     = ""
}

variable "container_registry_key" {
  description = "Key provided by Cyral for authenticating on Cyral's container registry"
  type        = string
  default     = ""
  # Only compatible with Terraform >=0.14
  #sensitive   = true
}

variable "client_id" {
  description = "The client id assigned to the sidecar"
  type        = string
}

variable "client_secret" {
  description = "The client secret assigned to the sidecar"
  type        = string
  # Only compatible with Terraform >=0.14
  #sensitive   = true
}

variable "control_plane" {
  description = "Address of the control plane - <tenant>.cyral.com"
  type        = string
}

variable "iam_policies" {
  description = "(Optional) List of IAM policies ARNs that will be attached to the sidecar IAM role"
  type        = list(string)
  default     = []
}

variable "log_integration" {
  description = "Logs destination"
  type        = string
  default     = "cloudwatch"
}

variable "metrics_integration" {
  description = "Metrics destination"
  type        = string
  default     = ""
}

variable "mongodb_port_alloc_range_low" {
  description = <<EOF
Initial value for MongoDB port allocation range. The consecutive ports in the
range `mongodb_port_alloc_range_low:mongodb_port_alloc_range_high` will be used
for mongodb cluster monitoring. All the ports in this range must be listed in
`sidecar_ports`.
EOF
  type        = number
  default     = 27017
}

variable "mongodb_port_alloc_range_high" {
  description = <<EOF
Final value for MongoDB port allocation range. The consecutive ports in the
range `mongodb_port_alloc_range_low:mongodb_port_alloc_range_high` will be used
for mongodb cluster monitoring. All the ports in this range must be listed in
`sidecar_ports`.
EOF
  type        = number
  default     = 27019
}

variable "name_prefix" {
  description = "Prefix for names of created resources in AWS"
  type        = string
}

variable "sidecar_id" {
  description = "Sidecar identifier"
  type        = string
}

##########################################################################################################
# Sidecar endpoint possibilities:
#
# 1. In order to automatically create a DNS CNAME in Route53 to the sidecar, assign values to
#    `sidecar_dns_hosted_zone_id` and `sidecar_dns_name`. To update an existing DNS, it is also required
#    to assign `true` to `sidecar_dns_overwrite`. This DNS name will be shown in the UI instead of the
#    load balancer DNS;
# 2. In order to associate a DNS CNAME that will be managed manually (case of Snowflake sidecar), use the
#    variable `sidecar_dns_name` and leave `sidecar_dns_hosted_zone_id` and `sidecar_dns_overwrite` with
#    default values. In this case,the informed DNS name will be shown in the UI instead of the load balancer
#    DNS.
#
variable "sidecar_dns_hosted_zone_id" {
  description = "(Optional) Route53 hosted zone ID for the corresponding 'sidecar_dns_name' provided"
  type        = string
  default     = ""
}

variable "sidecar_dns_name" {
  description = "(Optional) Fully qualified domain name that will be automatically created/updated to reference the sidecar LB"
  type        = string
  default     = ""
}

variable "sidecar_dns_overwrite" {
  description = "(Optional) Update an existing DNS name informed in 'sidecar_dns_name' variable"
  type        = bool
  default     = false
}
##########################################################################################################

variable "sidecar_ports" {
  description = "List of ports allowed to connect to the sidecar. See also 'load_balancer_tls_ports'."
  type        = list(number)
  default     = [80,443,453,1433,1521,3306,3307,5432,27017,31010]
}

variable "sidecar_version" {
  description = "Version of the sidecar"
  type        = string
}

variable "repositories_supported" {
  description = "List of all repositories that will be supported by the sidecar (lower case only)"
  type        = list(string)
  default     = ["dremio", "mongodb", "mysql", "oracle", "postgresql", "rest", "snowflake", "sqlserver", "s3"]
}
