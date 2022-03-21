resource "aws_ecs_task_definition" "kong-task" {
  count                    = 1
  family                   = "kong"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.kong_container_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  tags                     = local.common_tags
  container_definitions = jsonencode([
    {
      essential   = true
      container_name = "kong"
      name        = "kong"
      image       = "365055765775.dkr.ecr.ca-central-1.amazonaws.com/aps-infra/kong:${local.dev_versions.kong}"
      cpu         = var.fargate_cpu
      memory      = var.fargate_memory
      networkMode = "awsvpc"
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.kong_port_http
        },
        {
          protocol      = "tcp"
          containerPort = var.kong_port_https
        },
        {
          protocol      = "tcp"
          containerPort = var.kong_port_admin
        },
        {
          protocol      = "tcp"
          containerPort = 8444
        },
      ]
      environment = [
        {
          name  = "AWS_REGION",
          value = var.aws_region
        },
        {
          name  = "KONG_DATABASE",
          value = "off"
        },
        {
          name  = "KONG_PLUGINS",
          value = "bundled, oidc, gwa-ip-anonymity, kong-spec-expose, bcgov-gwa-endpoint, referer, jwt-keycloak, kong-upstream-jwt"
        },
        {
          name  = "KONG_PROXY_ACCESS_LOG",
          value = "/dev/stdout"
        },
        {
          name  = "KONG_ADMIN_ACCESS_LOG",
          value = "/dev/stdout"
        },
        {
          name  = "KONG_PROXY_ERROR_LOG",
          value = "/dev/stderr"
        },
        {
          name  = "KONG_ADMIN_ERROR_LOG",
          value = "/dev/stderr"
        },
        {
          name  = "KONG_ADMIN_LISTEN",
          value = "0.0.0.0:${var.kong_port_admin}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/kong"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints = []
      volumesFrom = []
    }
  ])
}