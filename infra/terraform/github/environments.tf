locals {
  shared = {
    vault_pass = var.vault_password
  }
  environments = {
    main = {
      branch = "main"
      checks = [
        "lint",
        "test",
        "build",
        "typecheck",
        "security"
      ]
    },
    develop = {
      branch = "develop"
      checks = [
        "lint",
        "test"
      ]
    },
    staging = {
      branch = "staging"
      checks = [
        "lint",
        "test",
        "build"
      ]
    }
  }
}