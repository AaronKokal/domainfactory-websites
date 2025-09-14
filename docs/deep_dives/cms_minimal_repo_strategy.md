---
title: CMS Install & Minimal Repo Strategy
description: How to install a CMS on DomainFactory and keep only the relevant parts in the monorepo.
date: 2025-09-14T00:00:00Z
draft: false
tags: [CMS, Operations, Standards]
categories: [DeepDive]
---

Principles
- Keep the repository focused on your custom code and configuration templates. Avoid committing vendor/core files or mutable runtime data.
- Use rsync deploys with an exclude list so uploads, caches, and logs are never overwritten.
- Prefer a `public/` subfolder per site as the server docroot; keep docs and tooling alongside but outside `public/`.

Install On DomainFactory (generic PHP CMS)
1) Create a site folder and docroot
   - SSH: `ssh df-admin 'mkdir -p ~/webseiten/<site>/public'`
   - Panel: Domain → Domain‑Einstellungen → Zielverzeichnis = `webseiten/<site>/public`
2) Upload or install the CMS core
   - Option A (one‑click/installer ZIP): Upload to `public/`, run installer, then remove installer files.
   - Option B (Composer‑based CMS):
     - If Composer available on host: `cd ~/webseiten/<site> && composer create-project <package> public`
     - If not: build locally and upload only built `public/` artifacts.
3) Database & config
   - Create DB via panel; store credentials outside of repo (e.g., `.env` on the server or panel config).
   - In repo, keep a template (e.g., `.env.example`, `config.example.php`) but never the real secrets.

What To Track In The Repo
- Custom theme/templates and site‑specific code
  - Example (WordPress): `wp-content/themes/<your-theme>/`, `wp-content/mu-plugins/<yours>/`
  - Example (Craft/Statamic): `templates/`, `config/` (without secrets)
- Public assets that you author (CSS/JS/images) — ideally built into `public/`
- Deploy config: `.deployignore` for the site, deploy scripts if any
- Documentation for the site (`sites/<site>/README.md`)

What NOT To Track
- CMS core files distributed by vendor
- `vendor/` (if Composer installs happen on server); if you must commit it, do so only in a build artifact, not in source
- Mutable directories: uploads, caches, logs, compiled runtime files

Recommended `.deployignore` (start here, adjust per CMS)
```
.git/
.github/
.vscode/
.frontmatter/
docs/
README.md
LICENSE
frontmatter.json
*.log
.env*
node_modules/
build/
dist/
vendor/        # if Composer install happens on the server
storage/       # common writable path (Craft/Statamic)
uploads/       # common upload path
wp-content/uploads/   # WordPress example
``` 

Deploy Flow (Rsync over SSH)
1) Build locally (if applicable) so `public/` contains deployable files.
2) Dry‑run:
   - `rsync -azvn --delete --exclude-from=.deployignore ./sites/<site>/public/ ssh-485413-admin@schallvagabunden.de:/kunden/485413_81379/webseiten/<site>/public`
3) Deploy:
   - Remove `-n` to apply changes.

Updates & Maintenance
- CMS core updates: run via the CMS updater on the server or via Composer SSH session; these changes do not touch your repo.
- Backups: enable host backups and optionally script periodic dumps of DB and uploads to offsite storage.
- New site: copy a starter structure under `sites/<domain>/` with `public/`, `README.md`, `.deployignore`.

