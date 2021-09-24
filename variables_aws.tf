variable "ami_id" {
  description = <<EOF
Amazon Linux 2 AMI ID for sidecar EC2 instances. The default behavior is to use the latest version.
In order to define a new image, provide the desired image id.
EOF
  type        = string
  default     = ""
}

variable "asg_count" {
  description = "Set to 1 to enable the ASG, 0 to disable. Only for debugging."
  type        = number
  default     = 1
}

variable "asg_min" {
  description = "The minimum number of hosts to create in the autoscale group"
  type        = number
  default     = 1
}

variable "asg_desired" {
  description = "The desired number of hosts to create in the autoscale group"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "The maximum number of hosts to create in the autoscale group."
  type        = number
  default     = 2
}

variable "health_check_grace_period" {
  description = "The grace period in seconds before the health check will terminate the instance"
  type        = number
  default     = 600
}

variable "instance_type" {
  description = "Amazon EC2 instance type for the sidecar instances"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "AWS key name"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "AWS VPC ID to deploy sidecar to"
  type        = string
}

variable "subnets" {
  description = "Subnets to add sidecar to (list of string)"
  type        = list(string)
}

variable "load_balancer_subnets" {
  description = "Subnets to add load balancer to. If not provided, the load balancer will assume the subnets specified in the `subnets` parameter."
  type        = list(string)
  default     = []
}

variable "load_balancer_scheme" {
  description = "EC2 network load balancer scheme ('internal' or 'internet-facing')"
  type        = string
  default     = "internal"
}

variable "load_balancer_tls_ports" {
  description = <<EOF
List of ports that will have TLS terminated at load balancer level
(snowflake support, for example). If assigned, 'load_balancer_certificate_arn' 
must also be provided. This parameter must be a subset of 'sidecar_ports'.
EOF
  type        = list(number)
  default     = []
}

variable "volume_size" {
  description = "Size of the sidecar disk"
  type        = number
  default     = 30
}

variable "ssh_inbound_cidr" {
  description = "Allowed CIDR block for SSH access to the sidecar. Can't be combined with 'ssh_inbound_security_group'."
  type        = list(string)
}

variable "ssh_inbound_security_group" {
  description = "Pre-existing security group IDs allowed to ssh into the EC2 host. Can't be combined with 'ssh_inbound_cidr'."
  type        = list(string)
  default     = []
}

variable "db_inbound_cidr" {
  description = "Allowed CIDR block for database access to the sidecar. Can't be combined with 'db_inbound_security_group'."
  type        = list(string)
}

variable "db_inbound_security_group" {
  description = "Pre-existing security group IDs allowed to connect to db in the EC2 host. Can't be combined with 'db_inbound_cidr'."
  type        = list(string)
  default     = []
}

variable "healthcheck_inbound_cidr" {
  description = "Allowed CIDR block for health check requests to the sidecar"
  type        = list(string)
}

variable "healthcheck_port" {
  description = "Port used for the healthcheck"
  type        = number
  default     = 8888
}

variable "deploy_secrets" {
  description = "Create the AWS Secrets Manager resource at secret_location using client_id, client_secret and container_registry_key"
  type        = bool
  default     = true
}

variable "secrets_location" {
  description = "Location in AWS Secrets Manager to store client_id, client_secret and container_registry_key"
  type        = string
}

variable "associate_public_ip_address" {
  description = "Associates a public IP to sidecar EC2 instances"
  type        = bool
  default     = false
}

variable "additional_security_groups" {
  description = "Additional security groups to attach to sidecar instances"
  type        = list(string)
  default     = []
}

variable "cloudwatch_logs_retention" {
  description = "Cloudwatch logs retention in days"
  type        = number
  default     = 14
#  validation {
#    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cloudwatch_logs_retention)
#    error_message = "Valid values are: [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]."
#  }
}
