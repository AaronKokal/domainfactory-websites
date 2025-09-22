---
title: Project Tasks
description: Actionable tasks for structuring, securing, and deploying the websites monorepo.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Tasks]
categories: [Project]
---

Open Tasks
1. Add `public/` to each remaining site in `sites/` and update panel Zielverzeichnis accordingly.
2. Create GitHub Environments and secrets per remaining sites; wire workflows using the template in `docs/deep_dives/domainfactory_setup_and_deploy.md`.
3. Add `.deployignore` per site when needed (for CMS/builds).
4. Inventory check: confirm each domain → folder mapping; update `docs/reports/websites_inventory.md`.
5. Migrate any site-specific docs that should be global into `docs/` and remove duplicates in site folders.
6. Optional: Create per-site README explaining what is deployed from `public/` and how to run local builds (if any).
7. Plan future Ghost migration on Hetzner VPS — see `docs/deep_dives/ghost_on_hetzner_vps_plan.md`; templates in `templates/ghost-vps/`.

Done
- Created monorepo structure; moved `personal_website` to `sites/aaron-kokal.com`.
- Enabled SSH key‑based access and documented server layout.
- aaron-kokal.com: created `public/`, mapped domain to `webseiten/aaron-kokal.com/public`, set up CI environment + secrets, added workflow; first auto‑deploy successful.
- lab.aron-kokal.com: scaffolded Docusaurus app, migrated config/content scaffolding, updated Front Matter/README, and added GitHub Pages workflow for automatic deploys on push.
- lab.aron-kokal.com: realigned the search bar to the top-right layout slot and disabled the visible keyboard shortcut hint.
- lab.aron-kokal.com: implemented the sidebar brand header with smaller logo and a compact author profile block.
- lab.aaron-kokal.com: ran `bundle install`, captured `Gemfile.lock`, and verified `bundle exec jekyll b` builds successfully.
- lab.aaron-kokal.com: migrated the starter Docusaurus docs/blog content into `_tabs/` and `_posts/` for the Jekyll stack.
- lab.aaron-kokal.com: mapped the design guide palette into `_sass` overrides so light/dark themes use the documented tokens.
- lab.aaron-kokal.com: reintroduced a docs landing tab and reordered Tabs to separate experiments from reference material.
- lab.aaron-kokal.com: vendored the Chirpy static asset submodule, enabled self-hosted assets, and updated CI to fetch submodules during deploys.
- lab.aaron-kokal.com: enabled Polyglot with English/German content pairs and documented the `lang`/`ref` conventions.
- lab.aaron-kokal.com: refreshed README, devcontainer, and VS Code tasks/settings for the Ruby + Polyglot workflow.
- lab.aaron-kokal.com: created a brand-aligned social preview image and wired `_config.yml` to reference it.
