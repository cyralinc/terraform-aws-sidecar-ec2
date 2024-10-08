variable "ami_id" {
  description = <<EOF
AMI ID that will be used for the EC2 instances. If not provided,
will use the latest Amazon Linux 2 AMI available.
EOF
  type        = string
  default     = ""
}

variable "asg_min" {
  description = "The minimum number of hosts to create in the auto scaling group"
  type        = number
  default     = 1
  validation {
    condition = (
      (var.asg_min == 1 && !var.deploy_load_balancer) ||
      var.deploy_load_balancer
    )
    error_message = "`asg_min` must be set to `1` in case `deploy_load_balancer` is `false`."
  }
}

variable "asg_desired" {
  description = "The desired number of hosts to create in the auto scaling group"
  type        = number
  default     = 1
  validation {
    condition = (
      ((var.asg_desired == 1 && !var.deploy_load_balancer) ||
      var.deploy_load_balancer) &&
      var.asg_desired >= var.asg_min &&
      var.asg_desired <= var.asg_max
    )
    error_message = "`asg_desired` must be `1` if `deploy_load_balancer = false` and `asg_min <= asg_desired <= asg_max`."
  }
}

variable "asg_max" {
  description = "The maximum number of hosts to create in the auto scaling group"
  type        = number
  default     = 3
}

variable "asg_min_healthy_percentage" {
  description = "The minimum percentage of healthy instances during an ASG refresh"
  type        = number
  default     = 100
  validation {
    condition = (
      (var.asg_min_healthy_percentage >= 0) &&
      (var.asg_min_healthy_percentage <= 100)
    )
    error_message = "The minimum healthy percentage must be between `0` and `100`"
  }
}

variable "custom_tags" {
  description = "Custom tags to be added to all AWS resources created"
  type        = map(any)
  default     = {}
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross zone load balancing"
  type        = bool
  default     = true
}

variable "health_check_grace_period" {
  description = "The minimum amount of time (in seconds) to keep a new instance in service before terminating it if it's found to be unhealthy"
  type        = number
  default     = 300
}

variable "instance_type" {
  description = "Amazon EC2 instance type for the sidecar instances"
  type        = string
  default     = "t3.medium"
}

variable "instance_metadata_token" {
  description = "Instance Metadata Service token requirement"
  type        = string
  default     = "required"

  validation {
    condition     = contains(["optional", "required"], var.instance_metadata_token)
    error_message = "Valid values for instance_metadata_token are (optional, required)"
  }
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

variable "launch_template_tags_resource_types" {
  description = "Set of resource types to be used to add custom tags to the launch template. See also `custom_tags`."
  type        = set(string)
  default     = ["instance", "volume", "network-interface"]
}

variable "load_balancer_security_groups" {
  description = <<EOF
List of the IDs of the additional security groups that will be attached to the load balancer.
Parameter has no effect in case `deploy_load_balancer = false`.
EOF
  type        = list(string)
  default     = []
}

variable "load_balancer_subnets" {
  description = <<EOF
Subnets to add load balancer to. If not provided, the load balancer will assume the subnets
specified in the `subnets` parameter.
Parameter has no effect in case `deploy_load_balancer = false`.
EOF
  type        = list(string)
  default     = []
}

variable "load_balancer_scheme" {
  description = <<EOF
EC2 network load balancer scheme (`internal` or `internet-facing`)
Parameter has no effect in case `deploy_load_balancer = false`.
EOF
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

variable "load_balancer_sticky_ports" {
  description = <<EOF
List of ports that will have session stickiness enabled.
This parameter must be a subset of 'sidecar_ports'.
EOF
  type        = list(number)
  default     = []
}

variable "volume_size" {
  description = "Size of the sidecar disk"
  type        = number
  default     = 15
}

variable "volume_type" {
  description = "Type of the sidecar disk"
  type        = string
  default     = "gp3"
}

variable "ssh_inbound_cidr" {
  description = "Allowed CIDR blocks for SSH access to the sidecar. Can't be combined with 'ssh_inbound_security_group'."
  type        = list(string)
}

variable "ssh_inbound_security_group" {
  description = "Pre-existing security group IDs allowed to ssh into the EC2 host. Can't be combined with 'ssh_inbound_cidr'."
  type        = list(string)
  default     = []
}

variable "db_inbound_cidr" {
  description = "Allowed CIDR blocks for database access to the sidecar. Can't be combined with 'db_inbound_security_group'."
  type        = list(string)
}

variable "reduce_security_group_rules_count" {
  description = "If set to `false`, each port in `sidecar_ports` will be used individually for each CIDR in `db_inbound_cidr` to create inbound rules in the sidecar security group, resulting in a number of inbound rules that is equal to the number of `sidecar_ports` * `db_inbound_cidr`. If set to `true`, the entire sidecar port range from `min(sidecar_ports)` to `max(sidecar_ports)` will be used to configure each inbound rule for each CIDR in `db_inbound_cidr` for the sidecar security group. Setting it to `true` can be useful if you need to use multiple sequential sidecar ports and different CIDRs for DB inbound (`db_inbound_cidr`) since it will significantly reduce the number of inbound rules and avoid hitting AWS quotas. As a side effect, it will open all the ports between `min(sidecar_ports)` and `max(sidecar_ports)` in the security group created by this module."
  type        = bool
  default     = false
}

variable "db_inbound_security_group" {
  description = "Pre-existing security group IDs allowed to connect to db in the EC2 host. Can't be combined with 'db_inbound_cidr'."
  type        = list(string)
  default     = []
}

variable "monitoring_inbound_cidr" {
  description = "Allowed CIDR blocks for health check and metric requests to the sidecar. If restricting the access, consider setting to the VPC CIDR or an equivalent to cover the assigned subnets as the load balancer performs health checks on the EC2 instances."
  type        = list(string)
}

variable "deploy_load_balancer" {
  description = "Deploy or not the load balancer and target groups. This option makes the ASG have only one replica, irrelevant of the Asg Min Max and Desired"
  type        = bool
  default     = true
}

variable "secret_arn" {
  description = "Full ARN of the AWS Secrets Manager secret used to store the sidecar secrets. If unset, sidecar will manage its own secret. See the topic `Bring Your Own Secret` in the `Advanced` documentation section."
  type        = string
  default     = ""
}

variable "secret_role_arn" {
  description = "(Optional) ARN of an AWS IAM Role to assume when reading the secret informed in `secret_arn`."
  type        = string
  default     = ""
}

variable "secrets_kms_arn" {
  description = "ARN of the KMS key used to encrypt/decrypt secrets. If unset, secrets will use the default KMS key."
  type        = string
  default     = ""
}

variable "ec2_ebs_kms_arn" {
  description = "ARN of the KMS key used to encrypt/decrypt EBS volumes. If unset, EBS will use the default KMS key. Make sure the KMS key allows the principal `arn:aws:iam::ACCOUNT_NUMBER:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling`, otherwise the ASG will not be able to launch the new instances."
  type        = string
  default     = ""
}

variable "associate_public_ip_address" {
  description = "Associates a public IP to sidecar EC2 instances"
  type        = bool
  default     = false
}

variable "additional_security_groups" {
  description = <<EOF
List of the IDs of the additional security groups that will be attached to the sidecar instances. If providing
`additional_target_groups`, use this parameter to provide security groups with the inbound rules to allow
inbound traffic from the target groups to the instances.
EOF
  type        = list(string)
  default     = []
}

variable "additional_target_groups" {
  description = <<EOF
List of the ARNs of the additional target groups that will be attached to the sidecar instances. Use it in
conjunction with `additional_security_groups` to provide the inbound rules for the ports associated with 
them, otherwise the incoming traffic from the target groups will not be allowed to access the EC2 instances.
EOF
  type        = list(string)
  default     = []
}

variable "cloudwatch_logs_retention" {
  description = "Cloudwatch logs retention in days"
  type        = number
  default     = 14
  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.cloudwatch_logs_retention)
    error_message = "Valid values are: [1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]."
  }
}
