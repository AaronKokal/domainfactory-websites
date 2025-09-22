---
title: DomainFactory Static Site Deploy Scenario
description: How the aaron-kokal.com site pushes static assets to DomainFactory via rsync, with steps to replicate for other domains.
date: 2025-09-20T00:00:00Z
draft: false
tags: [DomainFactory, Deployment, StaticSite]
categories: [DeepDive]
---

## Overview

This scenario covers the workflow currently running `aaron-kokal.com`: a static site whose `public/` directory is synchronized to DomainFactory using rsync over SSH. The process relies on per-site GitHub Actions workflows, per-site secrets, and optional local scripts for manual deploys.

Use this write-up when cloning the setup for other static marketing pages that live on the DomainFactory webspace.

## Prerequisites

- A site repository under `../sites/<domain>` containing a `public/` directory with the files to publish.
- SSH access to DomainFactory via the shared admin user (`ssh-485413-admin`) or a per-site user.
- A GitHub Environment for the site with the following secrets set:
  - `SSH_HOST`
  - `SSH_PORT`
  - `SSH_USER`
  - `SSH_KEY`
  - `WEBROOT`
- Optional: a `deploy.env` file in the site repo for local deploys via `sites-master/scripts/deploy.sh`.

## GitHub Actions Workflow

The site repo includes `.github/workflows/deploy.yml`, derived from `templates/DEPLOY_TEMPLATE.md`. Key behaviours:

1. Triggers on pushes to `main` that touch `public/**`, `deploy.env`, the workflow itself, or the repo README. Manual `workflow_dispatch` is also enabled.
2. Validates required secrets before touching the server.
3. Creates an SSH key file at runtime and adds the host fingerprint via `ssh-keyscan`.
4. Tests connectivity using the deploy user to surface auth issues early.
5. Runs `rsync -az --delete` from `public/` to `$WEBROOT`.

### Adapting for a New Domain

1. Copy `templates/DEPLOY_TEMPLATE.md` into the site repo and rename it (e.g., `.github/workflows/deploy-your-domain.yml`).
2. Update metadata: workflow `name`, `concurrency.group`, `environment.name`, and `environment.url`.
3. Adjust `paths:` filters if the site uses a different build output directory.
4. Create a GitHub Environment named `<domain>-prod` (or similar) and add the secrets listed above.
5. Run the workflow manually via "Run workflow" to validate credentials before relying on automatic deploys.

## Manual Deploys

For one-off uploads or when bypassing CI:

1. Ensure the site's `deploy.env` specifies `HOST`, `PORT`, `USER`, `WEBROOT`, and optional `EXCLUDES`.
2. From `sites-master/`, run:
   ```bash
   scripts/deploy.sh aaron-kokal.com --alias df-admin          # uses SSH config alias
   scripts/deploy.sh aaron-kokal.com --dry-run --alias df-admin # safe diff before pushing
   ```
3. The script refuses to deploy if `public/` is missing or if the target path is not under `/kunden/.../webseiten/`.

## `.deployignore` Guidelines

For static sites that do not generate runtime files, `.deployignore` may remain empty. If you add tooling that produces build caches, temporary files, or CMS uploads, commit a `.deployignore` alongside the workflow and populate it with patterns to exclude (see `DomainFactory SSH & Deploy` deep dive for examples).

## Current Production Values (aaron-kokal.com)

- Domain: `aaron-kokal.com`
- GitHub repo: `sites/aaron-kokal.com`
- GitHub Environment: `aaron-kokal.com-prod`
- Webroot: `/kunden/485413_81379/webseiten/aaron-kokal.com/public`
- Workflow file: `.github/workflows/deploy.yml`
- Manual deploy config: `deploy.env`

Document any deviations for other domains inside their site README and update `docs/reports/websites_inventory.md` so the canonical mapping stays accurate.

## Related References

- `docs/deep_dives/domainfactory_setup_and_deploy.md` — connection details, SSH setup, rsync safety notes, and reusable workflow template.
- `templates/DEPLOY_TEMPLATE.md` — copy/paste starting point for GitHub Actions workflows targeting DomainFactory via rsync.
- `sites-master/scripts/deploy.sh` — manual deployment helper.
- `sites/<domain>/README.md` — per-site operational notes and TODOs.

Keep this scenario updated whenever secrets rotate, the workflow changes, or the DomainFactory hosting layout shifts.
