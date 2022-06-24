terraform {
  source = "${local.aws.locals.dirs.modules}/services/${local.name}"

  before_hook "build" {
    commands = ["apply", "plan"]
    execute  = ["yarn", "run", "app:api:echo:build:${local.aws.locals.stage}"]
  }
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../ssm-parameter_service-api-echo",
    "../vpc_kalarrs",
  ]
}

dependency "ssm-parameter_service-api-echo" {
  config_path  = "../ssm-parameter_service-api-echo"
  mock_outputs = {
    name = "temporary-name"
  }
}

dependency "vpc_kalarrs" {
  config_path  = "../vpc_kalarrs"
  mock_outputs = {
    private_subnets           = "temporary-private_subnets"
    default_security_group_id = "temporary-default_security_group_id"
  }
}

locals {
  aws            = read_terragrunt_config("${get_parent_terragrunt_dir()}/aws.hcl")
  name           = "api-echo"
  artifacts_path = "${local.aws.locals.dirs.dist}/apps/api/echo/functions"
}

inputs = {
  name                   = local.name
  artifacts_path         = local.artifacts_path
  vpc_subnet_ids         = dependency.vpc_kalarrs.outputs.private_subnets
  vpc_security_group_ids = [dependency.vpc_kalarrs.outputs.default_security_group_id]
  config_parameter_paths = [
    dependency.ssm-parameter_service-api-echo.outputs.name
  ]
  tags = local.aws.locals.tags
}
