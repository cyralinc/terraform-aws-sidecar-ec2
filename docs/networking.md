# Advanced networking configurations

It is possible to deploy the sidecar module to different networking configurations to attend different needs.
For testing and evaluation purposes, it is very common that customers will deploy a public sidecar
(public load balancer and public instances), but this is not a recommended approach for a production
environment. In production, typically customers will deploy an entirely private sidecar (private load 
balancer and private instances), but sometimes it is necessary to deploy a public load balancer and
keep instances in a private subnet.

See the following sections how to set up the necessary parameters for each of these scenarios.

All resources outlined below are expected to live in the same VPC, meaning that the parameter
`vpc_id` will correspond to the ID of the VPC of all subnets used throughout the deployment 
configuration.

## Public load balancer and public EC2 instances

To deploy an entirely public sidecar, use the following parameters:

* `subnets`: provide public subnets in the same VPC. These subnets will be used for both the EC2
instances and the load balancer. All the provided subnets must allow the allocation of public IPs
and have a route to an internet gateway to enable internet access.
* `load_balancer_scheme`: set to `"internet-facing"`.
* `associate_public_ip_address` set to `true`.

## Private load balancer and private EC2 instances

To deploy an entirely private sidecar, use the following parameters:

* `subnets`: provide private subnets in the same VPC. These subnets will be used for both the EC2
instances and the load balancer. All the provided subnets must have a route to the internet
through a NAT gateway.
* `load_balancer_scheme`: set to `"internal"` (this is the default value).
* `associate_public_ip_address` set to `false` (this is the default value).

## Public load balancer and private EC2 instances

To deploy a public load balancer and private EC2 instances, use the following parameters:

`subnets` and `load_balancer_subnets`.
* `subnets`: provide private subnets in the same VPC. These subnets will be used only for the EC2
instances. All the provided subnets must have a route to the internet through a NAT gateway.
* `load_balancer_subnets`: provide public subnets in the same VPC and the same AZs as those in
parameter `subnets`. These subnets will be used only for the load balancer. All the provided 
subnets must allow the allocation of public IPs and have a route to an internet gateway to 
enable internet access. If two private subnets in AZ1 and AZ2 were provided in `subnets`, use
public subnets in the same AZs for this parameter. Failing to provide matching subnets will
cause the target group to not be able to route the traffic to the EC2 instances.
* `load_balancer_scheme`: set to `"internet-facing"`.
* `associate_public_ip_address` set to `false` (this is the default value).
