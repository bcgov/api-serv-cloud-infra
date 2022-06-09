resource "aws_apigatewayv2_api" "aps_kong_gateway_api" {
  name          = "APS Kong Gateway API"
  protocol_type = "HTTP"
  description   = "AWS HTTP API for Kong Gateway"
}

resource "aws_apigatewayv2_integration" "aps_kong_gateway_integration" {
  api_id           = aws_apigatewayv2_api.aps_kong_gateway_api.id
  integration_type = "HTTP_PROXY"

  integration_method = "ANY"
  integration_uri    = aws_lb_listener.http_listener_kong.arn
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.aps_kong_gateway_vpc_link.id
}

resource "aws_apigatewayv2_route" "aps_kong_gateway_route" {
  api_id    = aws_apigatewayv2_api.aps_kong_gateway_api.id
  route_key = "ANY /"
  target = "integrations/${aws_apigatewayv2_integration.aps_kong_gateway_integration.id}"
}

resource "aws_apigatewayv2_vpc_link" "aps_kong_gateway_vpc_link" {
  name               = "APS Kong Gateway VPC Link"
  security_group_ids = [aws_security_group.sg_ecs_service_kong.id]
  subnet_ids         = module.network.aws_subnet_ids.app.ids
}

resource "aws_apigatewayv2_stage" "aps_kong_gateway_stage_default" {
  api_id = aws_apigatewayv2_api.aps_kong_gateway_api.id
  name   = "$default"
  auto_deploy = true
}

output "kong_endpoint_url" {
  value = aws_apigatewayv2_stage.aps_kong_gateway_stage_default.invoke_url
}