resource "aws_ecs_service" "kong" {
  count                             = local.create_ecs_service
  name                              = var.app_name
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.kong-task[count.index].arn
  desired_count                     = var.app_count
  enable_ecs_managed_tags           = true
  propagate_tags                    = "TASK_DEFINITION"
  health_check_grace_period_seconds = 60
  wait_for_steady_state             = false


  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }


  network_configuration {
    security_groups  = [aws_security_group.sg_ecs_service_kong.id]
    subnets          = module.network.aws_subnet_ids.app.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.tg-kong.id
    container_name   = var.container_name
    container_port   = var.app_port
  }

  depends_on = [data.aws_alb_listener.alb-listener-kong, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = local.common_tags
}