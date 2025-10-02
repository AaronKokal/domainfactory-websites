---
title: Setup Guide (Skeleton)
description: 
date: 2025-09-15T15:24:18Z
draft: false
tags: [Setup, Onboarding]
categories: [Framework]
---

## Paths
- Fresh Start Path: apply framework to a new/empty repo or onboard after cloning a repo that already contains the framework.
- Migrate Existing Repo Path: implement framework in a running project.

## Prerequisites
- Git available; repo access.
- Workspace root `AGENTS.md` file (copy `docs/framework_docs/agents.template.md` if you do not already have one).

## Fresh Start Path (Outline)
- Copy core docs (Mission, Structure, Logs, Tasks, AOP, Contract, Maintenance).
- Create `docs/deep_dives/`.
- Fill Mission Intent/Invariants/Non‑Goals; draft Structure routing rules.

Onboard the user (human + agent)
- Explain the framework briefly or offer summaries of:
  - `docs/framework_docs/FRAMEWORK_CONTRACT.md` (law of the land)
  - `docs/framework_docs/FRAMEWORK_PHILOSOPHY.md` (why these rules exist)
  - `docs/framework_docs/AGENT_OPERATING_PROCEDURE.md` (how the agent behaves)
  - `docs/framework_docs/DOCUMENT_MAINTENANCE.md` (how to write and reference docs)
- Update workspace-level agent instructions (e.g., `AGENTS.md`) to reference this repo's framework so every session loads it automatically.
- If your workspace lacks `AGENTS.md`, copy `docs/framework_docs/agents.template.md` to the workspace root and tailor the sections to your org while keeping the framework pointer intact.
- Inform about optional helper scripts in `docs/scripts/` (e.g., front matter helper). Emphasize editors and extensions are optional and the level of structure is up to the team.
- Note: Cloning a repo that already contains this framework also triggers this onboarding step — the structure exists, but the people and agent still need context.

Image approach (decide once for this repo)
- Front Matter CMS static folder: `static/images/...` with absolute links like `/images/...`.
- Local per‑doc images: `images/` subfolders next to docs with relative links.
- Both are supported; pick one for consistency. See Document Maintenance for a short guide on switching later if needed.

Recommended editor extensions (optional)
- Front Matter (manage YAML headers)
- Markdown All in One (authoring features)
- Markdownlint (linting in-editor)
- Prettier (formatting in-editor)
- Path Intellisense (links)
- YAML (schema support)
- MDX (if you use MDX)

## Migrate Existing Repo Path (Outline)
- Inventory current docs and directory intents.
- Create `docs/legacy_docs/` and move existing non-framework documentation there as a staging area (no deletions). Keep commits small and explain WHY.
- Propose mapping from legacy docs to the framework structure (which files map to Mission/Structure/Logs/Tasks/Deep Dives; which are archived).
- With user guidance, move/merge content step by step into the framework docs. Keep Structure updated in the same PR as moves.
- Add Logs entries for notable decisions and reversals. Seed Tasks with follow-ups.

Front Matter headers (Required; tool optional)
- All `.md` files must include a YAML front matter header.
- You may use an editor plugin to add/edit headers, or add them in bulk with:
  - `python3 docs/scripts/add_frontmatter.py --write`
