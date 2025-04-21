resource "github_team_repository" "dev_team_access" {
  team_id    = github_team.dev_team.id
  repository = data.github_repository.monorepo.name
  permission = "push"
}

resource "github_team_repository" "ops_team_access" {
  team_id    = github_team.ops_team.id
  repository = data.github_repository.monorepo.name
  permission = "admin"
}

resource "github_team_repository" "lead_team_access" {
  team_id    = github_team.lead_team.id
  repository = data.github_repository.monorepo.name
  permission = "maintain"
}
