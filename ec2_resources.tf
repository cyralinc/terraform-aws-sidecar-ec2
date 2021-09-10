data "aws_availability_zones" "all" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_launch_configuration" "cyral-sidecar-lc" {
  # Launch configuration for sidecar instances that will run containers
  name_prefix                 = "${var.name_prefix}-autoscaling-"
  image_id                    = var.ami_id != "" ? var.ami_id: data.aws_ami.amazon_linux_2.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.sidecar_profile.name
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  security_groups             = local.security_groups
  metadata_options {
    # So docker can access ec2 metadata
    # see https://github.com/aws/aws-sdk-go/issues/2972
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 2
  }
  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = var.volume_size
    volume_type           = "gp2"
  }
  user_data = <<-EOT
  ${local.cloud_init_pre}

  echo "Downloading sidecar.compose.yaml..."
  function download_sidecar () {
    local url="https://${var.control_plane}/deploy/sidecar.compose.yaml?TemplateVersion=${var.sidecar_version}&TemplateType=terraform&LogIntegration=${var.log_integration}&MetricsIntegration=${var.metrics_integration}&WiresEnabled=${join(",", var.repositories_supported)}"
    echo "Trying to download the sidecar template from: $url"
    if [[ $(curl -s -o /dev/null -w "%%{http_code}" -L "$url") = 200 ]]; then
      curl -L "$url" > /home/ec2-user/sidecar.compose.yaml;
      return 0
    fi
    return 1
  }
  retry download_sidecar

  echo "Fetching secrets..."
  aws secretsmanager get-secret-value --secret-id ${var.secrets_location} --query SecretString --output text \
    --region ${data.aws_region.current.name} | jq -r 'select(.containerRegistryKey != null) | .containerRegistryKey' | base64 --decode > /home/ec2-user/cyral/container_registry_key.json
  until [ -f /home/ec2-user/cyral/container_registry_key.json ]; do echo "wait"; sleep 1; done
  cat >> /home/ec2-user/.bash_profile << EOF
  if [[ ${var.container_registry} == *".amazonaws.com"* ]]; then
    echo "Logging in to AWS ECR..."
    eval $(aws ecr --no-include-email get-login  --region ${data.aws_region.current.name})
  elif [ -s /home/ec2-user/cyral/container_registry_key.json ]; then
      echo "Logging in to GCR..."
      cat /home/ec2-user/cyral/container_registry_key.json | docker login -u ${var.container_registry_username} --password-stdin https://gcr.io
  else
      echo "Won't log in automatically to any image registry. Image registry set to: ${var.container_registry}"
  fi
  EOF
  ${local.cloud_init_post}
EOT
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cyral-sidecar-asg" {
  # Autoscaling group of immutable sidecar instances
  count                     = var.asg_count
  name                      = "${var.name_prefix}-asg"
  launch_configuration      = aws_launch_configuration.cyral-sidecar-lc.id
  vpc_zone_identifier       = var.subnets
  min_size                  = var.asg_min
  desired_capacity          = var.asg_desired
  max_size                  = var.asg_max
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "ELB"
  target_group_arns         = [for tg in aws_lb_target_group.cyral-sidecar-tg : tg.id]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "SidecarVersion"
    value               = var.sidecar_version
    propagate_at_launch = true
  }

  # Delete existing hosts before starting a new one
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_security_group" "instance" {
  name   = "${var.name_prefix}-instance"
  vpc_id = var.vpc_id

  # Allow SSH inbound
  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = var.ssh_inbound_cidr
    security_groups = var.ssh_inbound_security_group
  }


  # Allow DB inbound
  dynamic "ingress" {
    for_each = local.sidecar_ports
    # iterator = "sidecar_ports"
    content {
      description     = "DB"
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      cidr_blocks     = var.db_inbound_cidr
      security_groups = var.db_inbound_security_group
    }
  }

  # Allow healthcheck inbound
  ingress {
    description = "Sidecar - Healthcheck"
    from_port   = var.healthcheck_port
    to_port     = var.healthcheck_port
    protocol    = "tcp"
    # A network load balancer has no security group:
    # https://docs.aws.amazon.com/elasticloadbalancing/latest/network/target-group-register-targets.html#target-security-groups
    cidr_blocks = var.healthcheck_inbound_cidr # TODO - change this to LB IP only
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "cyral-lb" {
  # Core load balancer
  name               = "${var.name_prefix}-lb"
  internal           = var.load_balancer_scheme == "internet-facing" ? false : true
  load_balancer_type = "network"
  subnets            = length(var.load_balancer_subnets) > 0 ? var.load_balancer_subnets : var.subnets
  security_groups    = local.security_groups
}

resource "aws_lb_target_group" "cyral-sidecar-tg" {
  for_each = {for port in local.sidecar_ports: tostring(port) => port}
  name     = "${var.name_prefix}-tg${each.value}"
  port     = each.value
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    port     = var.healthcheck_port
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "cyral-sidecar-lb-ls" {
  # Listener for load balancer - all existing sidecar ports
  for_each = {for port in local.sidecar_ports: tostring(port) => port}
  load_balancer_arn = aws_lb.cyral-lb.arn
  port              = each.value

  # Snowflake listeners use TLS and the provided certificate
  protocol          = contains(local.sidecar_tls_ports, tonumber(each.value)) ? "TLS" : "TCP"
  certificate_arn   = contains(local.sidecar_tls_ports, tonumber(each.value)) ? var.load_balancer_certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cyral-sidecar-tg[each.key].arn
  }
}
