resource "aws_ecs_task_definition" "kong-task" {
  count                    = local.create_ecs_service
  family                   = var.app_name
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
      container_name = var.app_name
      name        = var.app_name
      image       = var.app_image
      cpu         = var.fargate_cpu
      memory      = var.fargate_memory
      networkMode = "awsvpc"
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.kong_port_http
          hostPort      = var.kong_port_http
        },
        {
          protocol      = "tcp"
          containerPort = var.kong_port_https
          hostPort      = var.kong_port_https
        }
      ]
      environment = [
        {
          name  = "AWS_REGION",
          value = var.aws_region
        },
        {
          name  = "role",
          value = "data_plane"
        },
        {
          name  = "database",
          value = "off"
        },
        {
          name  = "cluster_mtls",
          value = "pki"
        },
        {
          name  = "plugins",
          value = "bundled, oidc, gwa-ip-anonymity, kong-spec-expose, bcgov-gwa-endpoint, referer, jwt-keycloak, kong-upstream-jwt"
        },
        {
          name  = "proxy_access_log",
          value = "off"
        },
        {
          name  = "headers",
          value = "latency_tokens"
        },
        {	
          name  = "nginx_worker_processes",
          value = "1"
        },
        {
          name  = "nginx_events_worker_connections",
          value = "100000"
        },
        {
          name  = "nginx_worker_rlimit_nofile",
          value = "200000"
        },
        {
          name  = "nginx_proxy_proxy_max_temp_file_size",
          value = "8192m"
        },
        {
          name  = "real_ip_header",
          value = "X-Forwarded-For"
        },
        {
          name  = "trusted_ips",
          value = "10.97.0.0/16,10.95.0.0/16"
        },
        {
          name  = "untrusted_lua_sandbox_requires",
          value = "cjson.safe"
        },
        {
          name  = "untrusted_lua_sandbox_environment",
          value = "table.concat"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-create-group  = "true"
          awslogs-group         = "/ecs/${var.app_name}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints = []
      volumesFrom = []
    }
  ])
}