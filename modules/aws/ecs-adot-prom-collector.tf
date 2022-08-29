resource "aws_ecs_service" "adot_prom_collector" {
  count                   = 1
  name                    = "adot_prom_collector"
  cluster                 = aws_ecs_cluster.main.id
  task_definition         = aws_ecs_task_definition.adot_prom_collector_task[count.index].arn
  desired_count           = 1
  enable_ecs_managed_tags = true
  propagate_tags          = "TASK_DEFINITION"
  wait_for_steady_state   = false

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }

  network_configuration {
    security_groups  = [aws_security_group.sg_ecs_adot_prom_collector.id]
    subnets          = module.network.aws_subnet_ids.app.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_adot_collector.id
    container_name   = "adot-prom-collector"
    container_port   = var.adot_collector_port
  }

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "adot_prom_collector_task" {
  count                    = 1
  family                   = "adot_prom_collector_task"
  execution_role_arn       = aws_iam_role.ecs_prom_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_prom_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  tags                     = local.common_tags
  container_definitions = jsonencode([{
    essential      = true
    container_name = "adot-prom-collector"
    name           = "adot-prom-collector"
    image          = "amazon/aws-otel-collector:v0.11.0"
    networkMode    = "awsvpc"
    portMappings = [
      {
        protocol      = "tcp"
        containerPort = var.adot_collector_port
      }
    ]
    secrets = [
      {
        name      = "AOT_CONFIG_CONTENT",
        valueFrom = "otel-collector-config"
      }
    ]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-create-group  = "true"
        awslogs-group         = "/ecs/adot-prom-collector"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}
