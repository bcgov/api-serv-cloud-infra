//module outputs should be defined and documented here.

output "alb_hostname" {
  value = data.aws_alb.main.dns_name
}

output "sns_topic" {
  value       = aws_sns_topic.billing_alert_topic.arn
  description = "Subscribe to this topic using your email to receive email alerts from the budget."
}

output "redis_primary_endpoint" {
  value       = aws_elasticache_replication_group.kong_redis_cluster.primary_endpoint_address
  description = "Redis host and server name"
}

output "kong_endpoint_url" {
  value = aws_apigatewayv2_stage.aps_kong_gateway_stage_default.invoke_url
}

output "prometheus_endpoint_url" {
  value = aws_apigatewayv2_stage.aps_prometheus_stage_default.invoke_url
}
