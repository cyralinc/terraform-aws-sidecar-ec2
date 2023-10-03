# Configuring certificates for Terraform AWS EC2 sidecars

You can use Cyral's default [sidecar-created
certificate](https://cyral.com/docs/sidecars/certificates/overview#sidecar-created-certificate) or use a
[custom certificate](https://cyral.com/docs/sidecars/certificates/overview#custom-certificate) to secure
the communications performed by the sidecar. In this page, we provide
instructions on how to use a custom certificate.

## Use your own certificate

You can use a certificate signed by you or the Certificate Authority of your
choice. Provide the ARN of the certificate secrets to the sidecar module, as
in the section [Provide custom certificate to the sidecar](#provide-custom-certificate-to-the-sidecar). 
Please make sure
that the following requirements are met by your private key / certificate pair:

- Both the private key and the certificate **must** be encoded in the **UTF-8**
  charset.

- The certificate must follow the **X.509** format.

**WARNING:** *Windows* commonly uses UTF-16 little-endian encoding. A UTF-16 certificate
   or private key will *not* work in the sidecar.

## Cross-account deployment

If you have a scenario in which you have two different accounts: one where you
deploy the sidecar and another where you manage the sidecar secrets, then you
can use the module inputs `sidecar_custom_host_role`,
`sidecar_tls_certificate_role_arn` (for TLS certificate) or
`sidecar_ca_certificate_role_arn` (for CA certificate) to the sidecar
module. Suppose you have the following configuration:

   - Account `111111111111` used to manage secrets
   - Account `222222222222` used to deploy the sidecar

1. You need to manually configure at least one IAM role to allow for
   cross-account access: a role in `111111111111`, which we will call
   `role1`. You may also create a custom role in account `222222222222` to
   replace the default role used by the sidecar. We will call this second role
   `role2`. `role1` must have a trust policy that allows the sidecar role (the
   default one or `role2`) to assume it. If you create `role2`, note that it
   must allow `sts:AssumeRole` on `role1`. This configuration can be achieved in
   different ways, so we direct you to [AWS
   documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_cross-account-with-roles.html)
   for further information.

1. Provide the ARN of `role1` to `sidecar_tls_certificate_role_arn` (for the TLS
   certificate) or `sidecar_ca_certificate_role_arn` (for the CA certificate) of
   the sidecar module. If you created role `role2`, provide the ARN of `role2`
   to the parameter `sidecar_custom_host_role`.

1. Provide the ARNs of the certificate secrets to the sidecar module, as
   instructed in the next section.

## Provide custom certificate to the sidecar

There are two parameters in the sidecar module you can use to provide the ARN of
a secret containing a custom certificate:

1. `sidecar_tls_certificate_secret_arn` (Optional) ARN of secret in AWS Secrets
   Manager that contains a certificate to terminate TLS connections.

1. `sidecar_ca_certificate_secret_arn` (Optional) ARN of secret in AWS Secrets
   Manager that contains a CA certificate to sign sidecar-generated certs.

The secrets must follow the following JSON format.

```json
{
  "cert": "{myCertBase64}",
  "key": "{myPrivateKeyBase64}"
}
```

Where `{myCertBase64}` is your custom certificate, encoded in base64, and
`{myPrivateKeyBase64}` is your private key, encoded in base64. Note that the
base64 encoding is an extra encoding over the PEM-encoded values.

The choice between providing a `tls`, a `ca` secret or *both* will depend on the repositories
used by your sidecar. See the certificate type used by each repository in the 
[sidecar certificates](https://cyral.com/docs/sidecars/deployment/certificates#sidecar-certificate-types) page.