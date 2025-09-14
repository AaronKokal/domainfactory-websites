Monorepo: DomainFactory Websites

Structure
- `sites/<domain>/` — source for each website. Currently:
  - `sites/aaron-kokal.com/` (migrated from `personal_website/`)
- `domainfactory_learnings.md` — Access, SSH, deploy notes.
- `websites overview.md` — Current layout of the server and docroots.
- `DEPLOY_TEMPLATE.md` — GitHub Actions rsync workflow template and `.deployignore`.

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
- Copy the workflow from `DEPLOY_TEMPLATE.md` into `.github/workflows/deploy-<site>.yml` and set the GitHub Environment + secrets for that site.
- Set `WEBROOT` to the absolute target path on the server for the site. See `websites overview.md` for canonical paths.

Safety
- Never deploy to the account root; always target the site folder.
- Use a dedicated deploy key per site and scope secrets with GitHub Environments.

