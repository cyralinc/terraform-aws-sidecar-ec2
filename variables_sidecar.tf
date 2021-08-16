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

variable "node_exporter_port" {
  description = "Port of the node exporter container"
  type = number
  default = 9001
}
##########################################################################################################

variable "sidecar_dremio_ports" {
  description = "List of ports allowed to connect to Dremio in sidecar"
  type        = list(number)
  default     = [31010, 31011, 31012, 31013, 31014]
}

variable "sidecar_mongodb_ports" {
  description = "List of ports allowed to connect to MongoDB in sidecar"
  type        = list(number)
  default     = [27017, 27018, 27019, 27020, 27021, 27022, 27023, 27024, 27025, 27026, 27027, 27028]
}

variable "sidecar_mysql_ports" {
  description = "List of ports allowed to connect to MySQL in sidecar"
  type        = list(number)
  default     = [3306, 3307, 3308, 3309, 3310]
}

variable "sidecar_oracle_ports" {
  description = "List of ports allowed to connect to OracleDB in sidecar"
  type        = list(number)
  default     = [1521, 1522, 1523, 1524, 1525]
}

variable "sidecar_postgresql_ports" {
  description = "List of ports allowed to connect to PostgreSQL in sidecar"
  type        = list(number)
  default     = [5432, 5433, 5434, 5435, 5436]
}

variable "sidecar_snowflake_ports" {
  description = "List of ports allowed to connect to Snowflake in sidecar"
  type        = list(number)
  default     = [443, 444, 445, 446, 447]
}

variable "sidecar_sqlserver_ports" {
  description = "List of ports allowed to connect to SQLServer in sidecar"
  type        = list(number)
  default     = [1433, 1434, 1435, 1436, 1437]
}

variable "sidecar_s3_ports" {
  description = "List of ports allowed to connect to S3 in sidecar"
  type        = list(number)
  default     = [453]
}

variable "sidecar_version" {
  description = "Version of the sidecar"
  type        = string
}

variable "repositories_supported" {
  description = "List of all repositories that will be supported by the sidecar (lower case only)"
  type        = list(string)
  default     = ["dremio", "mongodb", "mysql", "oracle", "postgresql", "snowflake", "sqlserver", "s3"]
}

