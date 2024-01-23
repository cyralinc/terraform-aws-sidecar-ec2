## 4.4.1 (January 23, 2024)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Bug fixes:

* Rollback certificate lambda ([#98](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/98))

## 4.4.0 (January 10, 2024)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Bug fixes:

* ENG-13220: Replaces Lambda by TLS provider ([#94](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/94))
* ENG:13220: Optionally create TLS resources ([#95](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/95))

## 4.3.3 (December 18, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Bug fixes:

* Fix var name ([#93](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/93))

## 4.3.2 (December 18, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Documentation:

* Fix broken links in registry docs ([#92](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/92))

### Enhancements:

* ENG-12832: Making load_certs echo Warning ([#90](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/90))

## 4.3.1 (November 17, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Bug fixes:

* ENG-13003: Updating single container scripts ([#91](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/91))

## 4.3.0 (October 5, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Features:

* ENG-12268: Make container registry info optional ([#79](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/79))
* ENG-11596: Deprecate unused variables in sidecar v4.10 ([#80](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/80))
* ENG-12509: Add parameter to use single container sidecar ([#81](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/81))
* ENG-12118/ENG-12121: Enable instance recycle and dynamically manage sidecar version ([#82](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/82))
* ENG-12120: Add custom EC2 health check script ([#83](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/83))
* Remove unused env vars ([#84](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/84))
* Set default value for `secrets_location` ([#86](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/86))
* ENG-12285: Export values in launch template for forward-compatibility ([#87](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/87))

## 4.2.2 (September 19, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Bug fixes:

* ENG-12650: Fix Hostname for lambda invocation ([#85](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/85))

## 4.2.1 (August 8, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Bug fixes:

* fix: Remove need for zip hash code file ([#78](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/78))
* ENG-12327: Add consistency in case of `custom_user_data` variable does not contain all key
s ([#77](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/77))
* ENG-12303: Refactor signed certificate lambda to be generated via pre-commit hook ([#76](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/76))

## 4.2.0 (July 19, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Features:

* Add parameter to disable TLS certificate verification to sidecar templates ([#73](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/73))

## 4.1.0 (July 11, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Features:

* Break out compose install ([#72](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/72))

## 4.0.2 (June 29, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Features:

* ENG-12055: Remove old variables ([#71](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/71))

## 4.0.1 (June 7, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

See the list of changes since `v3` of this module in the [`4.0.0`](#400-june-6-2023) release documentation below.

### Bug fixes:

* Fix TLS secret decoding when base64 has spaces ([#69](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/69))
* Fix missing base64d in jq ([#70](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/70))

## 4.0.0 (June 6, 2023)

Minimum required **control plane** version: `v4.7.0`. Minimum required **sidecar version**: `v4.7.0`. This whole module will not work with previous sidecar or control plane versions.

Health checks and metrics were merged into a single monitoring port starting in sidecar `v4.7.0`. Due to this, we have opted to release a new major version
and use it to clean up deprecated variables related to the transition to control plane `v4`. The list of removed and added parameters is as follows:

New input parameters:

- `asg_min_healthy_percentage`
- `cloudwatch_log_group_name`
- `instance_metadata_token`
- `sidecar_ca_certificate_role_arn`
- `sidecar_ca_certificate_secret_arn`
- `sidecar_custom_host_role`
- `sidecar_tls_certificate_role_arn`
- `sidecar_tls_certificate_secret_arn`

Removed input parameters:

- `elk_address` -- no longer used. Retrieved from the control plane when sidecar is running.
- `elk_password` -- no longer used. Retrieved from the control plane when sidecar is running.
- `elk_username` -- no longer used. Retrieved from the control plane when sidecar is running.
- `healthcheck_inbound_cidr` -- use `monitoring_inbound_cidr` instead.
- `healthcheck_port` -- fixed to port `9000`.
- `metrics_inbound_cidr` -- use `monitoring_inbound_cidr` instead.
- `metrics_port` -- fixed to port `9000`.
- `mongodb_port_alloc_range_high` -- no longer used. Retrieved from the control plane when sidecar is running.
- `mongodb_port_alloc_range_low` -- no longer used. Retrieved from the control plane when sidecar is running.
- `mysql_multiplexed_port` -- no longer used. Retrieved from the control plane when sidecar is running.
- `splunk_host` -- no longer used. Retrieved from the control plane when sidecar is running.
- `splunk_index` -- no longer used. Retrieved from the control plane when sidecar is running.
- `splunk_port` -- no longer used. Retrieved from the control plane when sidecar is running.
- `splunk_tls` -- no longer used. Retrieved from the control plane when sidecar is running.
- `splunk_token` -- no longer used. Retrieved from the control plane when sidecar is running.
- `sumologic_host` -- no longer used. Retrieved from the control plane when sidecar is running.
- `sumologic_uri` -- no longer used. Retrieved from the control plane when sidecar is running.

### Features:

* Add automatic ASG refresh and validations ([#67](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/67))
* ENG-10585: Add TF param for IMDS token and clean up IMDS usage ([#54](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/54))
* ENG-11072: Add certificate generation to sidecar templates ([#61](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/61))
* ENG-11417: Update template to use the new healthcheck endpoint and logic ([#60](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/60))
* ENG-11888: Add external parameter to name cloudwatch log groups ([#65](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/65))

### Backwards compatibility breaks:

* ENG-11847: Merge healthcheck and metrics inbound CIDR fields into a single monitoring inbound cidr ([#62](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/62))
* Remove deprecated variables ([#63](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/63))

## 3.2.0 (April 21, 2023)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.

### Features:
* Add parameters for Snowflake SSO ([#59](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/59))
* ENG-11522: Deprecate log integration input variables ([#58](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/58))

## 3.1.0 (March 3, 2023)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.

### Features:
* ENG-10707: Add metrics aggregator to services ([#55](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/55))

## 3.0.3 (February 28, 2023)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Documentation:
* ENG-11115: Change IMDS hop count from 2 to 1 ([#56](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/56))
* ENG-10518: Add deprecation note to the mongodb low/high alloc ports variables ([#53](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/53))

## 3.0.2 (February 14, 2023)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Documentation:
* ENG-10517: Add deprecation note to the mysql_multiplexed_port variable ([#51](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/
* ENG-10518: Add deprecation note to the mongodb low/high alloc ports variables ([#53](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/53))

## 3.0.1 (October 11, 2022)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Bug fix:
* ENG-9772: Remove references to rest wire ([#50](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/50))

## 3.0.0 (September 19, 2022)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Features:
* ENG-8822: Make management of sidecar-created certificate internal to the sidecar ([#47](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/47))
* ENG-9286: Deprecate public docker route ([#48](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/48))
* ENG-9322: Replace launch configuration by launch template ([#49](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/49))

## 2.11.0 (July 28, 2022)
Minimum required sidecar version: `v2.34`. This whole module is fully compatible with sidecars `<2.34`, although the `dynamodb` control will be ignored in them.
### Features:
* ENG-9007: Add DynamoDB to list of supported repositories ([#45](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/45))

## 2.10.3 (July 27, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix:
* Fix minimum AWS provider requirements ([#46](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/46))
* ENG-8959: Fix race condition when upgrading sidecar ([#44](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/44))

## 2.10.2 (July 22, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix:
* Fix for_each dependency issue ([#43](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/43))

## 2.10.1 (July 15, 2022)
Minimum required sidecar version: `v2.31`.
### Features:
* Improve README

## 2.10.0 (July 15, 2022)
Minimum required sidecar version: `v2.31`.
### Features:
* ENG-8943: Allow custom S3 location for sidecar-created cert lambda ([#42](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/42))
* Added Optional Runtime Ordering for User Supplied Bash Scripts ([#41](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/41))

## 2.9.2 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix:
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/40))

## 2.9.1 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix:
* ENG-8879: Change upper limit for name_prefix variable ([#39](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/39))

## 2.9.0 (July 7, 2022)
Minimum required sidecar version: `v2.31`.
### Features:
* Addition of custom user-data script Input ([#38](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/38))

## 2.8.2 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix:
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/40))

## 2.8.1 (June 8, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix:
* ENG-8679: Fix bug that did not allow disabling ssh access ([#37](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/37))

## 2.8.0 (May 18, 2022)
Minimum required sidecar version: `v2.31`.
### Features:
* ENG-8601: Add new parameter to define kms key for secrets ([#36](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/36))

## 2.7.2 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix:
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/40))

## 2.7.1 (May 6, 2022)
Minimum required sidecar version: `v2.31`.
### Features:
* ENG-8553: Enable stickiness conditionally for specified ports in Terraform ([#35](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/35))

## 2.7.0 (April 28, 2022)
Minimum required sidecar version: `v2.31`.
### Features:
*  ENG-7369: Custom and sidecar-created certificate support ([#33](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/33))

## 2.6.1 (July 11, 2022)
Minimum required sidecar version: `v2.23`.
### Bug fix:
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/40))

## 2.6.0 (April 5, 2022)
Minimum required sidecar version: `v2.23`.
### Features:
*  ENG-8228: Add reduce_security_group_rules_count variable to avoid cartesian product in security group rules ([#28](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/28))

## 2.5.5 (July 11, 2022)
Minimum required sidecar version: `v2.23`.
### Bug fix:
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/40))

## 2.5.4 (January 10, 2022)
Minimum required sidecar version: `v2.23`.
### Documentation:
* ENG-7488: Reduce sidecar default instance size ([#25](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/25))

## 2.5.3 (December 7, 2021)
Minimum required sidecar version: `v2.23`.
### Documentation:
* Add LICENSE ([#22](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/22))

## 2.5.2 (December 3, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes:
* Fix initialization error handling for EC2-based sidecars ([#19](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/19))

## 2.5.1 (November 30, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes:
* Set proper partitions and account ID to IAM policies ([#21](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/21))

## 2.5.0 (November 19, 2021)
Minimum required sidecar version: `v2.23`.
### Features:
* Add parameter to control cross zone load balancing ([#20](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/20))

## 2.4.0 (November 4, 2021)
Minimum required sidecar version: `v2.23`.
### Features:
* Add parameter to control mux port in mysql ([#17](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/17))
* Support setting TLS mode for CP connection ([#18](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/18))

## 2.3.0 (October 15, 2021)
Minimum required sidecar version: `v2.23`.
### Features:
* Remove old dependencies and update docker compose version ([#16](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/16))

## 2.2.2 (October 28, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes:
* Improve logs ([#15](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/15))

## 2.2.1 (September 27, 2021)
Minimum required sidecar version: `v2.23`.
### Documentation:
* Improve docs

## 2.2.0 (September 27, 2021)
Minimum required sidecar version: `v2.23`.
### Features:
* Update sidecar-templates with support for denodo and redshift repo types ([#12](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/12))
### Bug fixes:
Remove wrong defaults ([#13](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/13))

## v2.1.0 (September 23, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes:
* Fix default variable value and update docs ([#11](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/11))
### Documentation:
* Update docs (#9)
### Features:
* MongoDB port allocation range definition ([#10](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/10))

## v2.0.0  (September 21, 2021)
Minimum required sidecar version: `v2.23`.
### Features:
* Use single variable to assign database ports ([#6](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/6))

## v1.2.0  (September 13, 2021)
Minimum required sidecar version: `v2.20`.
### Features:
* Support Vault integration configuration ([#8](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/8))

## v1.1.1  (September 13, 2021)
Minimum required sidecar version: `v2.20`.
### Bug fixes:
* Initialize NGINX_RESOLVER env ([#7](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/7))

## v1.1.0  (October 28, 2021)
Minimum required sidecar version: `v2.20`.
### Features:
* Reserve Ports for the Rest Service Plugin ([#5](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/5))

## v1.0.1 (June 22, 2021)
Minimum required sidecar version: `v2.20`.
### Bug fixes:
* Replaced lifecycle hook with ELB health check ([#2](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/2))

## v1.0.0 (May 13, 2021)
Minimum required sidecar version: `v2.20`.
* Initial commit
