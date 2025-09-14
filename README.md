Monorepo: DomainFactory Websites

Structure
- `sites/<domain>/` — source for each website. Currently:
  - `sites/aaron-kokal.com/` (migrated from `personal_website/`, now with `public/` deploy root)
- `docs/` — monorepo‑level documentation only
  - `docs/framework/` — immutable framework guides (Agent README, editing rules, etc.)
  - `docs/project_docs/` — living docs: mission, tasks, structure, stack, logs
  - `docs/deep_dives/` — detailed guides (e.g., DomainFactory SSH + deploy setup, CMS strategy)
  - `docs/reports/` — inventories and generated summaries (e.g., websites inventory)
- `scripts/` — helpers (future)
- `templates/` — deployment templates (moved from root `DEPLOY_TEMPLATE.md`)

License
- The monorepo is licensed under MIT at the root `LICENSE`. Individual sites do not carry their own license files; any site‑specific deviations should be stated in the site README.

Getting Started
- Create a new Git repo in this folder and connect to GitHub:
  - `cd domainfactory-websites`
  - `git init`
  - `git add .`
  - `git commit -m "chore: scaffold monorepo + docs"`
  - Create a GitHub repo named `domainfactory-websites` and add the remote:
    - with GitHub CLI (authenticated): `gh repo create domainfactory-websites --public --source . --remote origin --push`
    - or manually: create the repo in GitHub UI, then `git remote add origin git@github.com:<you>/domainfactory-websites.git && git push -u origin main`

Per‑Site Deploys
- Copy the workflow from `templates/DEPLOY_TEMPLATE.md` into `.github/workflows/deploy-<site>.yml` and set the GitHub Environment + secrets for that site.
- Set `WEBROOT` to the absolute target path on the server for the site. See `docs/reports/websites_inventory.md` for canonical paths.

Safety
- Never deploy to the account root; always target the site folder.
- Use a dedicated deploy key per site and scope secrets with GitHub Environments.

Additional Guides
- CMS installation + minimal‑repo strategy: `docs/deep_dives/cms_minimal_repo_strategy.md`

Policy
- Site folders may contain only source code/assets, a `public/` deploy root, and a concise `README.md` with site‑specific notes. All other documentation belongs under the root `docs/` hierarchy.
