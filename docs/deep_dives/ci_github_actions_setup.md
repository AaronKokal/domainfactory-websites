---
title: GitHub Actions CI for Site Deploys
description: Per‑site rsync deploys with environment‑scoped secrets and a CI deploy key.
date: 2025-09-14T00:00:00Z
draft: false
tags: [CI, GitHubActions, Deploy]
categories: [DeepDive]
---

Overview
- Each site in `sites/<domain>/public` is deployed by a dedicated workflow filtered to that path.
- Secrets are stored in a GitHub Environment named `<domain>-prod` to isolate credentials.

Setup Steps (per site)
1) Create server target:
   - SSH: `mkdir -p ~/webseiten/<domain>/public`
   - Panel: Zielverzeichnis = `webseiten/<domain>/public`
2) Create CI deploy key:
   - Local: `ssh-keygen -t ed25519 -C df-ci-<domain> -f ~/.ssh/id_ed25519_df_ci_<short>`
   - Install public key on server: `cat ~/.ssh/id_ed25519_df_ci_<short>.pub | ssh df-admin 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'`
   - Test: `ssh -i ~/.ssh/id_ed25519_df_ci_<short> -o IdentitiesOnly=yes df-admin 'echo ok'`
3) GitHub Environment `<domain>-prod`:
   - Secrets: `SSH_HOST`, `SSH_PORT`, `SSH_USER`, `WEBROOT`, `SSH_KEY` (private key contents)
4) Workflow file `.github/workflows/deploy-<domain>.yml`:
   - Trigger: push on `main` with `paths: ["sites/<domain>/**"]`
   - Steps: checkout, validate secrets, setup SSH, test SSH, rsync `sites/<domain>/public/` → `$WEBROOT`

Troubleshooting
- Exit 255 on SSH: key not in `authorized_keys`, wrong secret values, or permissions (ensure `~/.ssh 700`, `authorized_keys 600`).
- Workflow didn’t trigger: change must touch `sites/<domain>/**` or the workflow file.
- 403 after deploy: domain not mapped to correct Zielverzeichnis, or DNS still propagating.

