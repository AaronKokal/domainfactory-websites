---
title: Monorepo Mission
description: Mission for the DomainFactory Websites monorepo managing multiple sites and deployments.
date: 2025-09-14T00:00:00Z
draft: false
tags: [Mission]
categories: [Project]
---

Goal
- Operate and evolve multiple personal websites under one monorepo with consistent docs, safe deploys over SSH, and per‑site CI.

Objectives
- Single source of truth for server access, inventories, and deploy templates.
- Per‑site isolation for deploys and secrets; minimal blast radius.
- Documented, repeatable process for adding a new site and wiring CI.

Success Criteria
- Each active domain has: a `sites/<domain>/public` deploy root, a configured GitHub Environment with secrets, and a green deploy workflow with path filters.
- Inventory and access docs are current and live under `docs/`.
