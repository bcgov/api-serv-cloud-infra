# alb.tf

# Use the default ALB that is pre-provisioned as part of the account creation
# This ALB has all traffic on *.LICENSE-PLATE-ENV.nimbus.cloud.gob.bc.ca routed to it
data "aws_alb" "main" {
  name = var.alb_name
}

data "aws_lb_listener" "https_listener" {
  load_balancer_arn = data.aws_alb.main.id
  port              = 443
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = data.aws_alb.main.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "application/json"
      status_code  = "404"
    }
  }
}

########################APS Kong START##################################

resource "aws_lb_target_group" "tg_kong" {
  name                 = "tg-kong"
  port                 = var.kong_port_http
  protocol             = "HTTP"
  vpc_id               = module.network.aws_vpc.id
  target_type          = "ip"
  deregistration_delay = 30

  health_check {
    healthy_threshold   = "2"
    interval            = "5"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    port                = var.kong_status_port_http
    unhealthy_threshold = "2"
  }

  tags = local.common_tags
}

resource "aws_lb_listener_rule" "forward_http_kong" {
  listener_arn = aws_lb_listener.http_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_kong.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_lb_listener_rule" "forward_https_kong" {
  listener_arn = data.aws_lb_listener.https_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_kong.arn
  }

  condition {
    host_header {
      values = [for sn in var.service_names : "${sn}.*"]
    }
  }
}

########################APS Kong END##################################

########################APS ADOT Prom START###########################

resource "aws_lb_target_group" "tg_adot_collector" {
  name                 = "tg-adot-collector"
  port                 = var.adot_collector_port
  protocol             = "HTTP"
  vpc_id               = module.network.aws_vpc.id
  target_type          = "ip"
  deregistration_delay = 30

  tags = local.common_tags
}

resource "aws_lb_listener_rule" "forward_http_prometheus" {
  listener_arn = aws_lb_listener.http_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_adot_collector.arn
  }

  condition {
    path_pattern {
      values = ["/metrics"]
    }
  }
}

########################APS ADOT Prom END###########################
