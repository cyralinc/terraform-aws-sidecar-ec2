## 3.1.0 (March 3, 2023)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.

### Feature
* ENG-10707: Add metrics aggregator to services ([#55](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/55))

## 3.0.3 (February 28, 2023)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Documentation
* ENG-11115: Change IMDS hop count from 2 to 1 ([#56](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/56))
* ENG-10518: Add deprecation note to the mongodb low/high alloc ports variables ([#53](https://github.com/cyralinc/terraform-aws-sidecar-ec2/pull/53))

## 3.0.2 (February 14, 2023)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Documentation
* ENG-10517: Add deprecation note to the mysql_multiplexed_port variable ([#51](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/
* ENG-10518: Add deprecation note to the mongodb low/high alloc ports variables ([#53](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/53))

## 3.0.1 (October 11, 2022)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Bug fix
* ENG-9772: Remove references to rest wire ([#50](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/50))

## 3.0.0 (September 19, 2022)
Minimum required **control plane** version: `v2.34.6`. Minimum required **sidecar version**: `v2.34.6`. This whole module will not work with previous sidecar or control plane versions.
### Feature
* ENG-8822: Make management of sidecar-created certificate internal to the sidecar ([#47](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/47))
* ENG-9286: Deprecate public docker route ([#48](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/48))
* ENG-9322: Replace launch configuration by launch template ([#49](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/49))

## 2.11.0 (July 28, 2022)
Minimum required sidecar version: `v2.34`. This whole module is fully compatible with sidecars `<2.34`, although the `dynamodb` control will be ignored in them.
### Feature
* ENG-9007: Add DynamoDB to list of supported repositories ([#45](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/45))

## 2.10.3 (July 27, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix
* Fix minimum AWS provider requirements ([#46](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/46))
* ENG-8959: Fix race condition when upgrading sidecar ([#44](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/44))

## 2.10.2 (July 22, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix
* Fix for_each dependency issue ([#43](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/43))

## 2.10.1 (July 15, 2022)
Minimum required sidecar version: `v2.31`.
### Features
* Improve README

## 2.10.0 (July 15, 2022)
Minimum required sidecar version: `v2.31`.
### Features
* ENG-8943: Allow custom S3 location for sidecar-created cert lambda ([#42](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/42))
* Added Optional Runtime Ordering for User Supplied Bash Scripts ([#41](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/41))

## 2.9.2 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/40))

## 2.9.1 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix
* ENG-8879: Change upper limit for name_prefix variable ([#39](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/39))

## 2.9.0 (July 7, 2022)
Minimum required sidecar version: `v2.31`.
### Features
* Addition of custom user-data script Input ([#38](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/38))

## 2.8.2 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/40))

## 2.8.1 (June 8, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix
* ENG-8679: Fix bug that did not allow disabling ssh access ([#37](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/37))

## 2.8.0 (May 18, 2022)
Minimum required sidecar version: `v2.31`.
### Features
* ENG-8601: Add new parameter to define kms key for secrets ([#36](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/36))

## 2.7.2 (July 11, 2022)
Minimum required sidecar version: `v2.31`.
### Bug fix
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/40))

## 2.7.1 (May 6, 2022)
Minimum required sidecar version: `v2.31`.
### Features
* ENG-8553: Enable stickiness conditionally for specified ports in Terraform ([#35](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/35))

## 2.7.0 (April 28, 2022)
Minimum required sidecar version: `v2.31`.
### Features
*  ENG-7369: Custom and sidecar-created certificate support ([#33](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/33))

## 2.6.1 (July 11, 2022)
Minimum required sidecar version: `v2.23`.
### Bug fix
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/40))

## 2.6.0 (April 5, 2022)
Minimum required sidecar version: `v2.23`.
### Features
*  ENG-8228: Add reduce_security_group_rules_count variable to avoid cartesian product in security group rules ([#28](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/28))

## 2.5.5 (July 11, 2022)
Minimum required sidecar version: `v2.23`.
### Bug fix
* Update the bootstrap script version that uses `rpm --force` ([#40](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/40))

## 2.5.4 (January 10, 2022)
Minimum required sidecar version: `v2.23`.
### Documentation
* ENG-7488: Reduce sidecar default instance size ([#25](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/25))

## 2.5.3 (December 7, 2021)
Minimum required sidecar version: `v2.23`.
### Documentation
* Add LICENSE ([#22](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/22))

## 2.5.2 (December 3, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes
* Fix initialization error handling for EC2-based sidecars ([#19](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/19))

## 2.5.1 (November 30, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes
* Set proper partitions and account ID to IAM policies ([#21](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/21))

## 2.5.0 (November 19, 2021)
Minimum required sidecar version: `v2.23`.
### Features
* Add parameter to control cross zone load balancing ([#20](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/20))

## 2.4.0 (November 4, 2021)
Minimum required sidecar version: `v2.23`.
### Features
* Add parameter to control mux port in mysql ([#17](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/17))
* Support setting TLS mode for CP connection ([#18](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/18))

## 2.3.0 (October 15, 2021)
Minimum required sidecar version: `v2.23`.
### Features
* Remove old dependencies and update docker compose version ([#16](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/16))

## 2.2.2 (October 28, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes
* Improve logs ([#15](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/15))

## 2.2.1 (September 27, 2021)
Minimum required sidecar version: `v2.23`.
### Documentation
* Improve docs

## 2.2.0 (September 27, 2021)
Minimum required sidecar version: `v2.23`.
### Features
* Update sidecar-templates with support for denodo and redshift repo types ([#12](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/12))
### Bug fixes
Remove wrong defaults ([#13](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/13))

## v2.1.0 (September 23, 2021)
Minimum required sidecar version: `v2.23`.
### Bug fixes
* Fix default variable value and update docs ([#11](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/11))
### Documentation
* Update docs (#9)
### Features
* MongoDB port allocation range definition ([#10](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/10))

## v2.0.0  (September 21, 2021)
Minimum required sidecar version: `v2.23`.
### Features
* Use single variable to assign database ports ([#6](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/6))

## v1.2.0  (September 13, 2021)
Minimum required sidecar version: `v2.20`.
### Features
* Support Vault integration configuration ([#8](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/8))

## v1.1.1  (September 13, 2021)
Minimum required sidecar version: `v2.20`.
### Bug fixes
* Initialize NGINX_RESOLVER env ([#7](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/7))

## v1.1.0  (October 28, 2021)
Minimum required sidecar version: `v2.20`.
### Features
* Reserve Ports for the Rest Service Plugin ([#5](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/5))

## v1.0.1 (June 22, 2021)
Minimum required sidecar version: `v2.20`.
### Bug fixes
* Replaced lifecycle hook with ELB health check ([#2](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/2))

## v1.0.0 (May 13, 2021)
Minimum required sidecar version: `v2.20`.
* Initial commit
