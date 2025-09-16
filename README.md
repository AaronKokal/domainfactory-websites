Sites Master
===========

Purpose
- Acts as the coordination repo for Aaron Kokal web properties hosted via DomainFactory or GitHub Pages.
- Holds shared documentation (`docs/`), deployment helpers (`scripts/`, `templates/`), and CI configuration that is reused across sites.
- Individual sites live in their **own** Git repositories that may be cloned beside this folder (e.g. `../sites/<domain>`). They are not checked into this repo.

Current Layout
- `docs/` — framework + living project docs (tasks, logs, structure, inventories, deep dives).
- `scripts/` — helper scripts for deploys and maintenance.
- `templates/` — CI/CD workflow blueprints and server configs (workflows now live under `templates/workflows/`).

Working With Site Repos
1. Clone or create the site repository next to this folder, e.g. `../sites/aaron-kokal.com`.
2. Manage site code, builds, and GitHub Pages configuration inside that repo.
3. Update this coordination repo when shared docs, inventory, or templates change.
4. Optionally track site repos as Git submodules here if a manifest is needed, but GitHub Pages builds will not pull submodules.

Bootstrapping a New Site
- Scaffold a new repo under `../sites/<subdomain>`.
- Copy the relevant template from `templates/` (e.g., `templates/workflows/deploy-aaron-kokal.com.yml`, `.deployignore`, etc.).
- Record the site and webroot in `docs/reports/websites_inventory.md` and any task logs.

Notes
- This repository used to contain the `sites/` tree directly; history prior to 2025-09-XX still references those paths.
- Secrets and deploy keys remain scoped per site repository. Use GitHub Environments for production deploys.
