variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
}

variable "github_owner" {
  description = "Nom de l'organisation ou utilisateur GitHub"
  type        = string
}

variable "repository_name" {
  description = "Nom du repository à gérer"
  type        = string
}

variable "vault_password" {
  description = "Mot de passe du secret Vault"
  type        = string
  sensitive   = true
}

variable "github_username" {
  description = "Ton nom d'utilisateur GitHub"
  type        = string
}