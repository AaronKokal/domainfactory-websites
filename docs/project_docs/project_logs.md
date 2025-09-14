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
