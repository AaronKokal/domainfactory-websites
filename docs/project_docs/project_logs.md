---
title: Project Logs
description: Chronological log of decisions and actions for the websites monorepo.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Logs]
categories: [Project]
---

2025-09-14 — Initial Monorepo Setup
- Created SSH account `ssh-485413-admin`; added ED25519 key; verified alias `df-admin`.
- Mapped server layout (`/kunden/485413_81379`, projects under `~/webseiten`).
- Decided on monorepo with per‑site deploy isolation via GitHub Environments.
- Moved `personal_website` → `sites/aaron-kokal.com`; removed nested `.git`.
- Added top‑level docs framework and project docs; moved inventories into `docs/`.
- Added deployment template and wrote root README.

2025-09-14 — First CI/CD Deploy (aaron-kokal.com)
- Created `sites/aaron-kokal.com/public` and added welcome page.
- Added per‑site workflow: `.github/workflows/deploy-aaron-kokal.com.yml` (path‑filtered, manual dispatch, concurrency).
- Created GitHub Environment `aaron-kokal.com-prod` with secrets: `SSH_HOST`, `SSH_PORT`, `SSH_USER`, `WEBROOT`, `SSH_KEY`.
- Generated CI deploy key; appended public key to server's `~/.ssh/authorized_keys` for `ssh-485413-admin`.
- Resolved runner auth (exit 255) by explicitly using the identity file and validating secrets.
- Result: push to `main` auto‑deploys `sites/aaron-kokal.com/public` to `/kunden/485413_81379/webseiten/aaron-kokal.com/public`. Verified live.

2025-09-14 — Meet Subdomain Redirect
- Decision: serve `meet.aaron-kokal.com` via DomainFactory panel redirect to `https://meet.google.com/hev-rsmb-vdg`.
- Action: removed repo-based meet subsite and CI workflow; no code or CI needed for the redirect.

2025-09-16 — Repo Split Prep
- Moved monorepo assets into new `sites-master/` folder and re-scoped Git metadata so coordination repo no longer tracks `sites/`.
- Renamed remote repository to `sites-master` to match new role.
- Updated README and project structure docs to reflect coordination-only responsibilities.
- Created local scaffold `../sites/lab.aaron-kokal.com/index.html` for upcoming standalone repo.
- Identified need to relocate per-site deployment workflow into each site repo (current workflow in `.github/workflows/deploy-aaron-kokal.com.yml` requires redesign).
