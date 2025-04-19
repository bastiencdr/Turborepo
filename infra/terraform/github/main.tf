resource "github_repository" "monorepo" {
  name         = var.repository_name
  description  = "Turborepo"
  visibility   = "private"
  auto_init    = false
  has_issues   = true
  has_wiki     = false
  has_projects = false
}

resource "github_branch_protection_v3" "branch_protections" {
  for_each = local.environments

  repository = github_repository.monorepo.name
  branch     = each.value.branch

  enforce_admins = true

  required_status_checks {
    strict = true
    checks = each.value.checks
  }

  required_pull_request_reviews {
    dismiss_stale_reviews = true
    dismissal_users       = []
    dismissal_teams       = [github_team.lead_team.slug]

    bypass_pull_request_allowances {
      users = []
      teams = [github_team.lead_team.slug]
    }
  }

  restrictions {
    users = []
    teams = [github_team.dev_team.slug]
    apps  = []
  }
}