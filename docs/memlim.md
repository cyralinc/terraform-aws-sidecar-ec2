# Memory Limiting

In addition to configuring the memory capacity of the EC2 instance the sidecar
is deployed on, the individual services within the sidecar each have a default
memory limit. The memory limit is a maximum number of bytes that a service is 
allowed to consume. This is useful to prevent a single service from consuming
all available memory on the instance and causing other services to fail as a
result. Currently, each "wire" service has a default memory limit of 512MB while
other services are limited to 128MB.

Users can override the default memory limits if desired by setting various 
environment variables. These can be set as part of the `custom_user_data` input
parameter (detailed below).

## Environment Variables

The following environment variables can be set to override the default memory
limits.

Wires (default 512MB):

* `CYRAL_PG_WIRE_MAX_MEM`
* `CYRAL_MYSQL_WIRE_MAX_MEM`
* `CYRAL_ORACLE_WIRE_MAX_MEM`
* `CYRAL_SQLSERVER_WIRE_MAX_MEM`
* `CYRAL_DYNAMODB_WIRE_MAX_MEM`
* `CYRAL_S3_WIRE_MAX_MEM`
* `CYRAL_MONGODB_WIRE_MAX_MEM`
* `CYRAL_SNOWFLAKE_WIRE_MAX_MEM`
* `CYRAL_DREMIO_WIRE_MAX_MEM`

Misc. services (default 128MB):

* `CYRAL_AUTHENTICATOR_MAX_SYS_SIZE_MB`
* `FORWARD_PROXY_MAX_SYS_SIZE_MB`
* `ALERTER_MAX_SYS_SIZE_MB`
* `SERVICE_MONITOR_MAX_SYS_SIZE_MB`
* `NGINX_PROXY_HELPER_MAX_SYS_SIZE_MB`

Values should be set in megabytes (MB). For example, to set the memory limit
for the PostgreSQL wire service to 1GB, set `CYRAL_PG_WIRE_MAX_MEM=1024`.

The environment variables passed to the sidecar container are set in the file
`/home/ec2-user/.env`. Any changes to the memory limits as environment variables
should be made in this file (see next section).

## Setting Memory Limits via the `custom_user_data` Input Parameter

The `custom_user_data` input parameter can be used to set the memory limits for
the services. The `custom_user_data` input takes the following form:

```json
{
  "pre": "",
  "pre_sidecar_start": "",
  "post": ""
}
```

The string values are shell scripts that will be executed at the corresponding
lifecycle stage of the sidecar, executed when the EC2 instance starts up. The
memory limits should be set in the `pre_sidecar_start` script. For example, to 
set the memory limit for the PostgreSQL wire service to 1GB, set the
`pre_sidecar_start` script as follows:

```json
{
  "pre": "",
  "pre_sidecar_start": "cat <<EOF > /home/ec2-user/.env\nCYRAL_PG_WIRE_MAX_MEM=1024\nEOF",
  "post": ""
}
```

You can follow the same pattern to set memory limits for other services.
