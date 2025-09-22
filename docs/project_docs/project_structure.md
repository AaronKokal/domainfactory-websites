---
title: Project Structure
description: Coordination repo layout for Sites Master.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Structure]
categories: [Project]
---

Repository Layout (`own_websites-projects/` root)
- `sites-master/` — coordination repository containing shared docs, scripts, and templates.
- `sites/` — working copies of each live site (e.g., `sites/aaron-kokal.com`). Each remains a standalone Git repository.

`sites-master/` Contents
- `docs/` — shared documentation for the website fleet (framework, project docs, deep dives, reports).
- `scripts/` — helper scripts for deploys and maintenance.
- `templates/` — reusable workflow/server templates (per-site GitHub Actions YAML files live in `templates/workflows/`).

`sites/` Expectations
- Each site owns its build artifacts, GitHub Pages settings, and deployment workflows. Copy needed templates from `sites-master/templates/` into the site repo when wiring automation.
- Site-specific documentation should live with the site unless it is broadly applicable, in which case promote it to `docs/`.

Server Layout (DomainFactory SSH chroot)
- Home root: `/kunden/485413_81379`
- Projects root: `/kunden/485413_81379/webseiten`
- Recommended docroot per site: `/kunden/485413_81379/webseiten/<site>/public`

Operational Rules
- Maintain inventories and shared policies in this repo; keep site-specific logic inside each site repo.
- Use GitHub Environments per site repository to scope secrets.
- Keep uploads/logs outside deploy directories or exclude via `.deployignore`.
