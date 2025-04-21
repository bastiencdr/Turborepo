locals {
  shared = {
    vault_pass = var.vault_password
    ssh_key = var.ssh_key
    ssh_host = var.ssh_host
  }

  environments = {
    main = {
      branch = "main"
      checks = [
        "lint",
        "test",
        "security",
        "Detect modified apps",
        "build (noop)",
        "typecheck (noop)"
      ]
    }

    develop = {
      branch = "develop"
      checks = [
        "lint",
        "test",
        "security"
      ]
    }

    staging = {
      branch = "staging"
      checks = [
        "lint",
        "test",
        "security",
        "build (noop)"
      ]
    }
  }
}