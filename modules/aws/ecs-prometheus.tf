resource "aws_ecs_service" "prometheus" {
  count                             = 1
  name                              = "prometheus"
  cluster                           = aws_ecs_cluster.main.id
  task_definition                   = aws_ecs_task_definition.prom-task[count.index].arn
  desired_count                     = 1
  enable_ecs_managed_tags           = true
  propagate_tags                    = "TASK_DEFINITION"
  health_check_grace_period_seconds = 60
  wait_for_steady_state             = false


  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
  }


  network_configuration {
    security_groups  = [aws_security_group.sg_ecs_service_prom.id]
    subnets          = module.network.aws_subnet_ids.app.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg_prom.id
    container_name   = "prometheus"
    container_port   = var.prom_port_http
  }

  depends_on = [data.aws_lb_listener.https_listener_prom, aws_iam_role_policy_attachment.ecs_task_role_policy_attachment]

  tags = local.common_tags
}

resource "aws_ecs_task_definition" "prom-task" {
  count                    = 1
  family                   = "prometheus"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.prom_container_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  tags                     = local.common_tags
  container_definitions = jsonencode([
    {
      essential   = true
      container_name = "prometheus"
      name        = "prometheus"
      image       = "${var.ecr_repository}/prometheus:${local.dev_versions.kong}"
      cpu         = 896
      memory      = 3768
      networkMode = "awsvpc"
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = var.prom_port_http
        }
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
          value = "bundled, rate-limiting_902, oidc, oidc-consumer, gwa-ip-anonymity, kong-spec-expose, bcgov-gwa-endpoint, referer, jwt-keycloak, kong-upstream-jwt"
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
          value = "127.0.0.1:8444 http2 ssl"
        },
        {
          name  = "KONG_ROLE",
          value = "data_plane"
        },
        {
          name  = "KONG_PROXY_LISTEN",
          value = "0.0.0.0:${var.kong_port_http}"
        },
        {
          name  = "KONG_CLUSTER_CONTROL_PLANE",
          value = "gwcluster-api-gov-bc-ca.dev.api.gov.bc.ca:443"
        },
        {
          name  = "KONG_CLUSTER_MTLS",
          value = "pki"
        },
        {
          name  = "KONG_CLUSTER_CERT",
          value = "/usr/local/kongh/tls.crt"
        },
        {
          name  = "KONG_CLUSTER_CERT_KEY",
          value = "/usr/local/kongh/tls.key"
        },
        {
          name  = "KONG_CLUSTER_CA_CERT",
          value = "/usr/local/kongh/ca.crt"
        },
        {
          name  = "KONG_CLUSTER_LISTEN",
          value = "off"
        },
        {
          name  = "KONG_HEADERS",
          value = "latency_tokens"
        },
        {
          name  = "KONG_LUA_PACKAGE_PATH",
          value = "/opt/?.lua;/opt/?/init.lua;;"
        },
        {
          name  = "KONG_NGINX_EVENTS_WORKER_CONNECTIONS",
          value = "100000"
        },
        {
          name  = "KONG_NGINX_PROXY_PROXY_MAX_TEMP_FILE_SIZE",
          value = "8192m"
        },
        {
          name  = "KONG_NGINX_WORKER_PROCESSES",
          value = "1"
        },
        {
          name  = "KONG_NGINX_WORKER_RLIMIT_NOFILE",
          value = "200000"
        },
        {
          name  = "KONG_NGINX_DAEMON",
          value = "off"
        },
        {
          name  = "KONG_UNTRUSTED_LUA_SANDBOX_REQUIRES",
          value = "cjson.safe"
        },
        {
          name  = "KONG_UNTRUSTED_LUA_SANDBOX_ENVIRONMENT",
          value = "table.concat"
        },
        {
          name  = "KONG_STREAM_LISTEN",
          value = "off"
        },
        {
          name  = "KONG_STATUS_LISTEN",
          value = "0.0.0.0:${var.kong_status_port_http}"
        },
        {
          name  = "KONG_REAL_IP_HEADER",
          value = "X-Forwarded-For"
        },
        {
          name  = "KONG_PROXY_LISTEN",
          value = "0.0.0.0:8000, 0.0.0.0:8443 http2 ssl"
        },
        {
          name  = "KONG_PROXY_ERROR_LOG",
          value = "/dev/stderr"
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
      mountPoints = [{
        sourceVolume  = "secret-vol",
        containerPath = "/usr/local/kongh"
      }]
      volumesFrom = []
      dependsOn   = [{
        containerName = "secrets-injector",
        condition     = "COMPLETE"
      }]
    }
  ])
  volume {
    name = "secret-vol"
  }
}