variable "container_registry" {
  description = "Address of the container registry where Cyral images are stored"
  type        = string
  validation {
    condition     = length(var.container_registry) > 0
    error_message = "The container registry must not be empty"
  }
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
  sensitive   = true
}

variable "client_id" {
  description = "The client id assigned to the sidecar"
  type        = string
}

variable "client_secret" {
  description = "The client secret assigned to the sidecar"
  type        = string
  sensitive   = true
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

variable "name_prefix" {
  description = "Prefix for names of created resources in AWS. Maximum length is 24 characters."
  type        = string
  default     = ""
}

variable "sidecar_id" {
  description = "Sidecar identifier"
  type        = string
}

variable "sidecar_custom_certificate_account_id" {
  description = "(Optional) AWS Account ID where the custom certificate module will be deployed."
  type        = string
  default     = ""
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
}

variable "sidecar_version" {
  description = "Version of the sidecar"
  type        = string
}

variable "repositories_supported" {
  description = "List of all repositories that will be supported by the sidecar (lower case only)"
  type        = list(string)
  default     = ["denodo", "dremio", "dynamodb", "mongodb", "mysql", "oracle", "postgresql", "redshift", "snowflake", "sqlserver", "s3"]
}

variable "custom_user_data" {
  description = "Ancillary consumer supplied user-data script. Bash scripts must be added to a map as a value of the key `pre`, `pre_sidecar_start`, `post` denoting execution order with respect to sidecar installation. (Approx Input Size = 19KB)"
  type        = map(any)
  default     = { "pre" = "", "pre_sidecar_start" = "", "post" = "" }
}

variable "sidecar_tls_certificate_secret_arn" {
  description = "(Optional) ARN of secret in AWS Secrets Manager that contains a certificate to terminate TLS connections."
  type        = string
  default     = ""
}

variable "sidecar_tls_certificate_role_arn" {
  description = "(Optional) ARN of an AWS IAM Role to assume when reading the TLS certificate."
  type        = string
  default     = ""
}

variable "sidecar_ca_certificate_secret_arn" {
  description = "(Optional) ARN of secret in AWS Secrets Manager that contains a CA certificate to sign sidecar-generated certs."
  type        = string
  default     = ""
}

variable "sidecar_ca_certificate_role_arn" {
  description = "(Optional) ARN of an AWS IAM Role to assume when reading the CA certificate."
  type        = string
  default     = ""
}

variable "sidecar_custom_host_role" {
  description = "(Optional) Name of an AWS IAM Role to attach to the EC2 instance profile."
  type        = string
  default     = ""
}

variable "cloudwatch_log_group_name" {
  description = "(Optional) Cloudwatch log group name."
  type        = string
  default     = ""
}

variable "tls_skip_verify" {
  description = "(Optional) Skip TLS verification for HTTPS communication with the control plane and during sidecar initialization"
  type        = bool
  default     = false
}
