terraform {
  source = "${local.aws.locals.dirs.modules}/vpc"
}

include {
  path = find_in_parent_folders()
}

locals {
  aws = read_terragrunt_config("${get_parent_terragrunt_dir()}/aws.hcl")
}

inputs = {
  name = "kalarrs"
  azs  = ["us-west-2a", "us-west-2b", "us-west-2c"]
  cidr = "10.20.0.0/16"
  tags = local.aws.locals.tags
}
