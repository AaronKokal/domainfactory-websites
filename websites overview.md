**Overview**
- This document summarizes the current content of the DomainFactory webspace and where each website lives. Paths are shown as absolute server paths (they start at your SSH home `/kunden/485413_81379`).

**Top Level Of Webspace**
- **`/kunden/485413_81379`**
  - `/.ssh` — SSH keys for the admin user (do not touch during deploys)
  - `/errordocs` — web server error pages
  - `/logs` — web logs
  - `/statistik` — stats
  - `/tmp` — temporary files
  - `/webseiten` — projects folder (all sites listed below)
  - `/www` — symlink to `/kunden` (informational)

**Sites Under `webseiten`**

1) **schallvagabunden**
- **Docroot:** `/kunden/485413_81379/webseiten/schallvagabunden`
- **Type:** WordPress (core present under this path)
- **Writable data:** `wp-content/uploads/`, `wp-content/wflogs/`, `wp-content/upgrade/`
- **Deploy target (if deploying full site):** same as docroot above
- **Deploy target (theme-only repos):** `/kunden/485413_81379/webseiten/schallvagabunden/wp-content/themes/<theme>`
- **Panel Zielverzeichnis (relative):** `webseiten/schallvagabunden`

2) **aaronvincent**
- **Docroot:** `/kunden/485413_81379/webseiten/aaronvincent/wordpress`
- **Notes:** Contains a WordPress backup/update directory: `wordpress_1734014929`
- **Panel path:** `webseiten/aaronvincent/wordpress`

3) **kokalcoach**
- **Docroot:** `/kunden/485413_81379/webseiten/kokalcoach/wordpress/wordpress` (nested)
- **Notes:** There is a parent `wordpress` folder and an inner `wordpress` docroot; also has `wordpress_1733827097`
- **Panel path:** `webseiten/kokalcoach/wordpress/wordpress`

4) **kokaleventsupport**
- **Docroot:** `/kunden/485413_81379/webseiten/kokaleventsupport/wordpress`
- **Notes:** Backup dir present: `wordpress_1733908754`
- **Panel path:** `webseiten/kokaleventsupport/wordpress`

5) **talk**
- **Docroot:** `/kunden/485413_81379/webseiten/talk/wordpress`
- **Notes:** Backup dir present: `wordpress_1733909754`
- **Panel path:** `webseiten/talk/wordpress`

6) **midsommarOLD24** (legacy)
- **Docroot:** `/kunden/485413_81379/webseiten/midsommarOLD24`
- **Type:** Legacy site with WordPress present at the root plus many custom folders (e.g., `Anmeldung`, `Bilder`, `lib/*`, `myAdmin`, `qr`)
- **WP uploads tree:** extensive under `wp-content/uploads/<year>`
- **Panel path:** `webseiten/midsommarOLD24`

7) **midsommar**
- **Folder:** `/kunden/485413_81379/webseiten/midsommar`
- **Notes:** Present but contents not enumerated in our snapshot; confirm if in use and where the domain points.

8) **toni**
- **Folders:**
  - `/kunden/485413_81379/webseiten/toni/designhorizon/2305Masterarbeit/wordpress`
  - `/kunden/485413_81379/webseiten/toni/toninton/wordpress`
  - Backup present: `/kunden/485413_81379/webseiten/toni/toninton/wordpress_1733909227`
- **Panel paths:** `webseiten/toni/designhorizon/2305Masterarbeit/wordpress` and `webseiten/toni/toninton/wordpress`

**Backup/Update Folders**
- Several projects contain directories like `wordpress_1733…`. These are likely automatic update or backup copies. Leave them in place unless you verify they can be removed. They should not be deployment targets.

**How To Confirm Domain → Docroot**
- Panel: `Domain → Domain‑Einstellungen → Zielverzeichnis` should match the “Panel path” listed for each site.
- Runtime check per site:
  - `ssh df-admin 'echo OK > ~/webseiten/<site>/.codex-check.txt'`
  - Visit `https://<domain>/.codex-check.txt` and confirm you see `OK`.

**Deployment Targets (Absolute Paths For CI)**
- schallvagabunden: `/kunden/485413_81379/webseiten/schallvagabunden`
- aaronvincent: `/kunden/485413_81379/webseiten/aaronvincent/wordpress`
- kokalcoach: `/kunden/485413_81379/webseiten/kokalcoach/wordpress/wordpress`
- kokaleventsupport: `/kunden/485413_81379/webseiten/kokaleventsupport/wordpress`
- talk: `/kunden/485413_81379/webseiten/talk/wordpress`
- midsommarOLD24: `/kunden/485413_81379/webseiten/midsommarOLD24`
- toni/designhorizon: `/kunden/485413_81379/webseiten/toni/designhorizon/2305Masterarbeit/wordpress`
- toni/toninton: `/kunden/485413_81379/webseiten/toni/toninton/wordpress`

**Recommended .deployignore (WordPress)**
- `wp-content/uploads/`
- `wp-content/cache/`
- `wp-content/upgrade/`
- `wp-content/wflogs/`
- `.git/`, `.github/`
- `*.log`, `.env`

**Notes And Cautions**
- Never deploy to the account root; always target the site’s directory above.
- If a repo is theme-only, point CI to the theme directory instead of the whole site to avoid overwriting WordPress core.
- When in doubt, run an rsync dry-run with `-n` to preview changes.
