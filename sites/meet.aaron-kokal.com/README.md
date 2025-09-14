---
title: meet.aaron-kokal.com — Redirect
description: Subdomain that redirects to a stable Google Meet room.
---

- Target: https://meet.google.com/hev-rsmb-vdg
- Redirect implementation: `.htaccess` + meta refresh in `public/index.html`.
- Change the target by editing `public/.htaccess` (and index.html for fallback).

Deploy
- Panel Zielverzeichnis: `webseiten/meet.aaron-kokal.com/public`.
- Server path: `/kunden/485413_81379/webseiten/meet.aaron-kokal.com/public`.
- Manual: `bash domainfactory-websites/scripts/deploy.sh meet.aaron-kokal.com --alias df-admin`.
- CI: environment `meet.aaron-kokal.com-prod` (same secrets as the main site, but separate environment).

