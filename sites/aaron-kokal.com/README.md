---
title: aaron-kokal.com — Site Notes
description: Static site deployed from public/ with monorepo-level docs.
date: 2025-09-07T00:00:00Z
draft: false
tags:
  - Website
  - Static
  - Meta
categories:
  - Project
---

# aaron-kokal.com — Site Notes

This is a static site deployed from `sites/aaron-kokal.com/public`.

Docs policy: All project documentation lives at the monorepo root under `docs/`. This file is the only site‑local place for notes specific to this domain.

Operational details
- Domain: `aaron-kokal.com`
- Server target: `/kunden/485413_81379/webseiten/aaron-kokal.com/public`
- Panel path (Zielverzeichnis): `webseiten/aaron-kokal.com/public`
- Deploy method: rsync over SSH (manual or CI; see repo templates)

Open items
- Replace `public/index.html` with real content.
- Add per‑site `.deployignore` if you introduce build steps or a CMS; otherwise keep the repo minimal.
