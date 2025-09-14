**Purpose**
- Copy-paste template for deploying a site from GitHub Actions to DomainFactory via rsync over SSH.

**Required GitHub Secrets (per repo)**
- `SSH_HOST`: `schallvagabunden.de`
- `SSH_PORT`: `22`
- `SSH_USER`: `ssh-485413-admin`
- `WEBROOT`: absolute path to the target on server, e.g. `/kunden/485413_81379/webseiten/schallvagabunden`
- `SSH_KEY`: private key contents for the CI deploy key (create with `ssh-keygen -t ed25519 -C df-ci` and place the public key in `~/.ssh/authorized_keys` on the server)

**Optional Repository Files**
- `.deployignore` — patterns to exclude (see WordPress example below)

**.github/workflows/deploy.yml**

```yaml
name: Deploy

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Add build steps here if needed, e.g.:
      # - run: npm ci && npm run build
      # - run: composer install --no-dev --prefer-dist

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

      - name: Rsync deploy
        run: |
          rsync -az --delete --exclude-from=.deployignore \
            -e "ssh -p ${{ secrets.SSH_PORT }}" ./ \
            ${{ secrets.SSH_USER }}@${{ secrets.SSH_HOST }}:${{ secrets.WEBROOT }}
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

**Dry‑Run From Local (Safety Check)**
- `rsync -azvn --delete --exclude-from=.deployignore -e "ssh -i ~/.ssh/id_ed25519_df_ci -o IdentitiesOnly=yes" ./ ssh-485413-admin@schallvagabunden.de:/kunden/485413_81379/webseiten/<site>`

