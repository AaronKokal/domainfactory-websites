**Purpose**
- Document how to access the DomainFactory webspace over SSH, inspect its contents, and the exact steps we completed to enable key-based access and prepare for safe deployments.

**Account And Host**
- **Customer UID:** `485413`
- **Primary host:** `schallvagabunden.de`
- **SSH user (admin):** `ssh-485413-admin`
- **Home/chroot root:** `/kunden/485413_81379` (your `/` after SSH maps here)
- **FTP root:** identical to SSH home; `/www` is a symlink to `/kunden`

**Key-Based SSH Access (Working)**
- **Local key alias:** `df-admin` in your WSL `~/.ssh/config`
  - Host df-admin
    HostName schallvagabunden.de
    User ssh-485413-admin
    IdentityFile ~/.ssh/id_ed25519_df_admin
    IdentitiesOnly yes
- **Verified login:** `ssh df-admin` → lands at `[ssh-485413-admin@sh23027 ~]$`
- We added your ED25519 public key to `~/.ssh/authorized_keys` on the server and set correct permissions:
  - Server: `mkdir -p ~/.ssh && chmod 700 ~/.ssh`
  - Server: `echo '<your ssh-ed25519 pubkey>' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys`

**Add A Separate CI Deploy Key (Optional, Recommended)**
- Local: `ssh-keygen -t ed25519 -C df-ci -f ~/.ssh/id_ed25519_df_ci`
- Install the public key on server (append to the same file):
  - `cat ~/.ssh/id_ed25519_df_ci.pub | ssh df-admin 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'`
- Test: `ssh -i ~/.ssh/id_ed25519_df_ci -o IdentitiesOnly=yes df-admin 'echo ok'`

**Path Model (Important)**
- After SSH login, `/` is your webspace root: `/kunden/485413_81379`.
- Common system-looking directories exist but are not for you to modify; stay inside your home subtree.
- Projects live under `~/webseiten/<project>`; many are WordPress installations.
- Do not deploy to `/` or `~` directly with `rsync --delete` to avoid touching `~/.ssh`, logs, etc. Always target a project folder (e.g., `~/webseiten/schallvagabunden`).

**Inspecting The Server (Commands You Can Run From Local WSL)**
- Quick info: `ssh df-admin 'echo HOME=$HOME; pwd'`
- Top-level listing: `ssh df-admin 'ls -la ~'`
- Discover projects: `ssh df-admin 'find ~/webseiten -maxdepth 2 -type d -print | sort'`
- Broader snapshot (careful with depth): `ssh df-admin 'find ~ -maxdepth 3 -print | sort'`
- Sizes: `ssh df-admin 'du -h -d 1 ~ | sort -h'`
- Save snapshot locally: `ssh df-admin 'find ~ -maxdepth 3 -print | sort' | tee server-structure.txt`

**Domain → Docroot Mapping**
- In DomainFactory panel: `Domain → Domain‑Einstellungen → Zielverzeichnis`.
- The path is relative to your home, so use values like:
  - `webseiten/schallvagabunden`
  - `webseiten/talk/wordpress`
  - `webseiten/kokaleventsupport/wordpress`
- To verify a mapping, drop a marker file then open it in the browser:
  - `ssh df-admin 'echo OK > ~/webseiten/schallvagabunden/.codex-check.txt'`
  - Visit `https://<domain>/.codex-check.txt`

**What We Accomplished**
- Created SSH account `ssh-485413-admin` with shell `bash`.
- Enabled ED25519 key-based auth from your WSL by placing the public key in `~/.ssh/authorized_keys` on the server.
- Added a convenient local SSH alias `df-admin`.
- Mapped the filesystem layout and identified that all projects live under `~/webseiten`.
- Agreed on safe deployment targeting per site directory (avoid `~`).

**Deployments (Rsync Over SSH)**
- Recommended approach on this host: GitHub Actions → rsync to a specific `WEBROOT`.
- Required repo secrets (GitHub → Settings → Secrets and variables → Actions):
  - `SSH_HOST`: `schallvagabunden.de`
  - `SSH_PORT`: `22`
  - `SSH_USER`: `ssh-485413-admin`
  - `WEBROOT`: absolute server path to the site folder, e.g. `/kunden/485413_81379/webseiten/schallvagabunden`
  - `SSH_KEY`: the CI deploy private key created above
- Minimal workflow (see `docs/deep_dives/domainfactory_setup_and_deploy.md` under "GitHub Actions Workflow Template"):
  - Checks out repo, optionally builds, adds host key with `ssh-keyscan`, then `rsync -az --delete --exclude-from=.deployignore` to `$WEBROOT` over SSH.

**WordPress-Specific Deploy Notes**
- Exclude writable and volatile paths from deploys (place in `.deployignore`):
  - `wp-content/uploads/`, `wp-content/cache/`, `wp-content/upgrade/`, `wp-content/wflogs/`
  - `.git/`, `.github/`, `*.log`, `.env`
- If your repo contains only a theme or plugin, deploy to that subfolder instead of the whole site, e.g. `.../wp-content/themes/<theme>`.

**Safety Checklist**
- Use key auth; keep `~/.ssh` permissions at `700` and `authorized_keys` at `600`.
- Never target `~` or `/` with `--delete`.
- Keep a separate deploy key for CI; revoke by removing its line from `authorized_keys`.
- Create per‑site SSH users when possible; if using a shared admin user, restrict deploys to per‑site directories.

**Handy One‑Liners**
- Verify where you would deploy: `ssh df-admin 'realpath ~/webseiten/schallvagabunden'`
- Dry‑run a local rsync: `rsync -azvn --delete --exclude-from=.deployignore -e "ssh -i ~/.ssh/id_ed25519_df_ci -o IdentitiesOnly=yes" ./ ssh-485413-admin@schallvagabunden.de:/kunden/485413_81379/webseiten/schallvagabunden`

**Next Steps (Optional)**
- Confirm the exact Zielverzeichnis per domain in the panel.
- Add `.deployignore` to each repo (use the WordPress entries above).
- Commit the deploy workflow using the template and set the secrets in GitHub.
