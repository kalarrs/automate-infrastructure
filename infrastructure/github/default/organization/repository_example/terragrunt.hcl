terraform {
  source = "${local.github.locals.dirs.modules}/repository"
}

include {
  path = find_in_parent_folders()
}

locals {
  github = read_terragrunt_config("${get_parent_terragrunt_dir()}/github.hcl")
}

inputs = {
  name = "example"
}
