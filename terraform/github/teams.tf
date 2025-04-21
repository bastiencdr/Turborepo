resource "github_team" "dev_team" {
  name        = "dev-team"
  description = "Développeurs fullstack"
  privacy     = "closed"
}

resource "github_team" "ops_team" {
  name        = "ops-team"
  description = "Infrastructure & CI/CD"
  privacy     = "closed"
}

resource "github_team" "lead_team" {
  name        = "lead-team"
  description = "Équipe lead"
  privacy     = "closed"
}

resource "github_team_membership" "dev_team_owner" {
  team_id  = github_team.dev_team.id
  username = var.github_username
  role     = "maintainer"
}

resource "github_team_membership" "ops_team_owner" {
  team_id  = github_team.ops_team.id
  username = var.github_username
  role     = "maintainer"
}

resource "github_team_membership" "lead_team_owner" {
  team_id  = github_team.lead_team.id
  username = var.github_username
  role     = "maintainer"
}
