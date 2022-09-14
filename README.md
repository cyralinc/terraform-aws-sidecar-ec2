# Cyral Sidecar AWS module for Terraform

## Usage

### Regular configuration
```hcl
module "cyral_sidecar" {
    source  = "cyralinc/sidecar-ec2/aws"  
    version = "~> 3.0" # terraform module version

    sidecar_version = ""
    sidecar_id      = ""

    control_plane = ""

    sidecar_ports = [443, 3306, 5432]
    mongodb_port_alloc_range_low  = 27017
    mongodb_port_alloc_range_high = 27019

    vpc_id  = ""
    subnets = [""]

    ssh_inbound_cidr         = ["0.0.0.0/0"]
    db_inbound_cidr          = ["0.0.0.0/0"]
    healthcheck_inbound_cidr = ["0.0.0.0/0"]

    container_registry = ""
    client_id          = ""
    client_secret      = ""
}
```
### MongoDB configuration with replica set
```hcl
module "cyral_sidecar" {
    source  = "cyralinc/sidecar-ec2/aws"  
    version = "~> 3.0" # terraform module version

    sidecar_version = ""
    sidecar_id      = ""

    control_plane = ""

    sidecar_ports = [443, 3306, 5432, 27017, 27018, 27019, 27020, 27021]
    mongodb_port_alloc_range_low  = 27017
    mongodb_port_alloc_range_high = 27021

    vpc_id  = ""
    subnets = [""]

    ssh_inbound_cidr         = ["0.0.0.0/0"]
    db_inbound_cidr          = ["0.0.0.0/0"]
    healthcheck_inbound_cidr = ["0.0.0.0/0"]

    container_registry = ""
    client_id          = ""
    client_secret      = ""
}
```
**Note:**

- `name_prefix` is defined automatically. If you wish to define a custom
  `name_prefix`, please keep in mind that its length must be **at most 24
  characters**.

## Upgrade Notes

Check the [upgrade notes](docs/upgrade-notes.md) section if you are upgrading an existing sidecar.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.73.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.cyral-sidecar-asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.cyral-sidecar-lg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_instance_profile.sidecar_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.init_script_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.sidecar_custom_certificate_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.sidecar_custom_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.sidecar_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.init_script_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.sidecar_custom_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.user_policies](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_configuration.cyral-sidecar-lc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.cyral-lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.cyral-sidecar-lb-ls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.cyral-sidecar-tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.cyral-sidecar-dns-record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_secretsmanager_secret.cyral-sidecar-secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.sidecar_created_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret.sidecar_custom_certificate](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.cyral-sidecar-secret-version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [aws_security_group.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon_linux_2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_arn.cw_lg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/arn) | data source |
| [aws_availability_zones.all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_iam_policy_document.init_script_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sidecar](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sidecar_custom_certificate_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.sidecar_custom_certificate_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_security_groups"></a> [additional\_security\_groups](#input\_additional\_security\_groups) | Additional security groups to attach to sidecar instances | `list(string)` | `[]` | no |
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | Amazon Linux 2 AMI ID for sidecar EC2 instances. The default behavior is to use the latest version.<br>In order to define a new image, provide the desired image id. | `string` | `""` | no |
| <a name="input_asg_count"></a> [asg\_count](#input\_asg\_count) | Set to 1 to enable the ASG, 0 to disable. Only for debugging. | `number` | `1` | no |
| <a name="input_asg_desired"></a> [asg\_desired](#input\_asg\_desired) | The desired number of hosts to create in the auto scaling group | `number` | `1` | no |
| <a name="input_asg_max"></a> [asg\_max](#input\_asg\_max) | The maximum number of hosts to create in the auto scaling group | `number` | `2` | no |
| <a name="input_asg_min"></a> [asg\_min](#input\_asg\_min) | The minimum number of hosts to create in the auto scaling group | `number` | `1` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Associates a public IP to sidecar EC2 instances | `bool` | `false` | no |
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | The client id assigned to the sidecar | `string` | n/a | yes |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | The client secret assigned to the sidecar | `string` | n/a | yes |
| <a name="input_cloudwatch_logs_retention"></a> [cloudwatch\_logs\_retention](#input\_cloudwatch\_logs\_retention) | Cloudwatch logs retention in days | `number` | `14` | no |
| <a name="input_container_registry"></a> [container\_registry](#input\_container\_registry) | Address of the container registry where Cyral images are stored | `string` | n/a | yes |
| <a name="input_container_registry_key"></a> [container\_registry\_key](#input\_container\_registry\_key) | Key provided by Cyral for authenticating on Cyral's container registry | `string` | `""` | no |
| <a name="input_container_registry_username"></a> [container\_registry\_username](#input\_container\_registry\_username) | Username provided by Cyral for authenticating on Cyral's container registry | `string` | `""` | no |
| <a name="input_control_plane"></a> [control\_plane](#input\_control\_plane) | Address of the control plane - <tenant>.cyral.com | `string` | n/a | yes |
| <a name="input_custom_user_data"></a> [custom\_user\_data](#input\_custom\_user\_data) | Ancillary consumer supplied user-data script. Bash scripts must be added to a map as a value of the key `pre` and/or `post` denoting execution order with respect to sidecar installation. (Approx Input Size = 19KB) | `map(any)` | <pre>{<br>  "post": "",<br>  "pre": ""<br>}</pre> | no |
| <a name="input_db_inbound_cidr"></a> [db\_inbound\_cidr](#input\_db\_inbound\_cidr) | Allowed CIDR block for database access to the sidecar. Can't be combined with 'db\_inbound\_security\_group'. | `list(string)` | n/a | yes |
| <a name="input_db_inbound_security_group"></a> [db\_inbound\_security\_group](#input\_db\_inbound\_security\_group) | Pre-existing security group IDs allowed to connect to db in the EC2 host. Can't be combined with 'db\_inbound\_cidr'. | `list(string)` | `[]` | no |
| <a name="input_dd_api_key"></a> [dd\_api\_key](#input\_dd\_api\_key) | API key to connect to DataDog | `string` | `""` | no |
| <a name="input_deploy_secrets"></a> [deploy\_secrets](#input\_deploy\_secrets) | Create the AWS Secrets Manager resource at secret\_location using client\_id, client\_secret and container\_registry\_key | `bool` | `true` | no |
| <a name="input_elk_address"></a> [elk\_address](#input\_elk\_address) | Address to ship logs to ELK | `string` | `""` | no |
| <a name="input_elk_password"></a> [elk\_password](#input\_elk\_password) | (Optional) Password to use to ship logs to ELK | `string` | `""` | no |
| <a name="input_elk_username"></a> [elk\_username](#input\_elk\_username) | (Optional) Username to use to ship logs to ELK | `string` | `""` | no |
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Enable cross zone load balancing | `bool` | `true` | no |
| <a name="input_external_tls_type"></a> [external\_tls\_type](#input\_external\_tls\_type) | TLS mode for the control plane - tls, tls-skip-verify, no-tls | `string` | `"tls"` | no |
| <a name="input_hc_vault_integration_id"></a> [hc\_vault\_integration\_id](#input\_hc\_vault\_integration\_id) | HashiCorp Vault integration ID | `string` | `""` | no |
| <a name="input_health_check_grace_period"></a> [health\_check\_grace\_period](#input\_health\_check\_grace\_period) | The grace period in seconds before the health check will terminate the instance | `number` | `600` | no |
| <a name="input_healthcheck_inbound_cidr"></a> [healthcheck\_inbound\_cidr](#input\_healthcheck\_inbound\_cidr) | Allowed CIDR block for health check requests to the sidecar | `list(string)` | n/a | yes |
| <a name="input_healthcheck_port"></a> [healthcheck\_port](#input\_healthcheck\_port) | Port used for the healthcheck | `number` | `8888` | no |
| <a name="input_iam_policies"></a> [iam\_policies](#input\_iam\_policies) | (Optional) List of IAM policies ARNs that will be attached to the sidecar IAM role | `list(string)` | `[]` | no |
| <a name="input_idp_certificate"></a> [idp\_certificate](#input\_idp\_certificate) | (Optional) The certificate used to verify SAML assertions from the IdP being used with Snowflake. Enter this value as a one-line string with literal <br> characters specifying the line breaks. | `string` | `""` | no |
| <a name="input_idp_sso_login_url"></a> [idp\_sso\_login\_url](#input\_idp\_sso\_login\_url) | (Optional) The IdP SSO URL for the IdP being used with Snowflake. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Amazon EC2 instance type for the sidecar instances | `string` | `"t3.medium"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | AWS key name | `string` | `""` | no |
| <a name="input_load_balancer_certificate_arn"></a> [load\_balancer\_certificate\_arn](#input\_load\_balancer\_certificate\_arn) | (Optional) ARN of SSL certificate that will be used for client connections to Snowflake. | `string` | `""` | no |
| <a name="input_load_balancer_scheme"></a> [load\_balancer\_scheme](#input\_load\_balancer\_scheme) | EC2 network load balancer scheme ('internal' or 'internet-facing') | `string` | `"internal"` | no |
| <a name="input_load_balancer_sticky_ports"></a> [load\_balancer\_sticky\_ports](#input\_load\_balancer\_sticky\_ports) | List of ports that will have session stickiness enabled.<br>This parameter must be a subset of 'sidecar\_ports'. | `list(number)` | `[]` | no |
| <a name="input_load_balancer_subnets"></a> [load\_balancer\_subnets](#input\_load\_balancer\_subnets) | Subnets to add load balancer to. If not provided, the load balancer will assume the subnets specified in the `subnets` parameter. | `list(string)` | `[]` | no |
| <a name="input_load_balancer_tls_ports"></a> [load\_balancer\_tls\_ports](#input\_load\_balancer\_tls\_ports) | List of ports that will have TLS terminated at load balancer level<br>(snowflake support, for example). If assigned, 'load\_balancer\_certificate\_arn' <br>must also be provided. This parameter must be a subset of 'sidecar\_ports'. | `list(number)` | `[]` | no |
| <a name="input_log_integration"></a> [log\_integration](#input\_log\_integration) | Logs destination | `string` | `"cloudwatch"` | no |
| <a name="input_metrics_integration"></a> [metrics\_integration](#input\_metrics\_integration) | Metrics destination | `string` | `""` | no |
| <a name="input_mongodb_port_alloc_range_high"></a> [mongodb\_port\_alloc\_range\_high](#input\_mongodb\_port\_alloc\_range\_high) | Final value for MongoDB port allocation range. The consecutive ports in the<br>range `mongodb_port_alloc_range_low:mongodb_port_alloc_range_high` will be used<br>for mongodb cluster monitoring. All the ports in this range must be listed in<br>`sidecar_ports`. | `number` | `27019` | no |
| <a name="input_mongodb_port_alloc_range_low"></a> [mongodb\_port\_alloc\_range\_low](#input\_mongodb\_port\_alloc\_range\_low) | Initial value for MongoDB port allocation range. The consecutive ports in the<br>range `mongodb_port_alloc_range_low:mongodb_port_alloc_range_high` will be used<br>for mongodb cluster monitoring. All the ports in this range must be listed in<br>`sidecar_ports`. | `number` | `27017` | no |
| <a name="input_mysql_multiplexed_port"></a> [mysql\_multiplexed\_port](#input\_mysql\_multiplexed\_port) | Port that will be used by the sidecar to multiplex connections to MySQL | `number` | `0` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for names of created resources in AWS. Maximum length is 24 characters. | `string` | `""` | no |
| <a name="input_reduce_security_group_rules_count"></a> [reduce\_security\_group\_rules\_count](#input\_reduce\_security\_group\_rules\_count) | If set to `false`, each port in `sidecar_ports` will be used individually for each CIDR in `db_inbound_cidr` to create inbound rules in the sidecar security group, resulting in a number of inbound rules that is equal to the number of `sidecar_ports` * `db_inbound_cidr`. If set to `true`, the entire sidecar port range from `min(sidecar_ports)` to `max(sidecar_ports)` will be used to configure each inbound rule for each CIDR in `db_inbound_cidr` for the sidecar security group. Setting it to `true` can be useful if you need to use multiple sequential sidecar ports and different CIDRs for DB inbound (`db_inbound_cidr`) since it will significantly reduce the number of inbound rules and avoid hitting AWS quotas. As a side effect, it will open all the ports between `min(sidecar_ports)` and `max(sidecar_ports)` in the security group created by this module. | `bool` | `false` | no |
| <a name="input_repositories_supported"></a> [repositories\_supported](#input\_repositories\_supported) | List of all repositories that will be supported by the sidecar (lower case only) | `list(string)` | <pre>[<br>  "denodo",<br>  "dremio",<br>  "dynamodb",<br>  "mongodb",<br>  "mysql",<br>  "oracle",<br>  "postgresql",<br>  "redshift",<br>  "rest",<br>  "snowflake",<br>  "sqlserver",<br>  "s3"<br>]</pre> | no |
| <a name="input_secrets_kms_key_id"></a> [secrets\_kms\_key\_id](#input\_secrets\_kms\_key\_id) | ARN of the KMS key used to encrypt secrets. If not set, secrets will use the default KMS key. | `string` | `""` | no |
| <a name="input_secrets_location"></a> [secrets\_location](#input\_secrets\_location) | Location in AWS Secrets Manager to store client\_id, client\_secret and container\_registry\_key | `string` | n/a | yes |
| <a name="input_sidecar_custom_certificate_account_id"></a> [sidecar\_custom\_certificate\_account\_id](#input\_sidecar\_custom\_certificate\_account\_id) | (Optional) AWS Account ID where the custom certificate module will be deployed. | `string` | `""` | no |
| <a name="input_sidecar_dns_hosted_zone_id"></a> [sidecar\_dns\_hosted\_zone\_id](#input\_sidecar\_dns\_hosted\_zone\_id) | (Optional) Route53 hosted zone ID for the corresponding 'sidecar\_dns\_name' provided | `string` | `""` | no |
| <a name="input_sidecar_dns_name"></a> [sidecar\_dns\_name](#input\_sidecar\_dns\_name) | (Optional) Fully qualified domain name that will be automatically created/updated to reference the sidecar LB | `string` | `""` | no |
| <a name="input_sidecar_dns_overwrite"></a> [sidecar\_dns\_overwrite](#input\_sidecar\_dns\_overwrite) | (Optional) Update an existing DNS name informed in 'sidecar\_dns\_name' variable | `bool` | `false` | no |
| <a name="input_sidecar_id"></a> [sidecar\_id](#input\_sidecar\_id) | Sidecar identifier | `string` | n/a | yes |
| <a name="input_sidecar_ports"></a> [sidecar\_ports](#input\_sidecar\_ports) | List of ports allowed to connect to the sidecar. See also 'load\_balancer\_tls\_ports'. | `list(number)` | n/a | yes |
| <a name="input_sidecar_version"></a> [sidecar\_version](#input\_sidecar\_version) | Version of the sidecar | `string` | n/a | yes |
| <a name="input_splunk_host"></a> [splunk\_host](#input\_splunk\_host) | Splunk host | `string` | `""` | no |
| <a name="input_splunk_index"></a> [splunk\_index](#input\_splunk\_index) | Splunk index | `string` | `""` | no |
| <a name="input_splunk_port"></a> [splunk\_port](#input\_splunk\_port) | Splunk port | `number` | `0` | no |
| <a name="input_splunk_tls"></a> [splunk\_tls](#input\_splunk\_tls) | Splunk TLS | `bool` | `false` | no |
| <a name="input_splunk_token"></a> [splunk\_token](#input\_splunk\_token) | Splunk token | `string` | `""` | no |
| <a name="input_ssh_inbound_cidr"></a> [ssh\_inbound\_cidr](#input\_ssh\_inbound\_cidr) | Allowed CIDR block for SSH access to the sidecar. Can't be combined with 'ssh\_inbound\_security\_group'. | `list(string)` | n/a | yes |
| <a name="input_ssh_inbound_security_group"></a> [ssh\_inbound\_security\_group](#input\_ssh\_inbound\_security\_group) | Pre-existing security group IDs allowed to ssh into the EC2 host. Can't be combined with 'ssh\_inbound\_cidr'. | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to add sidecar to (list of string) | `list(string)` | n/a | yes |
| <a name="input_sumologic_host"></a> [sumologic\_host](#input\_sumologic\_host) | Sumologic host | `string` | `""` | no |
| <a name="input_sumologic_uri"></a> [sumologic\_uri](#input\_sumologic\_uri) | Sumologic uri | `string` | `""` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Size of the sidecar disk | `number` | `15` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | AWS VPC ID to deploy sidecar to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#output\_aws\_iam\_role\_arn) | Sidecar IAM role ARN |
| <a name="output_aws_security_group_id"></a> [aws\_security\_group\_id](#output\_aws\_security\_group\_id) | Sidecar security group id |
| <a name="output_sidecar_custom_certificate_role_arn"></a> [sidecar\_custom\_certificate\_role\_arn](#output\_sidecar\_custom\_certificate\_role\_arn) | IAM role ARN to use in the Sidecar Custom Certificate modules. |
| <a name="output_sidecar_custom_certificate_secret_arn"></a> [sidecar\_custom\_certificate\_secret\_arn](#output\_sidecar\_custom\_certificate\_secret\_arn) | Secret ARN to use in the Sidecar Custom Certificate modules. |
| <a name="output_sidecar_dns"></a> [sidecar\_dns](#output\_sidecar\_dns) | Sidecar DNS endpoint |
| <a name="output_sidecar_load_balancer_dns"></a> [sidecar\_load\_balancer\_dns](#output\_sidecar\_load\_balancer\_dns) | Sidecar load balancer DNS endpoint |