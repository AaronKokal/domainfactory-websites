---
title: Project Tasks
description: Actionable tasks for standing up a static site and subdomains.
date: 2025-09-07T00:00:00Z
draft: false
tags:
  - Tasks
categories:
  - ProjectDocs
---

# Tasks

## Now
- [ ] Create repo remote `personal_website` (private) and connect; enable chosen hosting (e.g., GitHub Pages). [DONE]
- [ ] Add `site/` skeleton: `index.html` (intro, links), `assets/` (CSS), `about.html` (optional).
- [ ] Ensure no trackers/fonts from CDNs; ship local CSS only; measure < 50 KB total.
- [ ] Domain transfer: wait for transfer to complete before DNS changes. [BLOCKED]
- [ ] Prepare DNS plan: `aaron-kokal.com` → hosting; `www` → CNAME apex; `meet` → redirect to Google Meet standing room.
- [ ] Plan secondary domain aliasing: `kokal.ai` should 301 to `aaron-kokal.com` (apex) and `SUB.kokal.ai` should 301 to `SUB.aaron-kokal.com` (preserve path/query). Document chosen platform (Cloudflare Worker vs Nginx).

## Next
- [ ] Add basic styling (CSS variables, prefers‑color‑scheme), accessible nav, and simple contact link.
- [ ] Add Open Graph and meta tags; minimal sitemap/robots.txt.
- [ ] Add deploy workflow (CI) for chosen host.
- [ ] Evaluate Ghost deployment options (managed vs self‑hosted) and initial content structure; document decision.
- [ ] Implement domain aliasing after transfer: set DNS for both zones and add redirect logic (Worker/Nginx). Verify `meet.kokal.ai` → `meet.aaron-kokal.com` and generic subdomains.

## Later
- [ ] Optional privacy‑friendly analytics (Plausible/umami) — if added, self‑hosted or EU region.
- [ ] Add additional subdomains for utilities as needed.
- [ ] If Ghost is adopted: set up theme/content model and migration plan from static pages.
- [ ] If using Cloudflare: codify redirect logic as an IaC snippet for reproducibility.
