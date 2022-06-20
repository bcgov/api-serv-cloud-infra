data "aws_secretsmanager_secret" "redis_ratelimit_secret" {
  name = "plugins-ratelimiting-redis-password"
}

data "aws_secretsmanager_secret_version" "redis-ratelimit-secret" {
  secret_id = data.aws_secretsmanager_secret.redis_ratelimit_secret.id
}

resource "aws_elasticache_replication_group" "kong_redis_cluster" {
  replication_group_id                = "kong-redis-cluster"
  replication_group_description       = "Kong Redis Cluster Group"
  engine                              = "redis"
  engine_version                      = "6.x"
  node_type                           = "cache.t3.micro"
  number_cache_clusters               = 1
  port                                = 6379
  transit_encryption_enabled          = true
  auth_token                          = data.aws_secretsmanager_secret_version.redis-ratelimit-secret.secret_string
  security_group_ids                  = [aws_security_group.sg_kong_redis.id]
  subnet_group_name                   = aws_elasticache_subnet_group.kong_redis_subnet_grp.name
}

resource "aws_elasticache_subnet_group" "kong_redis_subnet_grp" {
  name       = "kong-redis-subnet-grp"
  subnet_ids = module.network.aws_subnet_ids.app.ids
}