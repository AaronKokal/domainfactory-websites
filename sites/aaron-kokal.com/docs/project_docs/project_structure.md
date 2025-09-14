---
title: Project Structure
description: Overview of the repository and planned directories for the static site.
date: 2025-09-07T00:00:00Z
draft: false
tags:
  - Structure
categories:
  - ProjectDocs
---

# Repository Structure

*   `/` – Root
    *   `site/` – Static site files (to be created). E.g., `index.html`, `about.html`, `assets/`.
    *   `docs/` – Project documentation (framework + project docs).
        *   `framework/` – Framework templates (read‑only here; propose upstream changes in `t-0_docs_framework`).
        *   `project_docs/` – Mission, stack, structure, tasks, logs, considerations.

# Domains & Subdomains

- Apex: `aaron-kokal.com` → hosts the static site.
- `www.aaron-kokal.com` → CNAME to apex (optional).
- `meet.aaron-kokal.com` → standing meeting room (e.g., Jitsi or redirect to a permanent room URL).
- Future: add simple, purpose‑built subdomains as needed.

