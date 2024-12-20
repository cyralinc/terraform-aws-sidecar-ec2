variable "container_registry" {
  description = "Address of the container registry where Cyral images are stored."
  type        = string
  default     = "public.ecr.aws/cyral"
}

variable "client_id" {
  description = "(Optional) The client id assigned to the sidecar. If not provided, must provide a secret containing the respective client id using `secret_arn`."
  type        = string
  default     = ""
  validation {
    condition = (
      (length(var.client_id) > 0 && length(var.secret_arn) > 0) ||
      (length(var.client_id) == 0 && length(var.secret_arn) > 0) ||
      (length(var.client_id) > 0 && length(var.secret_arn) == 0)
    )
    error_message = "Must be provided if `secret_arn` is empty and must be empty if `secret_arn` is provided."
  }
}

variable "client_secret" {
  description = "(Optional) The client secret assigned to the sidecar. If not provided, must provide a secret containing the respective client secret using `secret_arn`."
  type        = string
  sensitive   = true
  default     = ""
  validation {
    condition = (
      (length(var.client_secret) > 0 && length(var.secret_arn) > 0) ||
      (length(var.client_secret) == 0 && length(var.secret_arn) > 0) ||
      (length(var.client_secret) > 0 && length(var.secret_arn) == 0)
    )
    error_message = "Must be provided if `secret_arn` is empty and must be empty if `secret_arn` is provided."
  }
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

variable "name_prefix" {
  description = "Prefix for names of created resources in AWS. Maximum length is 24 characters."
  type        = string
  default     = ""
}

variable "sidecar_id" {
  description = "Sidecar identifier"
  type        = string
}

##########################################################################################################
# Sidecar endpoint possibilities:
#
# 1. In order to automatically create a DNS CNAME in Route53 to the sidecar, assign values to
#    `dns_hosted_zone_id` and `dns_name`. To update an existing DNS, it is also required
#    to assign `true` to `dns_overwrite`. This DNS name will be shown in the UI instead of the
#    load balancer DNS;
# 2. In order to associate a DNS CNAME that will be managed manually (case of Snowflake sidecar), use the
#    variable `dns_name` and leave `dns_hosted_zone_id` and `dns_overwrite` with
#    default values. In this case,the informed DNS name will be shown in the UI instead of the load balancer
#    DNS.
#
variable "dns_hosted_zone_id" {
  description = "(Optional) Route53 hosted zone ID for the corresponding 'dns_name' provided"
  type        = string
  default     = ""
}

variable "dns_name" {
  description = "(Optional) Fully qualified domain name that will be automatically created/updated to reference the sidecar LB"
  type        = string
  default     = ""
}

variable "dns_overwrite" {
  description = "(Optional) Update an existing DNS name informed in `dns_name`."
  type        = bool
  default     = false
}
##########################################################################################################

variable "sidecar_ports" {
  description = "List of ports allowed to connect to the sidecar through the load balancer and security group. The maximum number of ports is limited to Network Load Balancers quotas (listeners and target groups). See also 'load_balancer_tls_ports'. Avoid port `9000` as it is reserved for instance monitoring."
  type        = list(number)
}

variable "sidecar_version" {
  description = "(Optional, but required for Control Planes < v4.10) The version of the sidecar. If unset and the Control Plane version is >= v4.10, the sidecar version will be dynamically retrieved from the Control Plane, otherwise an error will occur and this value must be provided."
  type        = string
  default     = ""
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

variable "tls_certificate_secret_arn" {
  description = "(Optional) ARN of secret in AWS Secrets Manager that contains a certificate to terminate TLS connections."
  type        = string
  default     = ""
}

variable "tls_certificate_role_arn" {
  description = "(Optional) ARN of an AWS IAM Role to assume when reading the TLS certificate."
  type        = string
  default     = ""
}

variable "ca_certificate_secret_arn" {
  description = "(Optional) ARN of secret in AWS Secrets Manager that contains a CA certificate to sign sidecar-generated certs."
  type        = string
  default     = ""
}

variable "ca_certificate_role_arn" {
  description = "(Optional) ARN of an AWS IAM Role to assume when reading the CA certificate."
  type        = string
  default     = ""
}

variable "custom_host_role" {
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

variable "recycle_health_check_interval_sec" {
  description = "(Optional) The interval (in seconds) in which the sidecar instance checks whether it has been marked or recycling."
  type        = number
  default     = 30
}

variable "curl_connect_timeout" {
  description = "(Optional) The maximum time in seconds that curl connections are allowed to take."
  type        = number
  default     = 60
}
