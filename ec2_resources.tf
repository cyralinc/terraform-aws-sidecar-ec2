data "aws_availability_zones" "all" {}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_launch_template" "cyral_sidecar_lt" {
  # Launch configuration for sidecar instances that will run containers
  name          = "${local.name_prefix}-LT"
  image_id      = var.ami_id != "" ? var.ami_id : data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    # instance profile name should be the same as sidecar_custom_host_role when a custom role is provided
    name = local.create_sidecar_role ? aws_iam_instance_profile.sidecar_profile[0].name : var.sidecar_custom_host_role
  }
  network_interfaces {
    device_index                = 0
    associate_public_ip_address = var.associate_public_ip_address
    security_groups = concat(
      [aws_security_group.instance.id],
      var.additional_security_groups
    )
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = var.instance_metadata_token
    http_put_response_hop_limit = 1
  }
  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = var.ec2_ebs_kms_arn
      volume_size           = var.volume_size
      volume_type           = "gp2"
    }
  }
  user_data = base64encode(<<-EOT
  #!/bin/bash -e
  ${local.cloud_init_func}
  ${try(lookup(var.custom_user_data, "pre"), "")}
  ${local.cloud_init_pre}
  ${try(lookup(var.custom_user_data, "pre_sidecar_start"), "")}
  ${local.cloud_init_post}
  ${try(lookup(var.custom_user_data, "post"), "")}
EOT
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "cyral-sidecar-asg" {
  # Autoscaling group of immutable sidecar instances
  count = var.asg_count
  name  = "${local.name_prefix}-asg"
  launch_template {
    id      = aws_launch_template.cyral_sidecar_lt.id
    version = aws_launch_template.cyral_sidecar_lt.latest_version
  }
  vpc_zone_identifier       = var.subnets
  min_size                  = var.asg_min
  desired_capacity          = var.asg_desired
  max_size                  = var.asg_max
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "EC2"
  target_group_arns         = var.deploy_load_balancer ? concat([for tg in aws_lb_target_group.cyral-sidecar-tg : tg.id], var.additional_target_groups) : var.additional_target_groups

  tag {
    key                 = "Name"
    value               = "${local.name_prefix}-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "SidecarVersion"
    value               = var.sidecar_version
    propagate_at_launch = true
  }

  tag {
    key                 = "MetricsPort"
    value               = 9000
    propagate_at_launch = true
  }

  # Delete existing hosts before starting a new one
  lifecycle {
    create_before_destroy = false
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = var.asg_min_healthy_percentage
    }
  }
}

resource "aws_security_group" "instance" {
  name   = "${local.name_prefix}-instance"
  vpc_id = var.vpc_id

  # Allow SSH inbound
  dynamic "ingress" {
    for_each = (length(var.ssh_inbound_cidr) > 0 || length(var.ssh_inbound_security_group) > 0) ? [1] : []
    content {
      description     = "SSH"
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      cidr_blocks     = var.ssh_inbound_cidr
      security_groups = var.ssh_inbound_security_group
    }
  }

  # If reduce_security_group_rules_count is true, it will create DB Inbound Rules per CIDR using
  # a port range (between the smallest and the biggest sidecar port). Otherwise, it will
  # create DB Inbound Rules per sidecar port and CIDR (Cartesian Product between Ports x CIDRs).
  # Notice that the ingress block accepts a list of CIDRs (cidr_blocks), which internally will
  # create one ingress rule per CIDR. This is an AWS limitation, which doesnt allow creating a
  # single ingress rule for a list of CIDRs.
  dynamic "ingress" {
    for_each = var.reduce_security_group_rules_count ? [1] : var.sidecar_ports
    content {
      description     = "DB"
      from_port       = var.reduce_security_group_rules_count ? min(var.sidecar_ports...) : ingress.value
      to_port         = var.reduce_security_group_rules_count ? max(var.sidecar_ports...) : ingress.value
      protocol        = "tcp"
      cidr_blocks     = var.db_inbound_cidr
      security_groups = var.db_inbound_security_group
    }
  }


  # Allow monitoring inbound
  ingress {
    description = "Sidecar - monitoring"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = var.monitoring_inbound_cidr
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_lbs" "current" {
}

resource "aws_lb" "cyral-lb" {
  count = var.deploy_load_balancer ? 1 : 0
  # If the LB already exists, use the name `<name_prefix>-lb`, otherwise use
  # `<name_prefix>`. This avoids names greater than 64 characters in the
  # self-signed certificates in some AWS regions. The reason to keep
  # `<name_prefix>-lb` is to avoid recreating the LBs for existing sidecars.
  name = length(
    [for s in data.aws_lbs.current.arns : s if can(regex("${local.name_prefix}-lb", s))]
  ) > 0 ? "${local.name_prefix}-lb" : "${local.name_prefix}"
  internal                         = var.load_balancer_scheme == "internet-facing" ? false : true
  load_balancer_type               = "network"
  subnets                          = length(var.load_balancer_subnets) > 0 ? var.load_balancer_subnets : var.subnets
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
}

resource "aws_lb_target_group" "cyral-sidecar-tg" {
  for_each = var.deploy_load_balancer ? { for port in var.sidecar_ports : tostring(port) => port } : {}
  name     = "${local.name_prefix}-${each.value}"
  port     = each.value
  protocol = "TCP"
  vpc_id   = var.vpc_id
  health_check {
    port     = 9000
    protocol = "HTTP"
    path     = "/health"
  }
  deregistration_delay = 0
  stickiness {
    enabled = contains(var.load_balancer_sticky_ports, each.value) ? true : false
    type    = "source_ip"
  }
}

resource "aws_lb_listener" "cyral-sidecar-lb-ls" {
  # Listener for load balancer - all existing sidecar ports
  for_each          = var.deploy_load_balancer ? { for port in var.sidecar_ports : tostring(port) => port } : {}
  load_balancer_arn = aws_lb.cyral-lb[0].arn
  port              = each.value

  # Snowflake listeners use TLS and the provided certificate
  protocol        = contains(var.load_balancer_tls_ports, tonumber(each.value)) ? "TLS" : "TCP"
  certificate_arn = contains(var.load_balancer_tls_ports, tonumber(each.value)) ? var.load_balancer_certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cyral-sidecar-tg[each.key].arn
  }
  # Lifecycle control added as part of a TG name that was performed
  # to make sidecars deployed using previous versions of the module
  # to recreate the TG. As the TG cannot be recreated with an existing
  # listener, the listener is then forced to be recreated here as part of
  # the TG name change.
  lifecycle {
    replace_triggered_by = [
      aws_lb_target_group.cyral-sidecar-tg[each.key].name
    ]
  }
}
