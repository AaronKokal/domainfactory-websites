---
title: Plan — Ghost CMS on Hetzner VPS (Docker)
description: Step‑by‑step execution plan to move a site to a Hetzner VPS running Ghost in Docker with Caddy, MariaDB, backups, and DNS from DomainFactory.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Ghost, Docker, VPS, Hetzner, Migration]
categories: [DeepDive]
---

**Scope**
- Run Ghost 5 on a small Hetzner VPS using Docker and Caddy for TLS.
- Keep current DomainFactory for other sites; point only `aaron-kokal.com` to the VPS.
- Maintain infra-as-code in this monorepo (compose files under `templates/ghost-vps/`).

**Prereqs**
- Hetzner Cloud account and SSH key.
- Mail provider for Ghost (e.g., Mailgun SMTP credentials).

**Sizing**
- Start with CX22/CX32 (2 vCPU, 4 GB RAM recommended for Ghost + DB). Upgrade later via snapshot/resize.

**1) Provision VPS**
- Create Ubuntu 22.04/24.04 server in Hetzner with your SSH key.
- Record the IPv4/IPv6.
- Optional: attach Volume for data (`/var/lib/ghost-data`).

**2) Base Hardening**
- Create non‑root user and grant sudo: `adduser aaron && usermod -aG sudo aaron`.
- SSH hardening: copy your key to `~aaron/.ssh/authorized_keys`; `sudo sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config && sudo systemctl reload sshd`.
- Firewall: `sudo ufw allow OpenSSH && sudo ufw allow 80,443/tcp && sudo ufw enable`.
- Updates: `sudo apt update && sudo apt upgrade -y && sudo apt install unattended-upgrades -y`.

**3) Install Docker + Compose**
- `curl -fsSL https://get.docker.com | sudo sh`
- `sudo usermod -aG docker aaron` then re‑login.
- Verify: `docker version && docker compose version`.

**4) Clone Infra Files**
- `git clone git@github.com:<you>/domainfactory-websites.git ~/infra`
- `cp -r ~/infra/templates/ghost-vps ~/ghost && cd ~/ghost`

**5) Configure Ghost Stack**
- Edit `.env` (create from `.env.example`):
  - `SITE_DOMAIN=aaron-kokal.com`
  - `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD` (strong)
  - `SMTP_USER`, `SMTP_PASS`, `SMTP_HOST`, `SMTP_PORT`, `SMTP_SECURE` (provider‑specific)
- Review `docker-compose.yml` services: `ghost`, `db`, and `caddy` (reverse proxy/TLS).
- Ensure volumes are on durable storage (Volume or disk).

**6) Bring Up The Stack**
- `docker compose up -d`
- Check: `docker compose ps`, `docker logs -f ghost` until “Ghost is running”.

**7) DNS (DomainFactory)**
- In DomainFactory DNS, set:
  - `A @` → VPS IPv4
  - `AAAA @` → VPS IPv6 (if available)
  - `CNAME www` → `aaron-kokal.com` (or A/AAAA too)
- TTL 300 initially; after propagation, raise to 3600.

**8) TLS & Reverse Proxy**
- Caddy auto‑provisions Let’s Encrypt for `SITE_DOMAIN` when DNS points to the VPS.
- Verify: `curl -I https://aaron-kokal.com` returns 200.

**9) Ghost Setup**
- Visit `https://aaron-kokal.com/ghost/` to create the admin account.
- Configure email (SMTP) and basic settings.

**10) Backups**
- DB dump: cron daily `docker exec ghost-db mariadb-dump -uroot -p$MYSQL_ROOT_PASSWORD ghost > /backups/ghost-$(date +%F).sql` (rotate 7 days).
- Content volume: nightly tar of `/var/lib/docker/volumes/ghost_ghost_content/_data`.
- Offsite: sync to Hetzner Storage Box or S3 (rclone/restic). Add healthchecks.

**11) Updates & Lifecycle**
- App update: `docker compose pull && docker compose up -d` (zero‑downtime proxy).
- OS updates via unattended‑upgrades, reboot as needed.
- Logs: `docker compose logs --tail=200 -f caddy ghost`.

**12) Migration From Current Static**
- Option A: Replace static site with Ghost immediately.
- Option B (gradual): Host Ghost at `blog.aaron-kokal.com` first; keep `aaron-kokal.com` static; later switch root to Ghost.
- For redirects, add rules in Caddy.

**13) CI/Docs**
- Keep `~/ghost` under version control (compose files, Caddyfile, scripts). Push changes to this monorepo under `infra/` or a dedicated repo.
- Optional GitHub Action: SSH to VPS to run `docker compose pull && up -d` on tag pushes.

**14) Optional Multi‑Site**
- Add more `ghost` services and `site` blocks in Caddy. Ensure separate DBs and volumes per site. Scale VPS accordingly.

**Acceptance Checklist**
- DNS resolves to VPS; TLS active (Let’s Encrypt).
- Ghost admin reachable; email sends.
- Backups created and offsite copies verified.
- Updates tested; restart survival validated.

