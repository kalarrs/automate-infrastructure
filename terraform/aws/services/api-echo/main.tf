locals {
  stage        = lookup(var.tags, "Stage", "")
  insights_arn = "arn:aws:lambda:${data.aws_region.current.name}:580247275435:layer:LambdaInsightsExtension-Arm64:2"
  lambda_api_gateway_timeout = 30
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

module "lambda_api_gateway" {
  source  = "registry.terraform.io/terraform-aws-modules/lambda/aws"
  version = "~> v3.1"

  function_name = "${var.name}-api-gateway-${local.stage}"
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  attach_network_policy = true
  vpc_subnet_ids = var.vpc_subnet_ids
  vpc_security_group_ids = var.vpc_security_group_ids

  tracing_mode = "Active"
#  layers       = [local.insights_arn]

  source_path = "${var.artifacts_path}/api-gateway"

  memory_size           = 256
  timeout               = local.lambda_api_gateway_timeout
  environment_variables = {
    APP_CONFIG_PATH = var.config_parameter_paths[0]
  }

  attach_policy_jsons = true
  policy_jsons        = [
    templatefile("${path.module}/policies/ssm.json__tmpl__", {
      parameter  = var.config_parameter_paths[0]
      region     = data.aws_region.current.name
      account_id = data.aws_caller_identity.current.account_id
    })
  ]
  number_of_policy_jsons = 1

  attach_policy = true
  policy        = "arn:aws:iam::aws:policy/CloudWatchLambdaInsightsExecutionRolePolicy"

  tags = var.tags
}
