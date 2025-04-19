resource "github_actions_secret" "vault_password" {
  repository      = github_repository.monorepo.name
  secret_name     = "VAULT_PASSWORD"
  plaintext_value = local.shared.vault_pass
}