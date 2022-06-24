locals {
  hooks   = yamldecode(file("../hooks.yml"))
  package = jsondecode(file("../../package.json"))

  patterns = {
    organization = "github\\/(.*?)\\/"
  }

  matches = {
    organization = regex(local.patterns.organization, get_original_terragrunt_dir())
  }

  organization = try(element(local.matches.organization, 0), null)

  dirs = yamldecode(templatefile("./dirs.yml__tmpl__", {
    organization = local.organization,
    github_path    = "get_path_to_repo_root()/infrastructure/github",
    repo_path   = get_repo_root(),
  }))
}
