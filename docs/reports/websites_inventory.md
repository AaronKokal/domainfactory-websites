---
title: Websites Inventory
description: Structured summary of all sites currently present on the server and their paths.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Inventory]
categories: [Report]
---

Top Level
- Home root: `/kunden/485413_81379`
- Projects root: `/kunden/485413_81379/webseiten`

## Sites & Scenarios

| Domain | Scenario | Hosting Target | Repo / Automation Notes |
| --- | --- | --- | --- |
| `aaron-kokal.com` | **Scenario D — DomainFactory Static (rsync)** | `/kunden/485413_81379/webseiten/aaron-kokal.com/public` | Repo: `sites/aaron-kokal.com`; workflow `.github/workflows/deploy.yml` (rsync). Manual helper: `scripts/deploy.sh` with `deploy.env`. |
| `lab.aron-kokal.com` | **Scenario E — GitHub Pages static (Decap ready)** | GitHub Pages (custom domain `lab.aron-kokal.com`); GitHub serves build artefacts | Repo: `sites/lab.aron-kokal.com` (Docusaurus). `main` push → GitHub Actions build → Pages deploy. Decap CMS not yet enabled. |
| `meet.aaron-kokal.com` | Panel redirect | Redirects to Google Meet | No repo; managed via DomainFactory control panel. |
| `schallvagabunden.de` | **Scenario A — WordPress @ DomainFactory** | `/kunden/485413_81379/webseiten/schallvagabunden` | WordPress core managed in-place; exclude writable paths during deploys. |
| `aaronvincent.de` | **Scenario A — WordPress @ DomainFactory** | `/kunden/485413_81379/webseiten/aaronvincent/wordpress` | WordPress; confirm plugin/theme workflow before syncing. |
| `kokalcoach.de` | **Scenario A — WordPress @ DomainFactory** | `/kunden/485413_81379/webseiten/kokalcoach/wordpress/wordpress` | WordPress nested docroot; watch double `wordpress/` path. |
| `kokaleventsupport.de` | **Scenario A — WordPress @ DomainFactory** | `/kunden/485413_81379/webseiten/kokaleventsupport/wordpress` | WordPress. |
| `talk.aaron-kokal.com` | **Scenario A — WordPress @ DomainFactory** | `/kunden/485413_81379/webseiten/talk/wordpress` | WordPress; ensure `.deployignore` covers uploads. |
| `midsommarOLD24.de` | Legacy WordPress/custom mix | `/kunden/485413_81379/webseiten/midsommarOLD24` | Audit before changes; contains historical assets. |
| `midsommar.de` | TBD (likely WordPress) | `/kunden/485413_81379/webseiten/midsommar` | Review stack; not yet documented. |
| `toni.designhorizon.de` | WordPress | `/kunden/485413_81379/webseiten/toni/designhorizon/2305Masterarbeit/wordpress` | Verify ownership with Toni before altering. |
| `toni.toninton.de` | WordPress | `/kunden/485413_81379/webseiten/toni/toninton/wordpress` | WordPress. |

## Notes

- Many sites contain `wordpress_YYYY…` backup/update directories. Do not deploy to or delete them without verification.
- For Scenario D sites, keep GitHub Environment secrets in sync with DomainFactory credentials and run `scripts/deploy.sh <domain> --dry-run --alias df-admin` before major publishes.
- Scenario references match `docs/deep_dives/own_websites_setup_scenarios.md`.
