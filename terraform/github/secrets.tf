resource "github_actions_secret" "vault_password" {
  repository      = data.github_repository.monorepo.name
  secret_name     = "VAULT_PASSWORD"
  plaintext_value = local.shared.vault_pass
}

resource "github_actions_secret" "ssh_key" {
  repository      = data.github_repository.monorepo.name
  secret_name     = "SSH_KEY"
  plaintext_value = local.shared.ssh_key
}

resource "github_actions_secret" "ssh_host" {
  repository      = data.github_repository.monorepo.name
  secret_name     = "SSH_HOST"
  plaintext_value = local.shared.ssh_host
}