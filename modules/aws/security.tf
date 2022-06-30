# security.tf

# ALB Security Group: Edit to restrict access to the application
data "aws_security_group" "sg_kong" {
  name = "Web_sg"
}

########################APS Kong START###########################

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "sg_ecs_service_kong" {
  name        = "kong-ecs-sg"
  description = "ECS Kong"
  vpc_id      = module.network.aws_vpc.id

  ingress {
    description = "Only from alb"
    protocol    = "tcp"
    from_port   = var.kong_port_http
    to_port     = var.kong_port_http
    # security_groups enlists other security groups as source to use the IP addresses of the resources associated with them. 
    # This does not add rules from the specified security group to the current security group
    security_groups = [data.aws_security_group.sg_kong.id]
  }

  ingress {
    description     = "Only from alb - status"
    protocol        = "tcp"
    from_port       = var.kong_status_port_http
    to_port         = var.kong_status_port_http
    security_groups = [data.aws_security_group.sg_kong.id]
  }

  ingress {
    description     = "From Adot Prom Collector"
    protocol        = "tcp"
    from_port       = 0
    to_port         = 65535
    security_groups = [aws_security_group.sg_ecs_adot_prom_collector.id]
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

########################APS Kong END###########################

########################APS Redis START########################

# Traffic to the AWS ElasticCache
resource "aws_security_group" "sg_kong_redis" {
  name        = "kong-redis-sg"
  description = "Kong Redis Cluster"
  vpc_id      = module.network.aws_vpc.id

  ingress {
    description     = "Ingress to Redis"
    protocol        = "tcp"
    from_port       = var.redis_port_http
    to_port         = var.redis_port_http
    security_groups = [aws_security_group.sg_ecs_service_kong.id]
  }

  tags = var.common_tags
}

########################APS Redis END##########################

########################APS ADOT PROM START####################

resource "aws_security_group" "sg_ecs_adot_prom_collector" {
  name        = "sg_ecs_adot_prom_collector"
  description = "ECS Adot Prometheus Collector"
  vpc_id      = module.network.aws_vpc.id

  ingress {
    description = "Only from alb"
    protocol    = "tcp"
    from_port   = var.adot_collector_port
    to_port     = var.adot_collector_port
    # security_groups enlists other security groups as source to use the IP addresses of the resources associated with them. 
    # This does not add rules from the specified security group to the current security group
    security_groups = [data.aws_security_group.sg_kong.id]
  }

  egress {
    description = "All outbound"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################APS ADOT PROM END######################
