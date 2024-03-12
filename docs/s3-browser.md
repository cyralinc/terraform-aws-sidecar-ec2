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
be automatically created in Route53 and the CNAME will need to be
created after the deployment. See [Add a CNAME or A record for
the sidecar](https://cyral.com/docs/sidecars/manage/alias).

For sidecars with support for S3, it is also necessary to create an IAM
role with permissions to access the target S3 buckets (S3 role). This role must
have a trust relationship with the sidecar role created as part of this module,
so the sidecar can use it to access the target S3 buckets. The arn of the IAM
role with the S3 access permissions must then be provided to the 
control plane as part of the repository configuration.

The code below can be used as a starting point to
create your S3 role and also to trust the sidecar role created as part
of this module:

```hcl
# Creates an IAM policy that the sidecar will assume in order to access
# your S3 bucket. In this example, the policy attached to the role will
# let the sidecar access all buckets.
#
# This should NOT be used in production. Refer to the AWS documentation
# for guidance on how to restrict to the buckets you plan to protect.
#
data "aws_iam_policy_document" "s3_access_policy" {
  statement {
    actions   = ["s3:*"]
    resources = [
      "arn:aws:s3:::*"
    ]
  }
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "sidecar_s3_access_policy"
  path        = "/"
  description = "Allow sidecar to access S3"
  policy      = data.aws_iam_policy_document.s3_access_policy.json
}

data "aws_iam_policy_document" "sidecar_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "AWS"
      identifiers = [module.cyral_sidecar.aws_iam_role_arn]
    }
  }
}

resource "aws_iam_role" "s3_role" {
  name               = "sidecar_s3_access_role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.sidecar_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "s3_role_policy_attachment" {
  role       = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

For more details about the S3 File Browser configuration, check the 
[Enable the S3 File Browser](https://cyral.com/docs/how-to/enable-s3-browser) 
documentation.
