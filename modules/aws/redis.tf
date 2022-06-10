resource "aws_elasticache_cluster" "kong_redis" {
  count                         = 1
  cluster_id                    = "kong-redis"
  engine                        = "redis"
  node_type                     = "cache.t3.micro"
  num_cache_nodes               = 1
  port                          = var.redis_port_http
  security_group_ids            = [aws_security_group.sg_kong_redis.id]
  subnet_group_name             = aws_elasticache_subnet_group.kong_redis_subnet_grp.name
}

resource "aws_elasticache_subnet_group" "kong_redis_subnet_grp" {
  name       = "kong-redis-subnet-grp"
  subnet_ids = module.network.aws_subnet_ids.app.ids
}