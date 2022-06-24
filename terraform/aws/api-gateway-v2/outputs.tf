output "api_api_endpoint" {
  value = module.api_gateway_v2.apigatewayv2_api_api_endpoint
}

output "api_arn" {
  value = module.api_gateway_v2.apigatewayv2_api_arn
}

output "api_execution_arn" {
  value = module.api_gateway_v2.apigatewayv2_api_execution_arn
}

output "api_id" {
  value = module.api_gateway_v2.apigatewayv2_api_id
}

output "vpc_link_id" {
  value = module.api_gateway_v2.apigatewayv2_vpc_link_id
}

output "vpc_link_arn" {
  value = module.api_gateway_v2.apigatewayv2_vpc_link_arn
}
