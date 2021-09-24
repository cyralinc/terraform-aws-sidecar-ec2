# Upgrade Notes

## Upgrading from module 1.x.y to 2.x.y

### New variables

#### sidecar_ports

A single variable was defined as to assign ports to the sidecar. This variable, `sidecar_ports` replaces all the following previous variables:
* `sidecar_dremio_ports`
* `sidecar_http_ports`
* `sidecar_mongodb_ports`
* `sidecar_mysql_ports`
* `sidecar_oracle_ports`
* `sidecar_postgresql_ports`
* `sidecar_rest_ports`
* `sidecar_snowflake_ports`
* `sidecar_sqlserver_ports`
* `sidecar_s3_ports`

`sidecar_ports` defines a reduced range of ports and assumes the following default: `[80, 443, 453, 1433, 1521, 3306, 3307, 5432, 27017, 27018, 27019, 31010]`. For this reason, if your sidecar uses any ports that are not covered by this list or if you don't want to expose all the ports in the list, you should adjust it accordingly. The maximum number of ports that can be assigned to a sidecar depends on the maximum number of listeners per load balancer as defined by AWS (currently set to 50 - [see also](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-limits.html)).

#### mongodb_port_alloc_range_low and mongodb_port_alloc_range_high

Defines the lower and upper limit values for the port allocation range reserved for MongoDB. This range must correspond to the range of ports declared in `sidecar_ports` that will be used for MongoDB. The default value assigned to `sidecar_ports` contains the consecutive ports `27017`, `27018` and `27019` for MongoDB utilization. It means that the corresponding `mongodb_port_alloc_range_low` is `27017` and `mongodb_port_alloc_range_high`. If you want to use a range of `10` ports for MongoDB, add all consecutive ports to `sidecar_ports` and define the first and last values in `mongodb_port_alloc_range_low` and `mongodb_port_alloc_range_high` respectively.


## Upgrading from module 1.0.0 to any later version

### Problem statement

From `v1.0.0` to `v1.0.1` the [initial lifecycle hook](https://github.com/cyralinc/terraform-cyral-sidecar-aws/compare/v1.0.0..v1.0.1?w=1#diff-836bec1886b2c2541da0493911f05e0694664823712aed280b7c0ec46b3374c6L97-L103) and [asg complete-lifecycle-action](https://github.com/cyralinc/terraform-cyral-sidecar-aws/compare/v1.0.0..v1.0.1?w=1#diff-07d951da97790e193f01a72f55ad6a082775e409060eced3a16096492f829018L18) were removed. This change was tested in new sidecars, but during some upgrade tests, we noticed an issue with Terraform AWS provider.

When a sidecar originally created with module `1.0.0` is upgraded to `1.0.1` or later, Terraform correctly shows in the execution plan that the `initial_lifecycle_hook` will be deleted, but it does not remove it after `terraform apply`. The issue is caused by the fact that the latest version of the AWS Provider does not support updates or deletes that only target the `initial_lifecycle_hook` when it is part of the resource `aws_autoscaling_group`. For this reason, it is impossible to remove the element during sidecar upgrade. The support for creation of `initial_lifecycle_hook` during ASG creation was [added in 2016](https://github.com/hashicorp/terraform-provider-aws/commit/f56c992e3036e3e7e94c63e996ee79457f250b9a) and no changes in this specific element were performed up to [moment this upgrade note was written](https://github.com/hashicorp/terraform-provider-aws/releases/tag/v3.47.0).

### Solution

The upgrade from `1.0.0` to `1.0.1` or later requires the following procedure. It will be performed once in the lifetime of the sidecar:

* Run `terraform apply` normaly as in any upgrade;
* Open AWS EC2 Console and go to [Auto Scaling groups
](https://console.aws.amazon.com/ec2autoscaling/);
* Open the auto scaling group for the target sidecar. The name follows the form `${var.name_prefix}-asg`;
* Open the tab `Instance management`;
* Scroll down to `Lifecycle hooks`;
* Select the lifecycle hook which name follows the form `${var.name_prefix}-InitLifeCycleHook` and **delete it**;
* Proceed normally to the **instance refresh** whenever it is more convenient.
