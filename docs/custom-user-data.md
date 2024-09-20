# Setting custom user-data scripts

In Amazon EC2, user-data is a script or set of instructions provided during instance launch to automate tasks like software installation or configuration. It runs once when the instance is first provisioned.

This module supports custom user-data injection through the `custom_user_data` variable. By using this variable, you can inject your own script to customize instance provisioning according to your specific requirements. This variable is a map with three keys: `pre`, `pre_sidecar_start`, and `post`, indicating the execution order relative to sidecar installation. The `pre` script runs before any sidecar components are installed, `pre_sidecar_start` runs immediately before the sidecar starts, and `post` is executed after the sidecar installation is complete.

As an example, one could set the variable as follows to inject custom commands for installing the sidecar on a Red Hat Enterprise Linux 9 image, where the sidecar will be installed using Podman instead of Docker.

```
  use_single_container = true
  custom_user_data = {
    "pre"               = <<-EOT
      systemctl stop nftables || echo 'cannot stop nftables'
      systemctl disable nftables || echo 'cannot disable nftables'
      function package_install(){
        yum update -y
        yum install -y podman podman-docker python3-pip jq
        pip3 install awscli
      }
      function docker_setup(){
        systemctl enable podman
        systemctl restart podman
      }
      eval "$(declare -f launch | sed s/--log-driver=local/--log-driver=journald/)"
    EOT
    "pre_sidecar_start" = "",
    "post"              = <<-EOT
      podman generate systemd --new --name sidecar | sed "s|env-file .env|env-file /home/ec2-user/.env|" > /etc/systemd/system/container-sidecar.service
      systemctl enable container-sidecar
    EOT
  }
```
