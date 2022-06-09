resource "aws_elasticache_cluster" "kong_redis" {
  cluster_id                    = "kong-redis"
  engine                        = "redis"
  node_type                     = "cache.t3.micro"
  num_cache_nodes               = 1
  parameter_group_name          = "pg_default6.2"
  engine_version                = "6.x"
  port                          = var.redis_port_http
  security_group_ids            = [aws_security_group.sg_kong_redis.id]
}

# resource "aws_elasticache_subnet_group" "kong_redis_subnet_grp" {
#   name       = "kong-redis-subnet-grp"
#   subnet_ids = module.network.aws_subnet_ids.app.ids
# }