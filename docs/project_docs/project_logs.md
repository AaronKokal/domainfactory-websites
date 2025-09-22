---
title: Project Logs
description: Chronological log of decisions and actions for the websites monorepo.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Logs]
categories: [Project]
---

2025-09-17 — Docs Framework Promoted
- Moved `docs/` from `sites-master/` to the workspace root so the documentation framework covers both coordination and site repos.
- Relocated `frontmatter.json` to the root to keep VS Code Front Matter targets in sync with the shared docs.
- Updated `project_structure.md` and `sites-master/README.md` to reflect the new layout.
- Documented static site options for `lab.aron-kokal.com`, emphasizing enhanced Jekyll workflow with Docusaurus as a future alternative.

2025-09-18 — Lab UI Status Checkpoint
- Reviewed current `lab.aron-kokal.com` shell: left rail replaces top navbar, theme toggle cycles system→light→dark, blog cards updated, tags view unified, minimal footer, and local search plugin retained in the main column.
- Logged outstanding UI polish items so the next session can resume quickly (search bar alignment + key hint override, sidebar header/profile wiring, nav highlight edge cases, search component cleanup, and system-mode reset confirmation).

2025-09-18 — Lab Search Polish
- Adjusted layout styles so the search bar anchors to the top-right on wide viewports while expanding full-width on mobile.
- Disabled the visible keyboard shortcut hint by setting `searchBarShortcutHint: false` and hiding the fallback markup to keep the header clean.

2025-09-18 — Lab Sidebar Branding
- Added a dedicated brand header with the smaller lab logo and tagline so the navigation rail starts with "Aaron's Lab" identity.
- Rebuilt the author profile block with a compact avatar and copy to match the refreshed shell spacing.

2025-09-18 — Lab Light-Mode Contrast
- Deepened default body text and secondary copy colors to ensure 4.5+:1 contrast in light mode and shifted link color to the darker periwinkle token.
- Ran `npm run build` to confirm the Docusaurus bundle succeeds with the theming updates.

2025-09-18 — Lab Navigation QA
- Verified that the left-rail nav still flags both "Blog" and "Tags/Categories" as active; highlighting logic needs to enforce a single selection.
- Noted that `/blog/tags` currently renders the mixed cloud/list instead of defaulting to the cloud view, and the categories toggle no longer swaps the layout.
- Sidebar copy duplicates the "Experiments, notes, and prototypes" tagline under both the brand and profile blocks—needs a content split.

2025-09-17 — lab.aron-kokal.com Jekyll POC
- Expanded site Front Matter config to support tags/categories and launch the Jekyll dev server.
- Added shared `_includes/post_list.html`, refreshed homepage/blog templates, and applied minimal styling in `default.html`.
- Created site README outlining local dev and authoring workflow.

2025-09-17 — lab.aron-kokal.com Docusaurus Migration
- Scaffolded Docusaurus classic template under `docusaurus/` using Node 20.
- Removed legacy Jekyll files, ported initial blog post, and rewrote homepage/docs intro to match lab tone.
- Repointed Front Matter config and site README to the new stack; updated Docusaurus config/navigation for the custom domain.
- Clarified GitHub Pages as the hosting target and added an extra test post to validate listings/pagination.
- Replaced the legacy Jekyll GitHub Actions workflow with a Node/Docusaurus build that deploys on push to `main`.

2025-09-17 — lab.aron-kokal.com Auto-Deploy Verified
- Confirmed GitHub Pages workflow builds on push and the live site reflects the Docusaurus migration.

2025-09-17 — Lab Design System Locked In
- Documented the brand palette, accessibility rules, and component recipes in `docs/deep_dives/lab_brand_design_guide.md`.
- Applied the tokenised color scheme to the site (system color mode, updated favicon, trimmed footer links, and refreshed theming).

2025-09-18 — Lab Layout Overhaul Inspired by cefboud.com
- Introduced a persistent left navigation shell with profile, quick links, social icons, and integrated search.
- Swizzled blog list into card-style previews (DD.MM.YYYY dates, tags, author line) and merged tags/categories view.
- Added local search plugin, custom sidebar rendering, and card-focused blog styling to unify docs + posts experience.

2025-09-14 — Initial Monorepo Setup
- Created SSH account `ssh-485413-admin`; added ED25519 key; verified alias `df-admin`.
- Mapped server layout (`/kunden/485413_81379`, projects under `~/webseiten`).
- Decided on monorepo with per-site deploy isolation via GitHub Environments.
- Moved `personal_website` → `sites/aaron-kokal.com`; removed nested `.git`.
- Added top-level docs framework and project docs; moved inventories into `docs/`.
- Added deployment template and wrote root README.

2025-09-14 — First CI/CD Deploy (aaron-kokal.com)
- Created `sites/aaron-kokal.com/public` and added welcome page.
- Added per-site workflow: `.github/workflows/deploy-aaron-kokal.com.yml` (path-filtered, manual dispatch, concurrency).
- Created GitHub Environment `aaron-kokal.com-prod` with secrets: `SSH_HOST`, `SSH_PORT`, `SSH_USER`, `WEBROOT`, `SSH_KEY`.
- Generated CI deploy key; appended public key to server's `~/.ssh/authorized_keys` for `ssh-485413-admin`.
- Resolved runner auth (exit 255) by explicitly using the identity file and validating secrets.
- Result: push to `main` auto-deploys `sites/aaron-kokal.com/public` to `/kunden/485413_81379/webseiten/aaron-kokal.com/public`. Verified live.

2025-09-14 — Meet Subdomain Redirect
- Decision: serve `meet.aaron-kokal.com` via DomainFactory panel redirect to `https://meet.google.com/hev-rsmb-vdg`.
- Action: removed repo-based meet subsite and CI workflow; no code or CI needed for the redirect.

2025-09-16 — Repo Split Prep
- Moved monorepo assets into new `sites-master/` folder and re-scoped Git metadata so coordination repo no longer tracks `sites/`.
- Renamed remote repository to `sites-master` to match new role.
- Updated README and project structure docs to reflect coordination-only responsibilities.
- Created local scaffold `../sites/lab.aaron-kokal.com/index.html` for upcoming standalone repo.
- Shifted deploy workflow into `templates/workflows/deploy-aaron-kokal.com.yml` so future site repos can copy it and run their own automation.

2025-09-19 — lab.aaron-kokal.com Jekyll Migration
- Replaced the Docusaurus workspace with the Chirpy starter (Jekyll, Ruby stack) and removed Node-specific tooling.
- Added new GitHub Pages workflow, README, devcontainer tweaks, and starter content to document the Ruby-based flow.
- Left follow-up tasks to port content, apply the design palette in `_sass`, and capture a Gemfile.lock once Ruby tooling is available locally (host environment lacks Ruby/bundler).

2025-09-19 — lab.aaron-kokal.com Ruby Toolchain Ready
- Installed Ruby/Bundler, ran `bundle install`, and generated the first `Gemfile.lock` for the Jekyll setup.
- Confirmed `bundle exec jekyll b` completes without errors; noted upstream warning to add the `logger` gem before Ruby 3.5.

2025-09-19 — lab.aaron-kokal.com Content Port
- Recreated the prior Docusaurus starter posts inside `_posts/` and added an authors data file for metadata.
- Brought the docs landing copy into a new `_tabs/lab-notes.md` page and adjusted tab ordering to highlight the knowledge base.
- Removed the placeholder in `_posts/` so the blog operates entirely on real content.

2025-09-19 — lab.aaron-kokal.com Brand Palette Applied
- Created `assets/css/jekyll-theme-chirpy.scss` to override the theme's CSS variables with the Forest/Periwinkle/Raisin token set.
- Tuned light/dark color palettes, prompts, and focus states to match the documented accessibility guidance.
- Rebuilt the site with Bundler to confirm the overrides compile cleanly.

2025-09-19 — lab.aaron-kokal.com Platform Roadmap Captured
- Recorded follow-up tasks for CDN-free static assets, Polyglot i18n, and VS Code workflow tweaks per latest action plan.

2025-09-19 — lab.aaron-kokal.com Assets Self-Hosted
- Added the `chirpy-static-assets` submodule under `assets/lib` and flipped `_config.yml` to serve local copies.
- Updated the deployment workflow to checkout submodules so GitHub Actions bundles the vendored assets.
- Verified `bundle exec jekyll b` with the new assets configuration.

2025-09-19 — lab.aaron-kokal.com Polyglot Enabled
- Added `jekyll-polyglot` with English and German locales, including per-language home/pages/posts and consistent `lang`/`ref` identifiers.
- Escaped legacy exclude globs and defined `exclude_from_localization` to keep asset bundles from being duplicated.
- Verified multilingual builds via `bundle exec jekyll b`.

2025-09-19 — lab.aaron-kokal.com Tooling Refresh
- Updated README guidance, devcontainer bootstrap, and VS Code tasks/settings to match the Ruby + Polyglot workflow with CDN-free assets.
- Added workspace excludes for `_site`/cache folders and recommended Ruby/YAML extensions.

2025-09-19 — lab.aaron-kokal.com Social Preview
- Generated `assets/img/social-card.png` using the brand palette and updated `_config.yml` to expose it via Open Graph metadata.
- Verified the build with the new image reference.

2025-09-19 — lab.aaron-kokal.com Logger Gem Added
- Added `logger` to the Gemfile to silence the Ruby 3.5 warning and rebundled the dependencies.
- Verified the site builds cleanly without warnings via `bundle exec jekyll b`.

2025-09-19 — lab.aaron-kokal.com Polyglot Permalinks Fixed
- Normalised EN/DE permalinks for posts and tabs so HTMLProofer no longer flags missing `/de/*` routes.
- Added explicit permalinks for translated pages, cleaned the build output, and reran `htmlproofer` successfully.

2025-09-19 — lab.aaron-kokal.com Front Matter Bridge
- Moved the DE Polyglot posts into `_drafts/` and added `page_id` fields so the live site ships EN-only while staying Polyglot-ready.
- Confirmed `bundle exec jekyll b` remains green; ready to re-enable DE copies once Front Matter supports duplicate permalinks.

2025-09-19 — Front Matter Dashboard Fix
- Removed the trailing comma in the workspace `frontmatter.json` so VS Code parses the content folders again.
- Verified the `lab-posts` registration points to `sites/lab.aaron-kokal.com/_posts` for the dashboard listing.

2025-09-19 — Front Matter Removed
- Uninstalled the Front Matter extension, deleted all `frontmatter.json` configs and `.frontmatter/` caches across the workspace, and dropped the related `.gitignore` entries.
- Restored the framework helper scripts that reference frontmatter utilities so other repos keep their documentation tooling intact.

2025-09-20 — lab.aron-kokal.com Polyglot Permalink Split
- Moved the German post translations back into `_posts/` with `/de/` permalinks so Front Matter sees distinct slugs per locale.
- Updated the DE home and tab pages to live under `/de/*` routes and confirmed `bundle exec jekyll b` completes without errors.

2025-09-20 — lab.aron-kokal.com Front Matter ID Cleanup
- Dropped the `page_id` front matter from EN/DE posts so the VS Code Front Matter extension can rely on the file path without colliding IDs.
- Rebuilt the site via `bundle exec jekyll b` to ensure the change doesn't affect the static output.

2025-09-20 — lab.aron-kokal.com Front Matter Slug Split
- Added explicit locale-aware `slug` values to each post so Front Matter can render the dashboard list without duplicate keys.
- Confirmed the Jekyll build stays green with `bundle exec jekyll b`.

2025-09-20 — lab.aron-kokal.com Permalink Locale Split
- Renamed the German post permalinks to `/de/testbeitrag/` and `/de/zweiter-testbeitrag/` so Front Matter no longer collapses the list keys to the EN slugs.
- Rebuilt via `bundle exec jekyll b` and verified output remains clean.

2025-09-20 — lab.aron-kokal.com Post Localization Reset
- Split posts into `_posts/en` and `_posts/de`, removed `lang`/`ref`/`permalink`/`slug` fields, and left translations optional.
- Deleted German-only tabs/pages, added language defaults in `_config.yml`, and cleared the workspace `.frontmatter` cache to prepare for re-registering folders.

2025-09-20 — Front Matter `ref` Regression
- Attempted to reintroduce shared `ref` values for EN/DE post pairs; VS Code Front Matter dashboard immediately crashed again.
- Rolled back the `ref` additions and confirmed the dashboard recovers, marking `ref` as the trigger to avoid until the extension is patched.

2025-09-20 — lab.aron-kokal.com Post Metadata Restore
- Consolidated posts back into a single `_posts/` directory with explicit `lang`, `permalink`, `slug`, and unique `page_id` values per entry.
- Removed the now-unused language defaults from `_config.yml` and verified `bundle exec jekyll b` still succeeds.

2025-09-20 — lab.aron-kokal.com UI Refresh
- Dropped the "Lab Notes" tab, re-ordered navigation, and swapped the About icon for `fas fa-info-circle`.
- Wired in the new avatar/favicons, updated contact info (LinkedIn, `hi@aaron-kokal.com`), and refreshed social links; build remains green via `bundle exec jekyll b`.

2025-09-20 — About Page Rewrite
- Replaced the placeholder About tab with a first-person overview covering Schallvagabunden, TALK, Kokal Event Support, Festiware, Kokal Coaching, and T–0.
- Fixed the favicon include by moving it to `_includes/custom-head.html`; confirmed `bundle exec jekyll b` stays green.

2025-09-20 — Favicon Include Fix
- Relocated the custom favicon markup to `_includes/head/custom.html` so Chirpy pulls it into `<head>`.
- Rebuilt the site with `bundle exec jekyll b` to verify.

2025-09-20 — Hosting Scenarios Deep Dive & Template Relocation
- Captured the four portfolio hosting setups in `docs/deep_dives/own_websites_setup_scenarios.md` with scoring, triggers, and next-step guidance.
- Merged the GitHub Actions rsync workflow template into `docs/deep_dives/domainfactory_setup_and_deploy.md` and updated references; removed the outdated copy from `sites-master/templates/`.

2025-09-20 — Docs Relocated Into sites-master & DomainFactory Scenario Doc
- Moved the documentation framework into `sites-master/docs` so the coordination repo carries its own docs; updated README and `project_structure.md` accordingly.
- Restored `templates/DEPLOY_TEMPLATE.md` and created `docs/deep_dives/domainfactory_static_site_scenario.md` to document the rsync workflow powering `aaron-kokal.com` (now referenced from the scenarios overview).

2025-09-20 — aaron-kokal.com rsync Deploy Verified
- Updated `scripts/deploy.sh` to locate site repos outside `sites-master` and set executable bit.
- Performed dry-run and live deploy for `aaron-kokal.com` via `scripts/deploy.sh aaron-kokal.com --alias df-admin`; rsync completed without changes beyond confirming current content.
