# 📦 Terraform - Infrastructure GitHub pour Turborepo

Ce module Terraform gère toute l'infrastructure GitHub pour ton monorepo **Turborepo**, avec un système propre de gestion des environnements (`dev`, `staging`, `production`) via GitHub Actions.

---

## 📁 Structure du dossier Terraform

```
terraform/
├── main.tf
├── variables.tf
├── terraform.tfvars
└── outputs.tf (optionnel)
```

---

## 🔧 Ce que Terraform gère

| Élément                                | Détail |
|----------------------------------------|--------|
| ✅ Repo GitHub                         | Création et configuration (`private`, description, options) |
| ✅ Branch protections                  | Pour `dev`, `staging`, `main`, avec checks différents |
| ✅ Équipes GitHub                      | `dev_team`, `lead_team`, `ops_team` |
| ✅ Permissions des équipes             | `push`, `maintain`, `admin` selon leur rôle | (voir [Valeurs valides](#valeurs-valides))
| ✅ Secrets GitHub Actions              | `VAULT_PASSWORD` partagé à tous les jobs |

---

## 🧠 Séparation des environnements

Le fichier `locals` définit les paramètres par environnement (branche + checks) :

```hcl
locals {
  shared = {
    vault_pass = var.vault_password
  }

  environments = {
    dev = {
      branch     = "dev"
      checks     = ["lint"]
    }
    staging = {
      branch     = "staging"
      checks     = ["lint", "test"]
    }
    production = {
      branch     = "main"
      checks     = ["lint", "test", "build"]
    }
  }
}
```

Chaque branche est protégée selon sa logique propre avec `github_branch_protection_v3`.

---

## 🔐 Secrets GitHub Actions

### Actuellement géré :

```hcl
resource "github_actions_secret" "vault_password" {
  repository      = data.github_repository.monorepo.name
  secret_name     = "VAULT_PASSWORD"
  plaintext_value = local.shared.vault_pass
}
```

Ce secret permet de déchiffrer les fichiers `.env.vault` dans Ansible.

---

## 🚀 Déploiement avec Ansible

Les secrets `.env` spécifiques à chaque environnement sont gérés **côté Ansible**, pas dans Terraform.

Terraform prépare les fondations GitHub, **Ansible s’occupe du déploiement applicatif (Docker, secrets Vault, etc.)**.

---

## 🧪 Exemple de `terraform.tfvars`

```hcl
github_token     = "ghp_xxxxxx"
github_owner     = "bastiencdr"
repository_name  = "Turborepo"
vault_password   = "monSuperMotDePasse"
```

---

## ✅ Résumé

| Qui fait quoi ?    | Terraform                      | Ansible                            |
|--------------------|--------------------------------|-------------------------------------|
| Crée le repo GitHub | ✅                              | ❌                                   |
| Gère les secrets GitHub | ✅ (`VAULT_PASSWORD`)     | ❌                                   |
| Gère les fichiers `.env` | ❌                        | ✅ avec Ansible Vault                |
| Lance Docker / app | ❌                             | ✅                                   |
| CI/CD GitHub Actions | Préparé via Terraform       | Utilisé via workflow                |

---

## 📌 Recommandation

- Tu peux ajouter un `outputs.tf` pour afficher l'URL du repo à la fin du `terraform apply`
- Garde les secrets sensibles hors des `.tfvars` commités (via variables d'env ou Vault)
- Utilise Ansible pour tout ce qui concerne le déploiement applicatif

---

## Valeurs valides

Valeurs valides pour permission

- `pull` : Lecture seule. La team peut cloner, créer des issues, commenter… mais pas de push.
- `triage` : Lecture + triage. Peut gérer les issues/PRs (tag, assign, etc.), mais pas de code push.
- `push` : Lecture + écriture. Peut push, merge, créer des branches. Ne peut pas changer les settings.
- `maintain` : Tout comme push, mais avec en plus des droits pour gérer les branches, webhooks, secrets, etc. sans avoir accès
- `admin` : Accès complet : gérer les settings du repo, activer/désactiver des features, branch protection, etc. Attention, c’est le niveau max.
