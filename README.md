# Cyral sidecar module for AWS EC2

Use this Terraform module to deploy a sidecar on AWS EC2 instances.

Refer to the [quickstart guide](https://github.com/cyral-quickstart/quickstart-sidecar-terraform-aws-ec2#readme)
for more information on how to use this module or upgrade your sidecar.

## Architecture

![Deployment architecture](https://raw.githubusercontent.com/cyralinc/terraform-aws-sidecar-ec2/main/images/aws_architecture.png)

The elements shown in the architecture diagram above are deployed by this module.
The module requires existing VPC and subnets in order to create the necessary
components for the sidecar to run. In a high-level, these are the resources deployed:

* EC2
    * Auto scaling group (responsible for managing EC2 instances and EBS volumes)
    * Network load balancer (optional)
    * Security group
* Secrets Manager
    * Sidecar credentials
    * Sidecar CA certificate
    * Sidecar self-signed certificate
* IAM
    * Sidecar role
* Cloudwatch
    * Log group (optional)

## Usage

```hcl
provider "aws" {
  # Define the target AWS region
  region = "us-east-1"
}

module "cyral_sidecar" {
  source  = "cyralinc/sidecar-ec2/aws"  
  version = "~> 4.0" # terraform module version

  sidecar_id      = ""
  control_plane   = ""
  client_id          = ""
  client_secret      = ""
  
  # Leave empty if you prefer to perform upgrades directly
  # from the control plane.
  sidecar_version = ""

  # Considering MongoDB ports are from the range 27017 to 27019
  sidecar_ports = [443, 3306, 5432, 27017, 27018, 27019]

  vpc_id  = ""
  subnets = [""]

  # Inbound CIDR to SSH into the EC2 instances
  ssh_inbound_cidr        = ["0.0.0.0/0"]
  # Inbound CIDR to access ports defined in `sidecar_ports`
  db_inbound_cidr         = ["0.0.0.0/0"]
  # Inbound CIDR to monitor the EC2 instances (port 9000)
  monitoring_inbound_cidr = ["0.0.0.0/0"]
}
```
**Note:**

- `name_prefix` is defined automatically. If you wish to define a custom
  `name_prefix`, please keep in mind that its length must be **at most 24
  characters**.

## Upgrade

This module supports [1-click upgrade](https://cyral.com/docs/sidecars/manage/upgrade#1-click-upgrade).

To enable the 1-click upgrade feature, leave the variable `sidecar_version` empty and upgrade
the sidecar from Cyral control plane.

If you prefer to block upgrades from the Cyral control plane and use a **static version**, assign
the desired sidecar version to `sidecar_version`. To upgrade your sidecar, update this parameter
with the target version and run `terraform apply`.

Learn more in the [sidecar upgrade procedures](https://cyral.com/docs/sidecars/manage/upgrade) page.

See also the module's [upgrade notes](https://github.com/cyralinc/terraform-aws-sidecar-ec2/blob/main/docs/upgrade-notes.md) for specific
instructions on how to upgrade this module from previous major versions.

## Advanced

Instructions for advanced deployment configurations are available for the following topics:

* [Advanced networking configuration](https://github.com/cyralinc/terraform-aws-sidecar-ec2/blob/main/docs/networking.md)
* [Enable the S3 File Browser](https://github.com/cyralinc/terraform-aws-sidecar-ec2/blob/main/docs/s3-browser.md)
* [Memory limits](https://github.com/cyralinc/terraform-aws-sidecar-ec2/blob/main/docs/memlim.md)
* [Sidecar certificates](https://github.com/cyralinc/terraform-aws-sidecar-ec2/blob/main/docs/certificates.md)
* [Sidecar instance metrics](https://github.com/cyralinc/terraform-aws-sidecar-ec2/blob/main/docs/metrics.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73.0, < 6.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.73.0, < 6.0.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.lg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_instance_profile.sidecar_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.init_script_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sidecar_custom_certificate_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.self_signed_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sidecar_custom_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sidecar_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.init_script_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sidecar_custom_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.user_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.self_signed_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.self_signed_ca_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_invocation.self_signed_tls_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_launch_template.lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.ls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.cyral-sidecar-dns-record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.custom_tls_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.self_signed_ca](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.self_signed_tls_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.sidecar_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.self_signed_ca](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.self_signed_tls_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_secretsmanager_secret_version.sidecar_secrets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [tls_private_key.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_private_key.tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.ca](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [tls_self_signed_cert.tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_arn.cw_lg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_availability_zones.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.init_script_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sidecar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sidecar_custom_certificate_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sidecar_custom_certificate_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_lbs.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lbs) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_groups"></a> [additional\_security\_groups](#input\_additional\_security\_groups) | List of the IDs of the additional security groups that will be attached to the sidecar instances. If providing<br>`additional_target_groups`, use this parameter to provide security groups with the inbound rules to allow<br>inbound traffic from the target groups to the instances. | `list(string)` | `[]` | no |
| <a name="input_additional_target_groups"></a> [additional\_target\_groups](#input\_additional\_target\_groups) | List of the ARNs of the additional target groups that will be attached to the sidecar instances. Use it in<br>conjunction with `additional_security_groups` to provide the inbound rules for the ports associated with <br>them, otherwise the incoming traffic from the target groups will not be allowed to access the EC2 instances. | `list(string)` | `[]` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | Amazon Linux 2 AMI ID for sidecar EC2 instances. The default behavior is to use the latest version.<br>In order to define a new image, provide the desired image id. | `string` | `""` | no |
| <a name="input_asg_count"></a> [asg\_count](#input\_asg\_count) | (Deprecated) Set to 1 to enable the ASG, 0 to disable. Only for debugging. | `number` | `1` | no |
| <a name="input_asg_desired"></a> [asg\_desired](#input\_asg\_desired) | The desired number of hosts to create in the auto scaling group | `number` | `1` | no |
| <a name="input_asg_max"></a> [asg\_max](#input\_asg\_max) | The maximum number of hosts to create in the auto scaling group | `number` | `3` | no |
| <a name="input_asg_min"></a> [asg\_min](#input\_asg\_min) | The minimum number of hosts to create in the auto scaling group | `number` | `1` | no |
| <a name="input_asg_min_healthy_percentage"></a> [asg\_min\_healthy\_percentage](#input\_asg\_min\_healthy\_percentage) | The minimum percentage of healthy instances during an ASG refresh | `number` | `100` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associates a public IP to sidecar EC2 instances | `bool` | `false` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The client id assigned to the sidecar | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | The client secret assigned to the sidecar | `string` | n/a | yes |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | (Optional) Cloudwatch log group name. | `string` | `""` | no |
| <a name="input_cloudwatch_logs_retention"></a> [cloudwatch\_logs\_retention](#input\_cloudwatch\_logs\_retention) | Cloudwatch logs retention in days | `number` | `14` | no |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | Address of the container registry where Cyral images are stored. | `string` | `"public.ecr.aws/cyral"` | no |
| <a name="input_container_registry_key"></a> [container\_registry\_key](#input\_container\_registry\_key) | Corresponding key for the user name provided to authenticate to the container registry. | `string` | `""` | no |
| <a name="input_container_registry_username"></a> [container\_registry\_username](#input\_container\_registry\_username) | Username to authenticate to the container registry. | `string` | `""` | no |
| <a name="input_control_plane"></a> [control\_plane](#input\_control\_plane) | Address of the control plane - <tenant>.cyral.com | `string` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags to be added to all AWS resources created | `map(any)` | `{}` | no |
| <a name="input_custom_user_data"></a> [custom\_user\_data](#input\_custom\_user\_data) | Ancillary consumer supplied user-data script. Bash scripts must be added to a map as a value of the key `pre`, `pre_sidecar_start`, `post` denoting execution order with respect to sidecar installation. (Approx Input Size = 19KB) | `map(any)` | <pre>{<br>  "post": "",<br>  "pre": "",<br>  "pre_sidecar_start": ""<br>}</pre> | no |
| <a name="input_db_inbound_cidr"></a> [db\_inbound\_cidr](#input\_db\_inbound\_cidr) | Allowed CIDR blocks for database access to the sidecar. Can't be combined with 'db\_inbound\_security\_group'. | `list(string)` | n/a | yes |
| <a name="input_db_inbound_security_group"></a> [db\_inbound\_security\_group](#input\_db\_inbound\_security\_group) | Pre-existing security group IDs allowed to connect to db in the EC2 host. Can't be combined with 'db\_inbound\_cidr'. | `list(string)` | `[]` | no |
| <a name="input_dd_api_key"></a> [dd\_api\_key](#input\_dd\_api\_key) | (Deprecated - unused in sidecars v4.10+) API key to connect to DataDog | `string` | `""` | no |
| <a name="input_deploy_certificate_lambda"></a> [deploy\_certificate\_lambda](#input\_deploy\_certificate\_lambda) | This is used to tell if the TLS provider should be used or if default certificates should be created by a lambda. | `bool` | `true` | no |
| <a name="input_deploy_load_balancer"></a> [deploy\_load\_balancer](#input\_deploy\_load\_balancer) | Deploy or not the load balancer and target groups. This option makes the ASG have only one replica, irrelevant of the Asg Min Max and Desired | `bool` | `true` | no |
| <a name="input_deploy_secrets"></a> [deploy\_secrets](#input\_deploy\_secrets) | Create the AWS Secrets Manager resource at `secret_location` storing `client_id`, `client_secret` and `container_registry_key`. | `bool` | `true` | no |
| <a name="input_ec2_ebs_kms_arn"></a> [ec2\_ebs\_kms\_arn](#input\_ec2\_ebs\_kms\_arn) | ARN of the KMS key used to encrypt/decrypt EBS volumes. If unset, EBS will use the default KMS key. Make sure the KMS key allows the principal `arn:aws:iam::ACCOUNT_NUMBER:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling`, otherwise the ASG will not be able to launch the new instances. | `string` | `""` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Enable cross zone load balancing | `bool` | `true` | no |
| <a name="input_hc_vault_integration_id"></a> [hc\_vault\_integration\_id](#input\_hc\_vault\_integration\_id) | (Deprecated - unused in sidecars v4.10+) HashiCorp Vault integration ID | `string` | `""` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | The grace period in seconds before the health check will terminate the instance | `number` | `600` | no |
| <a name="input_iam_policies"></a> [iam\_policies](#input\_iam\_policies) | (Optional) List of IAM policies ARNs that will be attached to the sidecar IAM role | `list(string)` | `[]` | no |
| <a name="input_idp_certificate"></a> [idp\_certificate](#input\_idp\_certificate) | (Optional) The certificate used to verify SAML assertions from the IdP being used with Snowflake. Enter this value as a one-line string with literal new line characters (\n) specifying the line breaks. | `string` | `""` | no |
| <a name="input_idp_sso_login_url"></a> [idp\_sso\_login\_url](#input\_idp\_sso\_login\_url) | (Optional) The IdP SSO URL for the IdP being used with Snowflake. | `string` | `""` | no |
| <a name="input_instance_metadata_token"></a> [instance\_metadata\_token](#input\_instance\_metadata\_token) | Instance Metadata Service token requirement | `string` | `"required"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Amazon EC2 instance type for the sidecar instances | `string` | `"t3.medium"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | AWS key name | `string` | `""` | no |
| <a name="input_load_balancer_certificate_arn"></a> [load\_balancer\_certificate\_arn](#input\_load\_balancer\_certificate\_arn) | (Optional) ARN of SSL certificate that will be used for client connections to Snowflake. | `string` | `""` | no |
| <a name="input_load_balancer_scheme"></a> [load\_balancer\_scheme](#input\_load\_balancer\_scheme) | EC2 network load balancer scheme (`internal` or `internet-facing`)<br>Parameter has no effect in case `deploy_load_balancer = false`. | `string` | `"internal"` | no |
| <a name="input_load_balancer_security_groups"></a> [load\_balancer\_security\_groups](#input\_load\_balancer\_security\_groups) | List of the IDs of the additional security groups that will be attached to the load balancer.<br>Parameter has no effect in case `deploy_load_balancer = false`. | `list(string)` | `[]` | no |
| <a name="input_load_balancer_sticky_ports"></a> [load\_balancer\_sticky\_ports](#input\_load\_balancer\_sticky\_ports) | List of ports that will have session stickiness enabled.<br>This parameter must be a subset of 'sidecar\_ports'. | `list(number)` | `[]` | no |
| <a name="input_load_balancer_subnets"></a> [load\_balancer\_subnets](#input\_load\_balancer\_subnets) | Subnets to add load balancer to. If not provided, the load balancer will assume the subnets<br>specified in the `subnets` parameter.<br>Parameter has no effect in case `deploy_load_balancer = false`. | `list(string)` | `[]` | no |
| <a name="input_load_balancer_tls_ports"></a> [load\_balancer\_tls\_ports](#input\_load\_balancer\_tls\_ports) | List of ports that will have TLS terminated at load balancer level<br>(snowflake support, for example). If assigned, 'load\_balancer\_certificate\_arn' <br>must also be provided. This parameter must be a subset of 'sidecar\_ports'. | `list(number)` | `[]` | no |
| <a name="input_log_integration"></a> [log\_integration](#input\_log\_integration) | Logs destination | `string` | `"cloudwatch"` | no |
| <a name="input_metrics_integration"></a> [metrics\_integration](#input\_metrics\_integration) | (Deprecated - unused in sidecars v4.10+) Metrics destination | `string` | `""` | no |
| <a name="input_monitoring_inbound_cidr"></a> [monitoring\_inbound\_cidr](#input\_monitoring\_inbound\_cidr) | Allowed CIDR blocks for health check and metric requests to the sidecar. If restricting the access, consider setting to the VPC CIDR or an equivalent to cover the assigned subnets as the load balancer performs health checks on the EC2 instances. | `list(string)` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for names of created resources in AWS. Maximum length is 24 characters. | `string` | `""` | no |
| <a name="input_recycle_health_check_interval_sec"></a> [recycle\_health\_check\_interval\_sec](#input\_recycle\_health\_check\_interval\_sec) | (Optional) The interval (in seconds) in which the sidecar instance checks whether it has been marked or recycling. | `number` | `30` | no |
| <a name="input_reduce_security_group_rules_count"></a> [reduce\_security\_group\_rules\_count](#input\_reduce\_security\_group\_rules\_count) | If set to `false`, each port in `sidecar_ports` will be used individually for each CIDR in `db_inbound_cidr` to create inbound rules in the sidecar security group, resulting in a number of inbound rules that is equal to the number of `sidecar_ports` * `db_inbound_cidr`. If set to `true`, the entire sidecar port range from `min(sidecar_ports)` to `max(sidecar_ports)` will be used to configure each inbound rule for each CIDR in `db_inbound_cidr` for the sidecar security group. Setting it to `true` can be useful if you need to use multiple sequential sidecar ports and different CIDRs for DB inbound (`db_inbound_cidr`) since it will significantly reduce the number of inbound rules and avoid hitting AWS quotas. As a side effect, it will open all the ports between `min(sidecar_ports)` and `max(sidecar_ports)` in the security group created by this module. | `bool` | `false` | no |
| <a name="input_repositories_supported"></a> [repositories\_supported](#input\_repositories\_supported) | (Deprecated - unused in sidecars v4.10+) List of all repositories that will be supported by the sidecar (lower case only) | `list(string)` | <pre>[<br>  "denodo",<br>  "dremio",<br>  "dynamodb",<br>  "mongodb",<br>  "mysql",<br>  "oracle",<br>  "postgresql",<br>  "redshift",<br>  "snowflake",<br>  "sqlserver",<br>  "s3"<br>]</pre> | no |
| <a name="input_secrets_kms_arn"></a> [secrets\_kms\_arn](#input\_secrets\_kms\_arn) | ARN of the KMS key used to encrypt/decrypt secrets. If unset, secrets will use the default KMS key. | `string` | `""` | no |
| <a name="input_secrets_location"></a> [secrets\_location](#input\_secrets\_location) | Location in AWS Secrets Manager to store `client_id`, `client_secret` and `container_registry_key`. If unset, will assume `/cyral/sidecars/<SIDECAR_ID>/secrets`. | `string` | `""` | no |
| <a name="input_sidecar_ca_certificate_role_arn"></a> [sidecar\_ca\_certificate\_role\_arn](#input\_sidecar\_ca\_certificate\_role\_arn) | (Optional) ARN of an AWS IAM Role to assume when reading the CA certificate. | `string` | `""` | no |
| <a name="input_sidecar_ca_certificate_secret_arn"></a> [sidecar\_ca\_certificate\_secret\_arn](#input\_sidecar\_ca\_certificate\_secret\_arn) | (Optional) ARN of secret in AWS Secrets Manager that contains a CA certificate to sign sidecar-generated certs. | `string` | `""` | no |
| <a name="input_sidecar_custom_certificate_account_id"></a> [sidecar\_custom\_certificate\_account\_id](#input\_sidecar\_custom\_certificate\_account\_id) | (Optional) AWS Account ID where the custom certificate module will be deployed. | `string` | `""` | no |
| <a name="input_sidecar_custom_host_role"></a> [sidecar\_custom\_host\_role](#input\_sidecar\_custom\_host\_role) | (Optional) Name of an AWS IAM Role to attach to the EC2 instance profile. | `string` | `""` | no |
| <a name="input_sidecar_dns_hosted_zone_id"></a> [sidecar\_dns\_hosted\_zone\_id](#input\_sidecar\_dns\_hosted\_zone\_id) | (Optional) Route53 hosted zone ID for the corresponding 'sidecar\_dns\_name' provided | `string` | `""` | no |
| <a name="input_sidecar_dns_name"></a> [sidecar\_dns\_name](#input\_sidecar\_dns\_name) | (Optional) Fully qualified domain name that will be automatically created/updated to reference the sidecar LB | `string` | `""` | no |
| <a name="input_sidecar_dns_overwrite"></a> [sidecar\_dns\_overwrite](#input\_sidecar\_dns\_overwrite) | (Optional) Update an existing DNS name informed in 'sidecar\_dns\_name' variable | `bool` | `false` | no |
| <a name="input_sidecar_id"></a> [sidecar\_id](#input\_sidecar\_id) | Sidecar identifier | `string` | n/a | yes |
| <a name="input_sidecar_ports"></a> [sidecar\_ports](#input\_sidecar\_ports) | List of ports allowed to connect to the sidecar through the load balancer and security group. The maximum number of ports is limited to Network Load Balancers quotas (listeners and target groups). See also 'load\_balancer\_tls\_ports'. Avoid port `9000` as it is reserved for instance monitoring. | `list(number)` | n/a | yes |
| <a name="input_sidecar_private_idp_key"></a> [sidecar\_private\_idp\_key](#input\_sidecar\_private\_idp\_key) | (Optional) The private key used to sign SAML Assertions generated by the sidecar. Enter this value as a one-line string with literal new line characters (<br>) specifying the line breaks. | `string` | `""` | no |
| <a name="input_sidecar_public_idp_certificate"></a> [sidecar\_public\_idp\_certificate](#input\_sidecar\_public\_idp\_certificate) | (Optional) The public certificate used to verify signatures for SAML Assertions generated by the sidecar. Enter this value as a one-line string with literal new line characters (<br>) specifying the line breaks. | `string` | `""` | no |
| <a name="input_sidecar_tls_certificate_role_arn"></a> [sidecar\_tls\_certificate\_role\_arn](#input\_sidecar\_tls\_certificate\_role\_arn) | (Optional) ARN of an AWS IAM Role to assume when reading the TLS certificate. | `string` | `""` | no |
| <a name="input_sidecar_tls_certificate_secret_arn"></a> [sidecar\_tls\_certificate\_secret\_arn](#input\_sidecar\_tls\_certificate\_secret\_arn) | (Optional) ARN of secret in AWS Secrets Manager that contains a certificate to terminate TLS connections. | `string` | `""` | no |
| <a name="input_sidecar_version"></a> [sidecar\_version](#input\_sidecar\_version) | (Optional, but required for Control Planes < v4.10) The version of the sidecar. If unset and the Control Plane version is >= v4.10, the sidecar version will be dynamically retrieved from the Control Plane, otherwise an error will occur and this value must be provided. | `string` | `""` | no |
| <a name="input_ssh_inbound_cidr"></a> [ssh\_inbound\_cidr](#input\_ssh\_inbound\_cidr) | Allowed CIDR blocks for SSH access to the sidecar. Can't be combined with 'ssh\_inbound\_security\_group'. | `list(string)` | n/a | yes |
| <a name="input_ssh_inbound_security_group"></a> [ssh\_inbound\_security\_group](#input\_ssh\_inbound\_security\_group) | Pre-existing security group IDs allowed to ssh into the EC2 host. Can't be combined with 'ssh\_inbound\_cidr'. | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to add sidecar to (list of string) | `list(string)` | n/a | yes |
| <a name="input_tls_skip_verify"></a> [tls\_skip\_verify](#input\_tls\_skip\_verify) | (Optional) Skip TLS verification for HTTPS communication with the control plane and during sidecar initialization | `bool` | `false` | no |
| <a name="input_use_single_container"></a> [use\_single\_container](#input\_use\_single\_container) | (Optional) Use single container for sidecar deployment | `bool` | `false` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the sidecar disk | `number` | `15` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | Type of the sidecar disk | `string` | `"gp2"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | AWS VPC ID to deploy sidecar to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_autoscaling_group_arn"></a> [autoscaling\_group\_arn](#output\_autoscaling\_group\_arn) | Auto scaling group ARN |
| <a name="output_aws_cloudwatch_log_group_name"></a> [aws\_cloudwatch\_log\_group\_name](#output\_aws\_cloudwatch\_log\_group\_name) | Name of the CloudWatch log group where sidecar logs are stored |
| <a name="output_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#output\_aws\_iam\_role\_arn) | Sidecar IAM role ARN |
| <a name="output_aws_security_group_id"></a> [aws\_security\_group\_id](#output\_aws\_security\_group\_id) | Sidecar security group id |
| <a name="output_custom_tls_certificate_secret_arn"></a> [custom\_tls\_certificate\_secret\_arn](#output\_custom\_tls\_certificate\_secret\_arn) | Sidecar custom certificate secret ARN |
| <a name="output_launch_template_arn"></a> [launch\_template\_arn](#output\_launch\_template\_arn) | Launch template ARN |
| <a name="output_load_balancer_arn"></a> [load\_balancer\_arn](#output\_load\_balancer\_arn) | Load balancer ARN |
| <a name="output_self_signed_ca_cert_secret_arn"></a> [self\_signed\_ca\_cert\_secret\_arn](#output\_self\_signed\_ca\_cert\_secret\_arn) | Sidecar self signed CA certificate secret ARN |
| <a name="output_self_signed_tls_cert_secret_arn"></a> [self\_signed\_tls\_cert\_secret\_arn](#output\_self\_signed\_tls\_cert\_secret\_arn) | Sidecar self signed TLS certificate secret ARN |
| <a name="output_sidecar_credentials_secret_arn"></a> [sidecar\_credentials\_secret\_arn](#output\_sidecar\_credentials\_secret\_arn) | Sidecar secret ARN |
| <a name="output_sidecar_custom_certificate_role_arn"></a> [sidecar\_custom\_certificate\_role\_arn](#output\_sidecar\_custom\_certificate\_role\_arn) | IAM role ARN to use in the Sidecar Custom Certificate modules |
| <a name="output_sidecar_custom_certificate_secret_arn"></a> [sidecar\_custom\_certificate\_secret\_arn](#output\_sidecar\_custom\_certificate\_secret\_arn) | Secret ARN to use in the Sidecar Custom Certificate modules |
| <a name="output_sidecar_dns"></a> [sidecar\_dns](#output\_sidecar\_dns) | Sidecar DNS endpoint |
| <a name="output_sidecar_load_balancer_dns"></a> [sidecar\_load\_balancer\_dns](#output\_sidecar\_load\_balancer\_dns) | Sidecar load balancer DNS endpoint |
<!-- END_TF_DOCS -->