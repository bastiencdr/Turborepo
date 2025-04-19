data "github_repository" "monorepo" {
full_name = "${var.github_owner}/${var.repository_name}"
}

resource "github_branch_protection_v3" "branch_protections" {
  for_each = local.environments

  repository = data.github_repository.monorepo.name
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
      users = [var.github_username]
      teams = [github_team.lead_team.slug]
    }
  }

  restrictions {
    users = []
    teams = [github_team.dev_team.slug]
    apps  = []
  }
}