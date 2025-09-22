---
title: Jekyll + GitHub Pages + Decap + Mailcoach Plan
description: End-to-end playbook for migrating sites (starting with talk.aaron-kokal.com) to a Jekyll stack on GitHub Pages with Decap CMS, GitHub OAuth bridge on DomainFactory, and Mailcoach forms.
date: 2025-09-20T00:00:00Z
draft: false
tags: [Planning, Jekyll, Decap, Mailcoach]
categories: [DeepDive]
---

> Initial rollout target: **talk.aaron-kokal.com** (currently WordPress). Treat this document as the canonical plan for rebuilding that site and future sites on the same stack.

# Jekyll + GitHub Pages + Decap (DCAP) + Mailcoach — End-to-End Plan

This is the full, hand-offable playbook for standing up a **GitHub Pages–hosted Jekyll site** with a **browser CMS (Decap)** that authenticates via **GitHub OAuth** using a **tiny PHP “bridge” on DomainFactory**, plus a **Mailcoach** newsletter signup form. It includes the why, the how, and the traps.

---

## 0) Intended outcome (what “done” looks like)

* **Public site** served by **GitHub Pages** on your custom domain (DNS at DomainFactory).
* **Content editing** at `/admin/` using **Decap**; collaborators log in with their **GitHub account**. The CMS writes content (Markdown + front matter) to the repo on branches/PRs.
* **Auth bridge** for Decap → GitHub lives on your **DomainFactory** webspace (PHP app).
* **Newsletter signup** embeds a **Mailcoach** form on your site; signups land in your list with double opt-in.
* **Media** starts simple (images in repo). A **Cloudinary** integration is planned and can be flipped on later without re-architecting.

Key constraints & limits you must design within:

* GitHub Pages **builds via Actions**; supports Jekyll well and lets you use most plugins/themes when you build yourself.[1]
* GitHub Pages hard/soft limits: **site ≤ 1 GB; ~100 GB/month bandwidth; repo pushes reject files ≥ 100 MB**. Keep media lean.[2]
* Decap’s **GitHub backend** and **External OAuth** pattern are the supported way to log in via GitHub when you’re not on Netlify.[3]
* DomainFactory hosting gives you **SSH** and **PHP** (fine for a PHP OAuth bridge) and you can enable it in cPanel.[4]
* **Mailcoach** supports **external embedded subscription forms** you paste into your site, with double opt-in.[5]

---

# 1) High-level architecture

```
 Visitor ──▶ yourdomain.tld  ───── GitHub Pages (Jekyll build via GitHub Actions)
                 │
                 ├─▶  /admin/ (Decap SPA) ─┬─▶ Auth via: https://auth.yourdomain.tld (PHP OAuth bridge on DomainFactory)
                 │                         └─▶ GitHub OAuth App (Client ID/Secret)
                 │
                 └─▶  /newsletter (HTML form) ──▶ Mailcoach (external form submission)
```

* **Editors** use `/admin/` → “Login with GitHub” → OAuth bridge returns token to Decap → Decap commits to repo via GitHub API on their behalf.[3]

---

# 2) Step-by-step execution plan

## Phase A — GitHub: repository, Jekyll, Pages, Actions

1. **Create the repo**

* Use a private or public GitHub repo (public is fine for sites).
* Add basic structure:

  ```
  .github/workflows/pages.yml
  _config.yml
  Gemfile
  _posts/
  _pages/
  assets/
  admin/   # Decap lives here
  ```

2. **Pick a Jekyll theme**

* Easiest: use a **remote theme** so you can switch later without vendoring files.
  In `Gemfile`:

  ```ruby
  gem "jekyll", "~> 4.3"
  gem "jekyll-remote-theme"
  ```

  In `_config.yml`:

  ```yaml
  plugins:
    - jekyll-remote-theme
  remote_theme: <owner>/<theme-repo>   # e.g. "mmistakes/minimal-mistakes"
  ```

  Remote themes are a first-class Jekyll feature; enable plugin + set `remote_theme`.[6]

3. **Enable GitHub Pages via Actions**

* Add the official Pages build workflow (minimal Jekyll build). `/.github/workflows/pages.yml`:

  ```yaml
  name: Build & Deploy Jekyll to Pages
  on:
    push:
      branches: [ "main" ]
  permissions:
    contents: read
    pages: write
    id-token: write
  jobs:
    build:
      runs-on: ubuntu-latest
      steps:
        - uses: actions/checkout@v4
        - uses: actions/configure-pages@v5
        - uses: actions/jekyll-build-pages@v1
        - uses: actions/upload-pages-artifact@v3
    deploy:
      runs-on: ubuntu-latest
      needs: build
      steps:
        - id: deployment
          uses: actions/deploy-pages@v4
  ```

  This is GitHub’s supported path for Jekyll → Pages using Actions, which gives you full control of gems/plugins.[7]

4. **Branch protection (optional but wise)**

* Protect `main` (require PR, require checks). Editors can still create content PRs through Decap.

5. **Custom domain**

* In the repo’s **Pages** settings, set your custom domain (e.g., `yourdomain.tld`).
* At DomainFactory DNS:

  * **Apex**: 4 A-records → `185.199.108.153`, `.109.153`, `.110.153`, `.111.153`
  * **www**: CNAME → `<your-username>.github.io`
    These are from GitHub’s docs for custom domains.[8]

---

## Phase B — Add Decap CMS to the site

6. **Drop Decap admin into `/admin`**

* Add files:

  ```
  admin/index.html     # loads the Decap app
  admin/config.yml     # content model + backend + media config
  ```

  Example `admin/index.html`:

  ```html
  <!doctype html><html><head>
    <meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
    <title>CMS</title>
    <script src="https://unpkg.com/decap-cms@^3/dist/decap-cms.js"></script>
  </head><body>
    <script>window.CMS_MANUAL_INIT = false;</script>
  </body></html>
  ```

7. **Configure Decap for GitHub backend**

* `admin/config.yml` (minimal to start):

  ```yaml
  backend:
    name: github
    repo: your-org/your-repo
    branch: main
    base_url: https://auth.yourdomain.tld   # the OAuth bridge (Phase C)

  publish_mode: editorial_workflow

  media_folder: "assets/uploads"
  public_folder: "/assets/uploads"

  collections:
    - name: "blog"
      label: "Blog"
      folder: "_posts"
      create: true
      slug: "{{year}}-{{month}}-{{day}}-{{slug}}"
      editor:
        preview: false
      fields:
        - { label: "Layout", name: "layout", widget: "hidden", default: "post" }
        - { label: "Title", name: "title", widget: "string" }
        - { label: "Publish Date", name: "date", widget: "datetime" }
        - { label: "Body", name: "body", widget: "markdown" }
  ```

  * `backend.name: github` uses GitHub as the content store.
  * `base_url` points Decap to your OAuth bridge (next phase).
  * `publish_mode: editorial_workflow` gives you drafts → review → publish.
    Jekyll+Decap collection settings mirror `_posts` conventions.[3]

---

## Phase C — DomainFactory “Auth bridge” (GitHub OAuth)

**Goal:** host the small server-side piece that exchanges the GitHub one-time code for an access token and hands it back to Decap.

8. **Prepare a subdomain for auth**

* In DomainFactory’s cPanel, create `auth.yourdomain.tld` and enable **SSL** (AutoSSL in cPanel or DF SSL). GitHub requires HTTPS for callback.[9]

9. **Enable SSH**

* In DF’s control panel, enable SSH for the account (you’ll need it to deploy a PHP app and run Composer if required).[10]

10. **Deploy a PHP OAuth provider**

* Use a community PHP provider listed under **Decap → External OAuth Clients** (or any small PHP app that implements GitHub OAuth code exchange and Decap’s expected endpoints). Upload via git/FTP and configure.[11]
* Typical environment (`.env` or config file):

  ```
  OAUTH_CLIENT_ID=xxxxxxxx
  OAUTH_CLIENT_SECRET=xxxxxxxx
  OAUTH_PROVIDER=github
  ALLOWED_REPOS=your-org/your-repo   # optional safety check
  SESSION_SECRET=a-long-random-string
  ```
* If the provider is a modern PHP app, run `composer install` via SSH. DomainFactory managed hosting supports SSH and community guides show Composer usage on DF.[4]

11. **Create a GitHub OAuth App**

* On GitHub: **Settings → Developer settings → OAuth Apps → New OAuth App**.
* Set **Homepage** to your site and **Authorization callback URL** to your provider’s callback (e.g., `https://auth.yourdomain.tld/callback`). Save Client ID/Secret and put them in the provider’s environment. Callback URL ownership is the core security control; keep it HTTPS.[12]

12. **Wire Decap to the bridge**

* Confirm your provider exposes the route Decap expects (often `/oauth/authorize` & `/callback` or a single endpoint documented by the provider).
* Ensure `admin/config.yml` `backend.base_url` points to `https://auth.yourdomain.tld`. Decap’s GitHub backend uses that base URL for the OAuth handshake.[3]

13. **Access control via GitHub**

* Add collaborators (or a team) on the repo. If a user can push to the repo, the Decap GitHub backend lets them edit; if not, they’re stopped at auth/permissions.[3]

**Smoke test:** visit `https://yourdomain.tld/admin/` → “Login with GitHub” → grant permissions → you should land in Decap with your identity and see collections.

---

## Phase D — Mailcoach newsletter signup

14. **Enable external form subscriptions**

* In Mailcoach list settings (self-hosted or SaaS), enable **allow form subscriptions** (aka “Allow POST from an external form” / `allow_form_subscriptions`).[5]

15. **Embed the form**

* From Mailcoach, copy the HTML `<form>` snippet and paste it into a Jekyll include (e.g., `_includes/newsletter_form.html`), then reference that include in your layout or any page. Mailcoach supports **double opt-in** in this flow.[5]

16. **Hygiene & privacy**

* Add a short privacy note under the form (GDPR-style). Keep the form lean: `email` (required), optional `first_name`. Confirm success & error messages render correctly.

---

## Phase E — DNS & TLS (DomainFactory ↔ GitHub Pages)

17. **Point your domain to GitHub Pages**

* Set A records (apex) and CNAME (`www`) as in Phase A, step 5. Verify in GitHub Pages settings that the domain is connected and the certificate is issued.[8]

18. **TLS for the OAuth subdomain**

* Ensure `auth.yourdomain.tld` has a valid certificate (cPanel AutoSSL or DF SSL). Browsers and GitHub will balk at plain HTTP callbacks.[9]

---

## Phase F — Content model & editorial polish

19. **Extend Decap collections**
    Examples to add in `admin/config.yml`:

```yaml
# Static pages
- name: "pages"
  label: "Pages"
  folder: "_pages"
  create: true
  fields:
    - {label: "Title", name: "title", widget: "string"}
    - {label: "Permalink", name: "permalink", widget: "string", required: false}
    - {label: "Body", name: "body", widget: "markdown"}

# Site settings (front matter or data files)
- name: "settings"
  label: "Site Settings"
  files:
    - label: "General"
      name: "general"
      file: "_config.yml"
      fields:
        - {label: "Title", name: "title", widget: "string"}
        - {label: "Description", name: "description", widget: "text"}
```

* Use `files:` collections to safely expose a controlled subset of `_config.yml` knobs to editors (title/description etc.).
* Keep `_layouts` and `_includes` dev-only unless someone on the team can handle HTML/Liquid.

20. **Editorial workflow**

* Keep `publish_mode: editorial_workflow` so Decap creates branches for drafts, triggers a PR, and you publish via merge. (Decap supports preview status hints.)[3]

---

## Phase G — Media now vs later

21. **Now: store images in repo**

* `media_folder: "assets/uploads"`, keep images small (≤ 200–400 KB where feasible).
* Remember: pushes **reject ≥ 100 MB files**; Pages sites **≤ 1 GB** and **~100 GB/month bandwidth**. For anything heavier, plan the migration.[13]

22. **Later: flip to Cloudinary (optional but recommended)**

* Decap ships a **Cloudinary media library** integration; add:

  ```yaml
  media_library:
    name: cloudinary
    config:
      cloud_name: your_cloud
      api_key: your_key
  ```

  Then register the library JS if needed (depending on how you load Decap). This moves asset storage and delivery off GitHub.[14]

---

## Phase H — QA & sign-off checklist

* **Builds**

  * Actions green on `main`.
  * Site renders on `https://yourdomain.tld/` with correct theme assets.
* **Decap**

  * `/admin/` loads; login round-trip works.
  * Create draft post → PR appears → merge → post live.
* **Mailcoach**

  * Submit test email → double opt-in mail received → final confirmation page.[5]
* **DNS/TLS**

  * A/AAAA or A + CNAME correct; cert valid on both **site** and **auth** hostnames.[8]

---

# 3) Reference snippets you’ll actually paste

## 3.1 Jekyll: `Gemfile`

```ruby
source "https://rubygems.org"
gem "jekyll", "~> 4.3"
gem "jekyll-remote-theme"
group :jekyll_plugins do
  gem "jekyll-sitemap"
  gem "jekyll-feed"
end
```

## 3.2 Jekyll: `_config.yml` (starter)

```yaml
title: Your Site
description: Your tagline
url: https://yourdomain.tld
plugins:
  - jekyll-remote-theme
  - jekyll-sitemap
  - jekyll-feed
remote_theme: <owner>/<theme-repo>

collections:
  posts:
    output: true
permalink: /:categories/:year/:month/:day/:title/
```

## 3.3 Decap admin: `admin/index.html`

```html
<!doctype html><html><head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>CMS</title>
<script src="https://unpkg.com/decap-cms@^3/dist/decap-cms.js"></script>
</head><body></body></html>
```

## 3.4 Decap admin: `admin/config.yml` (GitHub backend + editorial workflow)

```yaml
backend:
  name: github
  repo: your-org/your-repo
  branch: main
  base_url: https://auth.yourdomain.tld

publish_mode: editorial_workflow

media_folder: "assets/uploads"
public_folder: "/assets/uploads"

collections:
  - name: "blog"
    label: "Blog"
    folder: "_posts"
    create: true
    slug: "{{year}}-{{month}}-{{day}}-{{slug}}"
    editor: { preview: false }
    fields:
      - { label: "Layout", name: "layout", widget: "hidden", default: "post" }
      - { label: "Title", name: "title", widget: "string" }
      - { label: "Publish Date", name: "date", widget: "datetime" }
      - { label: "Body", name: "body", widget: "markdown" }
```

(If/when moving to Cloudinary, add the `media_library` block per §22.)[14]

## 3.5 GitHub Actions: `/.github/workflows/pages.yml`

```yaml
name: Build & Deploy Jekyll to Pages
on:
  push: { branches: [ "main" ] }
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v5
      - uses: actions/jekyll-build-pages@v1
      - uses: actions/upload-pages-artifact@v3
  deploy:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - id: deployment
        uses: actions/deploy-pages@v4
```

This is the official pattern.[7]

## 3.6 OAuth bridge `.env` (DomainFactory)

```
OAUTH_PROVIDER=github
OAUTH_CLIENT_ID=...
OAUTH_CLIENT_SECRET=...
ALLOWED_REPOS=your-org/your-repo
SESSION_SECRET=change-me
```

(Exact keys depend on the provider you choose; follow its README.)[11]

---

# 4) Operational notes per component (what matters & what breaks)

## GitHub Pages / Jekyll

* **Plugins**: When you **build with Actions**, you can use plugins beyond the “whitelisted” Pages set—because you’re uploading the built site, not letting Pages build. That’s the point of `actions/jekyll-build-pages`.[1]
* **Theme changes**: With **remote_theme**, switching themes is one line in `_config.yml`, then you patch layouts/partials as needed.[6]
* **Limits**: 1 GB site, 100 GB/month soft bandwidth. Keep images optimized; don’t ship videos. Files ≥ 100 MB won’t push.[2]

## Decap CMS

* **GitHub backend** means **no extra database**: content is Markdown in Git. Nice and auditable.[3]
* **Editorial workflow**: non-admins create content branches/PRs; reviewers merge. Keeps quality high.[3]
* **Preview**: You can wire preview links using the `preview_context` if you run a preview build elsewhere; optional.[3]

## OAuth bridge (DomainFactory)

* **Why PHP**: shared hosting runs PHP great; persistent Node servers are not what shared hosting is made for. Use a PHP provider. Decap explicitly documents **External OAuth Clients** (multiple community options).[11]
* **HTTPS** is non-negotiable: GitHub OAuth callback must be HTTPS; ensure cert auto-renewal (cPanel AutoSSL or DF’s included SSL).[9]
* **Composer**: Many DF users run Composer via SSH; if your provider needs it, install per guide.[15]

## Mailcoach

* **External forms**: enable `allow_form_subscriptions` and paste the generated/ documented form markup. Double opt-in is supported.[5]
* **Security**: add a honeypot or time-trap if you see bot noise (Mailcoach docs discuss it); rate-limit at the edge if needed.

## Media (now vs later)

* **Now**: repo images only (optimize hard).
* **Later**: **Cloudinary** media library inside Decap = editors browse/upload via Cloudinary UI; assets delivered by CDN; no repo bloat. Flip by adding `media_library: cloudinary` config.[14]

---

# 5) Risks, guardrails, and non-negotiables

**Auth & security**

* **Callback URL ownership**: In the GitHub OAuth App, set the exact **Authorization callback URL** to your DF bridge (HTTPS). Mismatch or HTTP → broken login or worse.[16]
* **Secret handling**: Client Secret lives **only** on the DF server (`.env`), never in the repo. Lock down file perms. Rotate if leaked.
* **CORS/CSRF**: Your OAuth bridge should verify `state` to prevent CSRF and only accept requests from your domain; use a known provider that implements this properly.[17]
* **Least privilege**: Add only real editors as GitHub collaborators. If you later open to guest authors, use fork-based “open authoring”.

**DNS/TLS**

* **DNS correctness**: A-records for apex + CNAME for `www` point to GitHub; Pages settings show when the cert is provisioned. Don’t mix old records.[8]
* **Auth subdomain** must stay valid with a renewing cert (AutoSSL). Periodically check expiry in cPanel.[9]

**Build & content workflow**

* **Lock `main`**: Require PRs and passing checks. Content merges should be intentional.
* **Staging** (optional): If you want previews, add a second environment or a PR preview action and set Decap’s `preview_context`.[3]
* **Backups**: Git is the source of truth; still, consider weekly repo backups or a mirror.

**Performance & limits**

* **Images**: compress aggressively; serve < 200 KB where possible. Pages has **1 GB** site size and **100 GB/month** soft bandwidth. If you trend high, move media to Cloudinary.[2]
* **Large files**: git pushes **reject ≥ 100 MB**. Don’t check in videos/PSDs. If someone does, the push fails; you’ll need to purge history.[13]

**DomainFactory specifics**

* **SSH must be enabled** per account. If disabled, enable in cPanel first.[10]
* **PHP versions**: If your bridge needs a newer PHP, confirm DF’s PHP-CLI selector and use the correct binary when running Composer.[18]

**Mailcoach & privacy**

* **Double opt-in** on; link your privacy policy under the form.
* **Spam controls**: if needed, add a hidden honeypot field or minimal JS time check (reject < 1s submits).

---

# 6) Execution checklist (the literal to-do list)

1. **Repo & Jekyll**

   * Create repo; add `Gemfile`, `_config.yml`, theme via `jekyll-remote-theme`.
   * Commit `/.github/workflows/pages.yml`. Build succeeds.[7]
2. **Domain**

   * In GitHub Pages settings: set custom domain.
   * In DomainFactory DNS: apex A-records (4 IPs) + `www` CNAME. Wait for cert.[8]
3. **Decap**

   * Add `/admin/index.html` + `/admin/config.yml` with GitHub backend + editorial workflow.[3]
4. **OAuth bridge**

   * Create `auth.yourdomain.tld` in DF, enable SSL (AutoSSL).[9]
   * Upload PHP OAuth bridge; `composer install` if needed.[15]
   * Create **GitHub OAuth App**; set **callback URL**; copy Client ID/Secret into DF `.env`.[12]
   * Test `/admin/` login end-to-end.
5. **Mailcoach**

   * Enable **external form subscriptions**; paste form HTML into Jekyll include; test double opt-in.[5]
6. **Media**

   * Start with `assets/uploads`. Later, add Cloudinary integration to Decap config when needed.[14]
7. **Governance**

   * Protect `main`; add collaborators; document “How to post via Decap” in `CONTRIBUTING.md`.

---

### Final word

This stack gives you **the speed and reliability of static hosting** with **the convenience of a CMS UI**—without WordPress baggage. The only moving part you own is a tiny **OAuth bridge** on your existing DomainFactory space; keep it patched and TLS-valid, and you’re golden. If growth demands it, the **Cloudinary** switch is a config edit, not a platform migration. Keep your content lean, your secrets off Git, and your DNS tidy—the rest is just writing.

[1]: https://jekyllrb.com/docs/continuous-integration/github-actions/?utm_source=chatgpt.com "GitHub Actions | Jekyll • Simple, blog-aware, static sites"
[2]: https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits?utm_source=chatgpt.com "GitHub Pages limits"
[3]: https://decapcms.org/docs/github-backend/?utm_source=chatgpt.com "GitHub | Decap CMS | Open-Source Content Management System"
[4]: https://www.df.eu/de/support/df-faq/webhosting/webspace-zugriff/ssh/?utm_source=chatgpt.com "Secure Shell (SSH) - D-F"
[5]: https://www.mailcoach.app/self-hosted/documentation/v6/audience/using-subscription-forms/?utm_source=chatgpt.com "Using subscription forms | Audience | v6 | Self-Hosted Documentation ..."
[6]: https://github.com/benbalter/jekyll-remote-theme?utm_source=chatgpt.com "GitHub - benbalter/jekyll-remote-theme: Jekyll plugin for building ..."
[7]: https://github.com/actions/jekyll-build-pages?utm_source=chatgpt.com "GitHub - actions/jekyll-build-pages: A simple GitHub Action for ..."
[8]: https://docs.github.com/articles/setting-up-an-apex-domain?utm_source=chatgpt.com "Managing a custom domain for your GitHub Pages site"
[9]: https://docs.cpanel.net/knowledge-base/third-party/the-lets-encrypt-plugin/?utm_source=chatgpt.com "The Let's Encrypt Plugin - cPanel & WHM Documentation"
[10]: https://www.df.eu/de/support/df-faq/aktuelles/managed-hosting-migration/handlungsbedarf/?utm_source=chatgpt.com "Handlungsbedarf - df.eu"
[11]: https://decapcms.org/docs/external-oauth-clients/?utm_source=chatgpt.com "External OAuth Clients | Decap CMS | Open-Source Content Management System"
[12]: https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app?utm_source=chatgpt.com "Creating an OAuth app - GitHub Docs"
[13]: https://docs.github.com/en/repositories/working-with-files/managing-large-files/about-large-files-on-github?utm_source=chatgpt.com "About large files on GitHub - GitHub Docs"
[14]: https://decapcms.org/docs/cloudinary/?utm_source=chatgpt.com "Cloudinary | Decap CMS | Open-Source Content Management System"
[15]: https://gist.github.com/hofmannsven/35d5dc0c837842191d79468803e7a4a2?utm_source=chatgpt.com "Install PHP Composer on Managed Hosting at Domainfactory."
[16]: https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authenticating-to-the-rest-api-with-an-oauth-app?utm_source=chatgpt.com "Authenticating to the REST API with an OAuth app - GitHub Docs"
[17]: https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps?utm_source=chatgpt.com "Authorizing OAuth apps - GitHub Docs"
[18]: https://serversupportforum.de/threads/php-cli-version-ssh-bei-domainfactory-umstellen.61031/?utm_source=chatgpt.com "PHP-CLI-Version (SSH) bei Domainfactory umstellen"
