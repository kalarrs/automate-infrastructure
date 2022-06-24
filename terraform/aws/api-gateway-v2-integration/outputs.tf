output "integration_ids" {
  value = [for i in aws_apigatewayv2_integration.this : i.id]
}

output "integrations" {
  value = {for k, i in aws_apigatewayv2_integration.this : k => i.id}
}

output "route_ids" {
  value = [for i in aws_apigatewayv2_route.this : i.id]
}

output "route_keys" {
  value = [for i in aws_apigatewayv2_route.this : i.route_key]
}

output "routes" {
  value = {for k, i in aws_apigatewayv2_route.this : k => {
    id        = i.id,
    route_key = i.route_key
  }}
}
