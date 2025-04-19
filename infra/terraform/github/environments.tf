locals {
  shared = {
    vault_pass = var.vault_password
  }

  environments = {
    dev = {
      branch     = "develop"
      checks     = []
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