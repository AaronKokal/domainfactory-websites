---
title: Project Structure
description: Monorepo structure and folder responsibilities for DomainFactory Websites.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Structure]
categories: [Project]
---

Repository Layout
- `sites/<domain>/` — source per website
  - `public/` — deploy root mirrored to the server
  - `README.md` — the ONLY place for site‑specific notes. Do not create a `docs/` folder inside sites; all shared and long‑form documentation lives at the monorepo root under `docs/`.
- `docs/` — global documentation for the monorepo
  - `framework/` — immutable framework (Agent README, editing guide, migration guide, system blueprint, project README template)
  - `project_docs/` — mission, tasks, stack, logs, and this structure
  - `deep_dives/` — technical guides (e.g., DomainFactory SSH/rsync setup)
  - `reports/` — inventories (e.g., websites inventory)
- `templates/` — CI/CD templates and samples
- `scripts/` — helper scripts (future)

Server Layout (SSH chroot)
- Home root: `/kunden/485413_81379`
- Projects: `~/webseiten/<site>`
- Recommended docroot per site: `~/webseiten/<site>/public`

Operational Rules
- Never deploy to the account root; only to `public/` of each site.
- Use GitHub Environments per site to scope secrets.
- Keep uploads/logs outside deploys or exclude via `.deployignore`.
