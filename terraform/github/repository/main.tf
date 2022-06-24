resource "github_repository" "this" {
  name        = var.name
  description = var.description

  visibility = "private"

  has_downloads = true
  has_issues    = true
  has_projects  = true
  has_wiki      = true
}
