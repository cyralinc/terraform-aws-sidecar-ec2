## 2.7.1 (May 6, 2022)
Minimum required sidecar version: `v2.31`.
### Features
* ENG-8553: Enable stickiness conditionally for specified ports in Terraform ([#35](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/35))

## 2.7.0 (April 28, 2022)
Minimum required sidecar version: `v2.31`.
### Features
*  ENG-7369: Custom and sidecar-created certificate support ([#33](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/33))

## 2.6.0 (April 5, 2022)
Minimum required sidecar version: `v2.23`.
### Features
*  ENG-8228: Add reduce_security_group_rules_count variable to avoid cartesian product in security group rules ([#28](https://github.com/cyralinc/terraform-cyral-sidecar-aws/pull/28))

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
