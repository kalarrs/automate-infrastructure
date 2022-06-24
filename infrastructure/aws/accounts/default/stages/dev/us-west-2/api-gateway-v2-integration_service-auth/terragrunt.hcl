terraform {
  source = "${local.aws.locals.dirs.modules}/api-gateway-v2-integration"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../api-gateway-v2_kalarrs",
    "../service_api-echo",
  ]
}

dependency "api-gateway-v2_kalarrs" {
  config_path  = "../api-gateway-v2_kalarrs"
  mock_outputs = {
    api_id            = "temporary-api_id"
    api_execution_arn = "temporary-api_execution_arn"
  }
}

dependency "service_api-echo" {
  config_path  = "../service_api-echo"
  mock_outputs = {
    lambda_api_gateway_lambda_function_arn     = "temporary-lambda_api_gateway_lambda_function_arn"
    lambda_api_gateway_lambda_function_timeout = "temporary-lambda_api_gateway_lambda_function_timeout"
  }
}

locals {
  aws = read_terragrunt_config("${get_parent_terragrunt_dir()}/aws.hcl")
}

inputs = {
  api_id            = dependency.api-gateway-v2_kalarrs.outputs.api_id
  api_execution_arn = dependency.api-gateway-v2_kalarrs.outputs.api_execution_arn
  integrations      = {
    "GET /echo" = {
      integration_method     = "GET"
      path                   = "/echo"
      payload_format_version = "2.0"
      lambda_arn             = dependency.service_api-echo.outputs.lambda_api_gateway_lambda_function_arn
      timeout_milliseconds   = dependency.service_api-echo.outputs.lambda_api_gateway_lambda_function_timeout
    }
  }
  tags = local.aws.locals.tags
}
