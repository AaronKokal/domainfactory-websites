# DomainFactory Static Deploy Workflow Template

> This template powers the `aaron-kokal.com` static site deploy and any similar DomainFactory rsync setups. For full documentation see `docs/deep_dives/domainfactory_static_site_scenario.md` and `docs/deep_dives/domainfactory_setup_and_deploy.md`.

**Required GitHub Secrets (per site repo / environment)**
- `SSH_HOST`
- `SSH_PORT`
- `SSH_USER`
- `WEBROOT`
- `SSH_KEY`

**Optional Repository Files**
- `.deployignore` — Exclusion patterns (WordPress example below)
- `deploy.env` — Used by `sites-master/scripts/deploy.sh` for manual pushes

**Workflow Skeleton (`.github/workflows/deploy.yml`)**

```yaml
name: Deploy <your-domain>

on:
  push:
    branches: [ main ]
    paths:
      - 'public/**'
      - '.github/workflows/deploy.yml'
      - 'deploy.env'
      - 'README.md'
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    concurrency:
      group: deploy-<your-domain>
      cancel-in-progress: true
    environment:
      name: <your-domain>-prod
      url: https://<your-domain>
    steps:
      - uses: actions/checkout@v4

      - name: Validate required secrets
        run: |
          test -n "${{ secrets.SSH_HOST }}" || { echo 'Missing secret SSH_HOST' >&2; exit 1; }
          test -n "${{ secrets.SSH_PORT }}" || { echo 'Missing secret SSH_PORT' >&2; exit 1; }
          test -n "${{ secrets.SSH_USER }}" || { echo 'Missing secret SSH_USER' >&2; exit 1; }
          test -n "${{ secrets.WEBROOT }}" || { echo 'Missing secret WEBROOT' >&2; exit 1; }
          test -n "${{ secrets.SSH_KEY }}" || { echo 'Missing secret SSH_KEY' >&2; exit 1; }

      - name: Setup SSH
        env:
          SSH_KEY: ${{ secrets.SSH_KEY }}
          SSH_HOST: ${{ secrets.SSH_HOST }}
          SSH_PORT: ${{ secrets.SSH_PORT }}
        run: |
          mkdir -p ~/.ssh
          echo "$SSH_KEY" > ~/.ssh/id_ed25519
          chmod 600 ~/.ssh/id_ed25519
          ssh-keyscan -p "$SSH_PORT" "$SSH_HOST" >> ~/.ssh/known_hosts

      - name: Test SSH connection
        env:
          SSH_HOST: ${{ secrets.SSH_HOST }}
          SSH_PORT: ${{ secrets.SSH_PORT }}
          SSH_USER: ${{ secrets.SSH_USER }}
        run: |
          chmod 700 ~/.ssh
          chmod 600 ~/.ssh/known_hosts || true
          ssh -i ~/.ssh/id_ed25519 -o BatchMode=yes -o IdentitiesOnly=yes -p "$SSH_PORT" "$SSH_USER@$SSH_HOST" 'echo ok'

      - name: Rsync deploy
        env:
          SSH_HOST: ${{ secrets.SSH_HOST }}
          SSH_PORT: ${{ secrets.SSH_PORT }}
          SSH_USER: ${{ secrets.SSH_USER }}
          WEBROOT: ${{ secrets.WEBROOT }}
        run: |
          rsync -az --delete \
            -e "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes -p ${SSH_PORT}" \
            public/ \
            ${SSH_USER}@${SSH_HOST}:${WEBROOT}
```

**WordPress `.deployignore` Example**

```text
.git/
.github/
.env
*.log
wp-content/uploads/
wp-content/cache/
wp-content/upgrade/
wp-content/wflogs/
```

**Local Dry Run Example**

```bash
rsync -azvn --delete --exclude-from=.deployignore \
  -e "ssh -i ~/.ssh/id_ed25519_df_ci -o IdentitiesOnly=yes" ./public/ \
  ssh-485413-admin@schallvagabunden.de:/kunden/485413_81379/webseiten/<site>/public
```

Adapt the template as needed (build steps, directories) and keep the docs linked above updated when this workflow evolves.
