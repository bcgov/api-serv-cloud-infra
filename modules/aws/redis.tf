resource "aws_elasticache_cluster" "kong_redis" {
  cluster_id                    = "kong-redis"
  engine                        = "redis"
  node_type                     = "cache.t3.micro"
  num_cache_nodes               = 1
  parameter_group_name          = "pg_default6.2"
  engine_version                = "6.2"
  port                          = var.redis_port_http
  auto_minor_version_upgrade    = true
  security_group_ids            = [aws_security_group.sg_kong_redis.id]

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.kong_redis_logs.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
}

# resource "aws_elasticache_subnet_group" "kong_redis_subnet_grp" {
#   name       = "kong-redis-subnet-grp"
#   subnet_ids = module.network.aws_subnet_ids.app.ids
# }