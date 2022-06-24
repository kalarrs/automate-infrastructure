output "lambda_api_gateway_lambda_function_arn" {
  value = module.lambda_api_gateway.lambda_function_arn
}

output "lambda_api_gateway_lambda_function_invoke_arn" {
  value = module.lambda_api_gateway.lambda_function_invoke_arn
}

output "lambda_api_gateway_lambda_function_timeout" {
  value = local.lambda_api_gateway_timeout
}
