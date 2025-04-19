output "repository_url" {
  description = "URL du repository GitHub créé"
  value       = github_repository.monorepo.html_url
}

output "repository_name" {
  description = "Nom du repository GitHub"
  value       = github_repository.monorepo.name
}

output "dev_team_slug" {
  description = "Slug de la team Dev"
  value       = github_team.dev_team.slug
}

output "ops_team_slug" {
  description = "Slug de la team Ops (utile pour d'autres modules)"
  value       = github_team.ops_team.slug
}

output "lead_team_slug" {
  description = "Slug de la team Lead"
  value       = github_team.lead_team.slug
}

output "develop_branch" {
  description = "Nom de la branche de développement"
  value       = local.environments.dev.branch
}

output "staging_branch" {
  description = "Nom de la branche de staging"
  value       = local.environments.staging.branch
}

output "production_branch" {
  description = "Nom de la branche de production"
  value       = local.environments.production.branch
}
