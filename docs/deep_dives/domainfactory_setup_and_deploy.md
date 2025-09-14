---
title: DomainFactory SSH & Deploy
description: How to access the server, inspect contents, and deploy safely via rsync over SSH.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Operations, Hosting]
categories: [DeepDive]
---

Account & Host
- Customer UID: `485413`
- SSH user: `ssh-485413-admin`
- Host: `schallvagabunden.de`
- SSH home (chroot root): `/kunden/485413_81379`

Key Setup
- On server: `~/.ssh/authorized_keys` with ED25519 keys; perms `700` (dir) and `600` (file).
- Local alias in `~/.ssh/config`:
  - Host df-admin
    HostName schallvagabunden.de
    User ssh-485413-admin
    IdentityFile ~/.ssh/id_ed25519_df_admin
    IdentitiesOnly yes

Inspecting Files
- `ssh df-admin 'echo HOME=$HOME; pwd; ls -la ~'`
- `ssh df-admin 'find ~ -maxdepth 3 -print | sort'`
- `ssh df-admin 'du -h -d 1 ~ | sort -h'`

Safe Deploy Targets
- Prefer per‑site docroot: `~/webseiten/<site>/public` for static, or site root for WordPress.
- Never deploy to `~` or `/` with `--delete`.

GitHub Actions → rsync
- Secrets per site (via Environments): `SSH_HOST`, `SSH_PORT`, `SSH_USER`, `WEBROOT`, `SSH_KEY`.
- Template workflow: see `templates/DEPLOY_TEMPLATE.md`.

CMS Writable Paths (exclude from deploys)
- Always exclude: `.git/`, `.github/`, `.env*`, `*.log`, build caches.
- Typical CMS examples (adjust per system):
  - WordPress: `wp-content/uploads/`, `wp-content/cache/`, `wp-content/upgrade/`, security logs
  - Craft CMS/Statamic: `storage/`, `vendor/` (if building on server), `public/uploads/`
  - Ghost (if used via static export): exclude content images you don’t track, or manage them in a `shared/` path

Inventory
- See `docs/reports/websites_inventory.md` for canonical absolute paths per site.
