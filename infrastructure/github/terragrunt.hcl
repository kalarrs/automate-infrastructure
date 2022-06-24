terraform {
  extra_arguments "disable_input" {
    commands = get_terraform_commands_that_need_vars()
  }

  extra_arguments "disable_input" {
    commands  = get_terraform_commands_that_need_input()
    arguments = ["-input=false"]
  }
}

locals {
  github = read_terragrunt_config("${get_parent_terragrunt_dir()}/github.hcl")
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = templatefile("${get_parent_terragrunt_dir()}/providers.tf.tmpl", {
    organization = local.github.locals.organization
  })
}

remote_state {
  backend = "s3"
  config  = {
    encrypt                     = true
    region                      = "us-west-2"
    key                         = "github/${local.github.locals.package.name}/${path_relative_to_include()}/terraform.tfstate"
    bucket                      = "terraform-states-${get_aws_account_id()}"
    dynamodb_table              = "terraform-locks-${get_aws_account_id()}"
    skip_metadata_api_check     = true
    skip_credentials_validation = true
  }
}
