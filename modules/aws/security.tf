# security.tf

# ALB Security Group: Edit to restrict access to the application
data "aws_security_group" "sg_kong" {
  name = "Web_sg"
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "sg_ecs_service_kong" {
  name        = "kong-ecs-sg"
  description = "Allow inbound access from the ALB only"
  vpc_id      = module.network.aws_vpc.id

  ingress {
    description     = "Only from alb"
    protocol        = "tcp"
    from_port       = var.kong_port_admin
    to_port         = var.kong_port_admin
    security_groups = [data.aws_security_group.sg_kong.id]
  }

  egress {
    description = "All outbound"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}
