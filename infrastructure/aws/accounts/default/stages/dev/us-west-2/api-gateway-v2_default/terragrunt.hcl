terraform {
  source = "${local.aws.locals.dirs.modules}/api-gateway-v2"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = [
    "../security-group_api-gateway-v2-kalarrs",
    "../vpc_kalarrs",
  ]
}

dependency "security-group_api-gateway-v2" {
  config_path  = "../security-group_api-gateway-v2-kalarrs"
  mock_outputs = {
    security_group_id = "temporary-security_group_id"
  }
}

dependency "vpc_kalarrs" {
  config_path  = "../vpc_kalarrs"
  mock_outputs = {
    public_subnets = "temporary-public_subnets"
  }
}

locals {
  aws = read_terragrunt_config("${get_parent_terragrunt_dir()}/aws.hcl")
}

inputs = {
  name               = "kalarrs"
  public_subnets     = dependency.vpc_kalarrs.outputs.public_subnets
  security_group_ids = [dependency.security-group_api-gateway-v2.outputs.security_group_id]
  tags               = local.aws.locals.tags
}
