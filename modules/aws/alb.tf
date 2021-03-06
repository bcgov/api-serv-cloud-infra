# alb.tf

# Use the default ALB that is pre-provisioned as part of the account creation
# This ALB has all traffic on *.LICENSE-PLATE-ENV.nimbus.cloud.gob.bc.ca routed to it
data "aws_alb" "main" {
  name = var.alb_name
}

# Redirect all traffic from the ALB to the target group
data "aws_alb_listener" "alb_kong_http" {
  load_balancer_arn = data.aws_alb.main.id
  port              = 443
}

resource "aws_alb_target_group" "tg_kong" {
  name                 = "tg-kong"
  port                 = var.kong_port_admin
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
    unhealthy_threshold = "2"
  }

  tags = local.common_tags
}

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = data.aws_alb_listener.alb_kong_http.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg_kong.arn
  }

  condition {
    host_header {
      values = [for sn in var.service_names : "${sn}.*"]
    }
  }
}
