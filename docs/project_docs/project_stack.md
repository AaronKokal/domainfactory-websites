---
title: Project Stack
description: Tools and services used to manage and deploy the websites.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Stack]
categories: [Project]
---

Hosting & Access
- DomainFactory shared hosting (SSH v2)
- SSH keys (ED25519) with `~/.ssh/authorized_keys`

Deployments
- GitHub Actions running `rsync` over SSH
- Per‑site workflows with path filters and environment‑scoped secrets

Languages / Stacks On Sites
- WordPress (multiple sites)
- Static HTML/CSS (e.g., aaron-kokal.com)

Key Paths
- SSH home: `/kunden/485413_81379`
- Sites root: `~/webseiten/<site>`
- Typical docroot: `~/webseiten/<site>/public` (static) or site folder root (WordPress)
