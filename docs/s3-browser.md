#### Enable the S3 File Browser

To configure the sidecar to work on the S3 File Browser, set the following parameters in your Terraform module:

  ```
  # Certificate related changes
  load_balancer_tls_ports  = [443] # Port used to connect to the sidecar from the S3 browser
  load_balancer_certificate_arn = "arn:aws:acm:<REGION>:<AWS_ACCOUNT>:certificate/<CERTIFICATE_ID>"
  
  # Custom DNS name (CNAME) related changes
  sidecar_dns_hosted_zone_id = "<AWS_ROUTE_53_ZONE_ID>"
  sidecar_dns_name = "<CNAME>" # ex: "sidecar.custom-domain.com"
  ```

If `sidecar_dns_hosted_zone_id` is omitted, the `sidecar_dns_name` won’t
be automatically created, and the sidecar alias will need to be
created after the deployment. See [Add a CNAME or A record for
the sidecar](https://cyral.com/docs/sidecars/manage/alias).

For sidecars with support for S3, it is also a good practice to also
attach the list of IAM Policies giving the sidecar all the required
permissions to assume IAM roles with access to S3:

  ```
  # IAM Policies to be attached to the sidecar, which allow the sidecar to 
  # assume the desired IAM Roles with access to S3 buckets
  iam_policies = ["arn:aws:iam::<AWS_ACCOUNT>:policy/<POLICY_NAME>"]
  ```

For more details about the S3 File Browser configuration, check the 
[Enable the S3 File Browser](https://cyral.com/docs/how-to/enable-s3-browser) 
documentation.
