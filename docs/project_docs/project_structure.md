---
title: Project Structure
description: Coordination repo layout for Sites Master.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Structure]
categories: [Project]
---

Repository Layout (`sites-master/`)
- `docs/` — shared documentation for all sites (framework, project docs, deep dives, reports).
- `scripts/` — helper scripts for deploys and maintenance.
- `templates/` — reusable workflow/server templates (per-site GitHub Actions YAML files live in `templates/workflows/`).

Sibling Layout (`../sites/`)
- Each site is a standalone Git repository cloned beside this coordination repo (e.g., `../sites/aaron-kokal.com`).
- Site repos own their build artifacts, GitHub Pages settings, and deployment workflows. Copy needed templates from this repo into each site.

Server Layout (DomainFactory SSH chroot)
- Home root: `/kunden/485413_81379`
- Projects root: `/kunden/485413_81379/webseiten`
- Recommended docroot per site: `/kunden/485413_81379/webseiten/<site>/public`

Operational Rules
- Maintain inventories and shared policies in this repo; keep site-specific logic inside each site repo.
- Use GitHub Environments per site repository to scope secrets.
- Keep uploads/logs outside deploy directories or exclude via `.deployignore`.
