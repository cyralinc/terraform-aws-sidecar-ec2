# Bring Your Own Secret

You can create your own secret and provide it to this module instead of
letting the module manage the sidecar secrets automatically. This is tipically
useful for customers willing to deploy the secrets to a different account
than that used to deploy the sidecar.

You can create your own secret in AWS Secrets Manager and provide its full
ARN to parameter `secret_arn` as long as the secrets contents is a JSON
with the following format:

```JSON
{
    "clientId":"",
    "clientSecret":"",
    "containerRegistryKey":"",
    "idpCertificate":"",
    "sidecarPublicIdpCertificate":"",
    "sidecarPrivateIdpKey":""
}
```

Make sure to call the Terraform function `replace(<CERTIFICATE_CONTENTS>, "\n", "\\n")`
to escape the new lines in the parameters `idpCertificate`,
`sidecarPublicIdpCertificate` and `sidecarPrivateIdpKey` before storing them on
your secret.

In case you are creating this secret in a different account, make sure to use
the input parameter `secret_role_arn` to provide the ARN of the role that will
be assumed in order to read the secret.

See also:

* To understand the concept of `Full ARN`, read [this page](https://docs.aws.amazon.com/secretsmanager/latest/userguide/troubleshoot.html#ARN_secretnamehyphen).
