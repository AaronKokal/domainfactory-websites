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
2. Create GitHub Environments and secrets per remaining sites; wire workflows using `templates/DEPLOY_TEMPLATE.md`.
3. Add `.deployignore` per site when needed (for CMS/builds).
4. Inventory check: confirm each domain → folder mapping; update `docs/reports/websites_inventory.md`.
5. Migrate any site‑specific docs that should be global into `docs/` and remove duplicates in site folders.
6. Optional: Create per‑site README explaining what is deployed from `public/` and how to run local builds (if any).
7. Plan future Ghost migration on Hetzner VPS — see `docs/deep_dives/ghost_on_hetzner_vps_plan.md`; templates in `templates/ghost-vps/`.

Done
- Created monorepo structure; moved `personal_website` to `sites/aaron-kokal.com`.
- Enabled SSH key‑based access and documented server layout.
- aaron-kokal.com: created `public/`, mapped domain to `webseiten/aaron-kokal.com/public`, set up CI environment + secrets, added workflow; first auto‑deploy successful.
