---
title: Project Stack
description: Minimal stack for a static site + DNS and hosting choices.
date: 2025-09-07T00:00:00Z
draft: false
tags:
  - Stack
  - Hosting
  - DNS
categories:
  - ProjectDocs
---

# Stack & Hosting

## Site
- Phase 1: Static HTML + CSS (no JavaScript by default).
- Phase 2 (planned): Ghost CMS for easy content distribution. Options:
  - Managed Ghost (hosted) with custom domain.
  - Self‑hosted Ghost on a small VPS behind a CDN.
  - Alternatively, use Ghost headless with a static frontend if needed.

## Hosting (pick one)
- GitHub Pages (simple, integrated with repo).
- Cloudflare Pages (fast DNS + CDN; easy custom domains).
- Netlify (similar simplicity).

## DNS
- Primary zone: `aaron-kokal.com` pointed to chosen host (A/AAAA or CNAME as required by Pages provider).
- Secondary zone (alias): `kokal.ai` must mirror the site and subdomains:
  - Apex redirect: `kokal.ai` → `https://aaron-kokal.com` (HTTP 301).
  - Dynamic subdomain mirror: any `SUB.kokal.ai` → `https://SUB.aaron-kokal.com` (preserve path/query).
  - Implementation options (pick one after transfer):
    - Cloudflare (recommended): add both zones, orange‑cloud proxy, and a Worker/Rule to 301 rewrite `*.kokal.ai` → corresponding `*.aaron-kokal.com` with path/query passthrough. Apex handled via Page Rules/Bulk Redirects.
    - Nginx on a tiny VPS: wildcard server_name for `*.kokal.ai` and `kokal.ai`, `return 301 https://$subdomain.aaron-kokal.com$request_uri;` with apex fallback to `https://aaron-kokal.com`.
  - Note: A wildcard CNAME alone cannot rewrite hosts; an HTTP‑level redirect is required to preserve subdomain dynamically.

## Meeting Room (meet.aaron-kokal.com)
- Decision: Use Google Meet (existing Google Workspace) and point the subdomain to a standing meeting URL (redirect or vanity link).
- Implementation deferred until DNS is ready after domain transfer completes.
