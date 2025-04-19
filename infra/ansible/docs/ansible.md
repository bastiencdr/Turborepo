# 🧪 Déploiement multi-environnement avec Ansible

Ce projet utilise Ansible pour déployer automatiquement les applications Docker selon l'environnement ciblé (`dev`, `staging`, `production`).  
Chaque environnement dispose de ses propres variables, secrets, hôtes et configuration.

---

## 📁 Structure du projet

```
ansible/
├── playbook.yml
├── inventory/
│   ├── dev.ini
│   ├── staging.ini
│   └── prod.ini
├── group_vars/
│   ├── dev.yml
│   ├── staging.yml
│   └── prod.yml
├── vars/
│   ├── defaults.yml
│   ├── secrets.dev.yml
│   ├── secrets.staging.yml
│   └── secrets.prod.yml
├── roles/
│   ├── docker/
│   ├── global/
│   ├── email/
│   ├── web/
│   ├── software/
│   └── monitoring/
```

---

## ⚙️ `playbook.yml`

```yaml
- name: Déployer l'application sur les hôtes maîtres
  hosts: master
  become: true

  vars_files:
    - vars/defaults.yml
    - vars/secrets.{{ env }}.yml

  roles:
    - { role: docker,     tags: [docker] }
    - { role: global,     tags: [global] }
    - { role: email,      tags: [email] }
    - { role: web,        tags: [web] }
    - { role: software,   tags: [software] }
    - { role: monitoring, tags: [monitoring] }
```

---

## 🔐 Secrets Ansible Vault

Les secrets sont séparés par environnement et chiffrés avec Ansible Vault :

```
vars/
├── secrets.dev.yml.vault
├── secrets.staging.yml.vault
└── secrets.production.yml.vault
```

### Pour chiffrer un secret :

```bash
ansible-vault encrypt vars/secrets.dev.yml
```

---

## 🔧 Variables par environnement

Chaque fichier `group_vars/<env>.yml` contient les variables spécifiques à un environnement.

### Exemple : `group_vars/dev.yml`

```yaml
env: dev
docker_image_tag: latest-dev
api_url: https://dev.api.example.com
```

---

## 🚀 Commandes de déploiement

### ➕ Déploiement en `dev`

```bash
ansible-playbook playbook.yml \
  -i inventory/dev.ini \
  -e "env=dev" \
  --ask-vault-pass
```

### 🔸 Déploiement en `staging`

```bash
ansible-playbook playbook.yml \
  -i inventory/staging.ini \
  -e "env=staging" \
  --ask-vault-pass
```

### 🔴 Déploiement en `production`

```bash
ansible-playbook playbook.yml \
  -i inventory/production.ini \
  -e "env=production" \
  --ask-vault-pass
```

---

## ✅ Avantages

- 🔄 Playbook unique pour tous les environnements
- 🔐 Secrets isolés et chiffrés
- 🛠️ Paramètres personnalisables par environnement
- 🤖 Intégration facile en CI/CD

---

## 📦 À faire ensuite

- Ajouter un pipeline GitHub Actions pour lancer le bon playbook
- Intégrer un inventaire dynamique si tu travailles avec AWS ou Docker Swarm
- Déployer des services conditionnels selon les rôles activés