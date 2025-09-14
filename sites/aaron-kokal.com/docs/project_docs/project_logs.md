---
title: Project Logs
description: Milestones and decisions for the personal website.
date: 2025-09-07T00:00:00Z
draft: false
tags:
  - Logs
categories:
  - ProjectDocs
---

# Logs

*   ✅ Initialized repo with documentation framework (2025-09-07).
    *   Goal: Ultra‑simple static site on `aaron-kokal.com` and utility subdomains (e.g., `meet.aaron-kokal.com`).
*   📝 Decisions captured (2025-09-07):
    *   Meeting room: Use Google Meet via existing Google Workspace; `meet.aaron-kokal.com` will redirect to a standing room. DNS update deferred until domain transfer completes.
    *   CMS: Plan to use Ghost for content distribution later; Phase 1 remains plain static HTML/CSS.
    *   Domain aliasing: For the next 2 years, `kokal.ai` will 301 to `aaron-kokal.com` (apex), and any `SUB.kokal.ai` will 301 to `SUB.aaron-kokal.com` with path/query preserved. Implementation to be chosen post‑transfer (Cloudflare Worker vs Nginx).
