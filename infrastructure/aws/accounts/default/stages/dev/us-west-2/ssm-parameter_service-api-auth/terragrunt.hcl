terraform {
  source = "${local.aws.locals.dirs.modules}/ssm-parameter"
}

include {
  path = find_in_parent_folders()
}

locals {
  aws = read_terragrunt_config("${get_parent_terragrunt_dir()}/aws.hcl")
}

inputs = {
  path = "services/api/echo"
  value = jsonencode({
    name = "echo"
    value = "what ever you said"
  })
  tags = local.aws.locals.tags
}
