---
title: Own Websites Setup Scenarios
description: Evaluation of four hosting and CMS setups for the own websites portfolio, with trade-offs, decision triggers, and implementation notes.
date: 2025-09-20T00:00:00Z
draft: false
tags: [Planning, Hosting]
categories: [DeepDive]
---

## Purpose

This deep dive captures the current evaluation of four ways to run the "own websites" constellation. Each scenario covers where content lives, how deployments work, and what operational effort is required. Use this as a decision aid when standing up a new property under `sites/` or when reconsidering an existing stack.

## Repo Context

The monorepo keeps reusable templates in `sites-master/` and project code under `sites/<domain>/`. Whichever scenario you pick, document final decisions in the relevant site README and update `docs/reports/websites_inventory.md` so the live stack matches the record.

## Scenario A — WordPress All-in-One @ DomainFactory

**Snapshot**
- Everything (marketing pages + blog) runs in a single WordPress instance installed via DomainFactory.
- No build pipeline; the PHP application serves content dynamically.

**Strengths**
- Fastest time-to-launch with minimal developer involvement.
- Mature editor features: roles, media library, WYSIWYG blocks.
- Theme and plugin marketplace cover most commodity needs.

**Watchpoints**
- You dislike WordPress ergonomics; adoption requires a mindset shift.
- Shared hosting performance relies on tuning caching plugins; misconfiguration hurts TTFB.
- Security and plugin updates become a perpetual maintenance tax.
- Plugin sprawl can degrade UX or expose vulnerabilities.

**Implementation Notes**
- Use DomainFactory's one-click installer, then harden: disable default admin user, enforce automatic updates, configure backups.
- Pair with a `.deployignore` that preserves `wp-content/uploads` and other writable directories when syncing from Git.
- Set up a staging environment (separate subdomain) if editors experiment with plugins.

**When to choose**
- Non-technical editors demand the richest WYSIWYG workflow and you accept babysitting updates.
- You need a plugin-heavy feature (memberships, forms) without building custom code.

## Scenario B — Notion Sites

**Snapshot**
- All pages live inside Notion. Publishing is immediate; Notion hosts the site and optionally maps a custom domain.

**Strengths**
- Zero infrastructure. One click publish, instant updates.
- Familiar editor; collaboration and comments inherit Notion's UX.
- Built-in search, sharing, and analytics (with limited knobs).

**Watchpoints**
- Limited layout control; design is constrained to Notion's components.
- Weak SEO controls (meta tags, structured data) compared to SSG stacks.
- Vendor lock-in. Export is possible but messy; no proper version control.
- Custom domains require a paid workspace plan and the Notion Sites add-on.

**Implementation Notes**
- Decide between `*.notion.site` (free) and a mapped custom domain; configure DNS only after confirming the paid tier is active.
- Maintain an outline in Git (`docs/project_docs/project_structure.md`) that points contributors to the canonical Notion space so the repo stays the source of truth for decisions.
- Track the feature roadmap—Notion frequently rolls out updates that may unlock missing capabilities (e.g., nested navigation, SEO metadata).

**When to choose**
- Editorial velocity trumps customization and you're comfortable sacrificing technical ownership.
- You need non-technical collaborators publishing daily without touching Git or CI.

## Scenario C — Ghost on a VPS (plus optional static front-end)

**Snapshot**
- Ghost acts as the blog/CMS, self-hosted on a VPS (e.g., Hetzner). Optional static landing page can live in the same server or GitHub Pages.

**Strengths**
- First-class writing environment with memberships, newsletters, and paid tiers built in.
- Clean default theme, solid editor UX, and manageable theme customization.
- Less bloat than WordPress while retaining a purpose-built CMS.

**Watchpoints**
- Requires VPS administration: provisioning, updates, backups, TLS renewal.
- Ghost expects Node.js + MySQL; DomainFactory shared hosting is unsuitable.
- Theme customization still involves Handlebars templates; deep customizations may require frontend engineering.

**Implementation Notes**
- Follow Ghost's Ubuntu install guide: provision Hetzner CX11/CX21, install via `ghost-cli`, configure NGINX reverse proxy, secure with Let's Encrypt.
- Automate updates: schedule `ghost update` checks, enable unattended-upgrades on the server, and add backup snapshots (Hetzner volumes or offsite).
- If pairing with a static marketing site, deploy that separately (GitHub Pages or Netlify) and link to Ghost for /blog and membership flows.

**When to choose**
- You want an opinionated, writer-centric CMS without WordPress baggage and are comfortable running a small VPS.
- Newsletter/membership monetization is on the roadmap.

## Scenario D — DomainFactory Static Site (rsync deploy)

**Snapshot**
- Static assets live in `public/` inside the site repo and are synchronized to DomainFactory using rsync over SSH.
- GitHub Actions workflow (`templates/DEPLOY_TEMPLATE.md`) drives the deploy; manual uploads use `scripts/deploy.sh` with `deploy.env`.

**Strengths**
- Keeps the hosting footprint in the existing DomainFactory account.
- No runtime dependencies—any static generator can publish into `public/`.
- Full control over HTML/JS/CSS while avoiding WordPress maintenance overhead.

**Watchpoints**
- Editors must commit to Git or hand off changes to someone who can; no GUI CMS.
- DomainFactory shared hosting can bottleneck heavy assets without extra caching/CDN.
- You still manage SSH keys, Secrets, and rsync safety (beware of `--delete`).

**Implementation Notes**
- Configure GitHub Environment secrets (`SSH_HOST`, `SSH_PORT`, `SSH_USER`, `SSH_KEY`, `WEBROOT`).
- Use the workflow template in `templates/DEPLOY_TEMPLATE.md`; copy into the site repo and adjust name/paths.
- Maintain `deploy.env` for local dry-runs via `scripts/deploy.sh` and document the target path in the site README.
- Store upload-only assets (e.g., CMS-managed files) outside the synced path or list them in `.deployignore`.
- Deep dive: `docs/deep_dives/domainfactory_static_site_scenario.md` for current production values and runbook.

**When to choose**
- You want a static site but need it on DomainFactory infrastructure instead of GitHub Pages.
- The authoring workflow is Git-driven (developer-maintained content or generated output).
- You plan to reuse the existing Pipeline from `aaron-kokal.com` as a blueprint.

## Scenario E — Static Site + Decap CMS (GitHub Pages)

**Snapshot**
- Content stored as Markdown/MDX in Git (e.g., Docusaurus, Astro, Jekyll). GitHub Actions builds static output and publishes to GitHub Pages. Decap CMS provides a friendly admin UI backed by Git.

**Strengths**
- Maximum developer control: custom components, MDX, design systems.
- Fast, secure, and cheap—static hosting with automatic HTTPS.
- Transparent version history; easy to migrate elsewhere because content is plain files.
- Decap workflow opens PRs for editor review, supporting preview builds.

**Watchpoints**
- Editors must authenticate via GitHub (unless Git Gateway + Netlify Identity is added).
- CI wiring for previews, media handling, and Decap authentication requires up-front setup.
- GitHub Pages limits build time and storage; large media libraries need an external asset strategy.

**Implementation Notes**
- Configure Decap with the GitHub backend and register a GitHub OAuth app scoped to the repo.
- Add a GitHub Actions workflow that builds the site and publishes to Pages; pair it with a preview workflow (`on: pull_request`) to generate temporary URLs.
- Define an assets strategy: store media under `static/uploads/` committed to Git or point Decap to a third-party store (Cloudinary/S3) if uploads become heavy.
- Document the editorial workflow (create entry → submit for review → preview → merge) in each site's README.
- Detailed rollout plan (starting with talk.aaron-kokal.com): see `docs/deep_dives/jekyll_github_pages_decap_mailcoach_plan.md`.

**When to choose**
- You prioritize long-term portability and a modern component-based stack.
- Editors are willing to authenticate with GitHub or you plan to deploy Netlify Identity.

## Head-to-Head Comparison

| Dimension | WP @ DomainFactory | Notion Sites | Ghost + VPS | DF Static (rsync) | Static + Decap |
| --- | --- | --- | --- | --- | --- |
| Non-technical editor UX | **5** | **5** | 4 | 2 | 4 |
| Developer control/flexibility | 3 | 2 | 3 | 4 | **5** |
| Performance | 3 | 4 | 4 | 4 | **5** |
| Ongoing maintenance effort | 2 | **5** | 3 | 3 | 4 |
| SEO / technical control | 4 | 2 | 4 | 4 | **5** |
| Vendor lock-in (higher = easier exit) | 3 | 1 | 4 | 3 | **5** |
| Up-front setup effort | **5** | **5** | 3 | 4 | 3 |

Scores use 1–5 scale (higher is better). Lock-in reflects the ease of leaving the platform with your content intact.

## Decision Triggers

1. **Who edits the site?**
   - Notion-native collaborators → Scenario B.
   - Comfortable committing Markdown/HTML via Git → Scenario D or Scenario E (with Decap for a friendlier UI).
2. **Operational appetite?**
   - None → Scenarios A or B.
   - Comfortable running a VPS → Scenario C.
3. **Need advanced customization or MDX components?**
   - Yes → Scenario E.
4. **Want memberships/newsletters baked in?**
   - Yes → Scenario C.
5. **Need to ship tomorrow with minimal fuss?**
   - Scenario A (if WordPress is acceptable) or Scenario B.
6. **Must stay on DomainFactory but avoid WordPress?**
   - Scenario D.

## Combining Scenarios

These approaches are not mutually exclusive across the portfolio:
- Marketing sites on Scenario E, while a content-heavy blog or membership product runs on Scenario C.
- A quick prototype can launch in Scenario B, then graduate to Scenario E once the structure stabilizes.
- Scenario A remains a fallback for legacy stakeholders who require WordPress-exclusive plugins.

Document mixed strategies explicitly in each site's README so operators know which workflow applies where.

## Suggested Next Steps

1. Shortlist two scenarios per domain (primary + contingency) and record them in `docs/reports/websites_inventory.md`.
2. For Scenario D adopters, confirm DomainFactory credentials and dry-run the rsync workflow before opening it up to contributors.
3. For Scenario E candidates, start a sandbox repo to wire Decap authentication and GitHub Pages previews once before cloning the setup.
4. For Scenario C, draft the Hetzner provisioning checklist (`ghost_on_hetzner_vps_plan.md` already covers most steps) and identify who owns server upkeep.

Revisit this deep dive whenever tool preferences or editor requirements change; adjust the scenario scoring and notes accordingly.
