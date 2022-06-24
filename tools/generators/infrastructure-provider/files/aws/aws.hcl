locals {
  hooks   = yamldecode(file("../hooks.yml"))
  package = jsondecode(file("../../package.json"))

  patterns = {
    path = "aws\\/(?P<account>[^/]+)\\//(?:environments|stages)/(?P<stage_environment>[^/]+)/(?P<region>us-.*?-\\d)"
  }

  matches = {
    account           = regex(local.patterns.account, get_original_terragrunt_dir())
    region            = regexall(local.patterns.region, get_original_terragrunt_dir())
    stage_environment = regex(local.patterns.stage_environment, get_original_terragrunt_dir())
  }

  stage       = element(local.matches.stage_environment, 1)
  environment = try(element(local.matches.stage_environment, 2), null)
  region      = try(element(local.matches.region, 0), "us-east-1")

  account = try(element(local.matches.account, 0), "default")

  is_prod_alt = local.stage == "beta" || local.stage == "alpha"

  dirs = yamldecode(templatefile("./dirs.yml__tmpl__", {
    aws_account = local.account,
    aws_path    = "get_path_to_repo_root()/infrastructure/aws",
    repo_path   = get_repo_root(),
  }))

  tags = merge({
    Stage               = local.stage
    Company             = local.package.name
    TerragruntDirectory = substr(replace(get_original_terragrunt_dir(), get_repo_root(), ""), 1, -1)
  }, local.environment != null ? { Environment = local.environment } : {})
}
