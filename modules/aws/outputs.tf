//module outputs should be defined and documented here.

output "alb_hostname" {
  value = data.aws_alb.main.dns_name
}

output "sns_topic" {
  value       = aws_sns_topic.billing_alert_topic.arn
  description = "Subscribe to this topic using your email to receive email alerts from the budget."
}

output "redis_address" {
  value = aws_elasticache_cluster.kong_redis.0.cache_nodes.0.address
}

output "redis_port" {
  value = aws_elasticache_cluster.kong_redis.0.port
}

output "redis_availability_zone" {
  value = aws_elasticache_cluster.kong_redis.0.availability_zone
}

output "redis_url" {
  value = "redis://${aws_elasticache_cluster.kong_redis.0.cache_nodes.0.address}:${aws_elasticache_cluster.kong_redis.0.port}"
}
