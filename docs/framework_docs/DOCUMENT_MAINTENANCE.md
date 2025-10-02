---
title: Document Maintenance
description: 
date: 2025-09-15T15:24:18Z
draft: false
tags: [Docs, Maintenance]
categories: [Framework]
---

Purpose
- Define how we write and reference documents so they remain stable, machine-parsable, and easy to navigate by humans and agents.
- Assume workspace-level agent instructions route contributors here; keep everything predictable so those upstream directives stay valid.

Filenames and Placement
- All project living docs reside under `docs/project_docs/` with lowercase underscore names (e.g., `project_mission.md`).
- Framework docs reside under `docs/framework_docs/` with clear, capitalized names.
- Long‑form context lives under `docs/deep_dives/` and is referenced on demand.

Subsystem READMEs (when projects grow)
- For complex areas, add a `README.md` inside specific directories (e.g., `src/feature_x/README.md`) to capture local context and decisions.
- These files extend the core framework docs for that subsection; keep them consistent with Mission/Structure. Link them from `project_structure.md` if helpful.

Headings and Style
- Use short, descriptive headings; prefer one sentence per bullet.
- Use MUST/MUST NOT language for enforceable rules (Mission, Structure).
- Keep “Later” in Tasks brief (~6 items) to avoid backlog bloat.
 - Keep docs well formatted to aid readability and small diffs.

Images
- If you use Front Matter CMS, follow its media guidance exactly:
  - Configure the static/public folder to `static/` in your workspace settings.
  - Store documentation images under `static/images/` (for example: `static/images/docs/...`).
  - Insert images via the CMS UI so it writes correct paths and metadata. Links typically look like `/images/...` when using a static folder.
- If you don’t use Front Matter, place images next to their docs under an `images/` subfolder and use relative links. Examples:
  - `docs/project_docs/images/<topic>/*`
  - `docs/deep_dives/images/<topic>/*`
 - Both approaches are valid. Prefer choosing one per org/repo for consistency.

Switching image approaches (short guide)
- From local relative images → Front Matter static folder:
  - Move images from `docs/**/images/...` into `static/images/...` (preserve subpaths when possible).
  - Update Markdown links from relative paths to `/images/...` (Front Matter will resolve under `static/`).
  - Optionally use your editor's find/replace to bulk‑update paths; validate a few pages after.
- From Front Matter static folder → local relative images:
  - Copy images from `static/images/...` next to their related docs under `docs/**/images/...`.
  - Update Markdown links from `/images/...` to relative paths (e.g., `./images/...` or `../images/...`).
  - Remove unused files from `static/images/` when confident.

Anchors (Conventions)
- Purpose: anchors let agents quote exact rules/context in plans, commits, and PRs.
- Mission invariants: `mission#inv-<slug>`
  - Example: `mission#inv-offline`
- Structure rules/intents: `struct#<section>-<slug>`
  - Example: `struct#routing-test-mirroring`
- Log entries: `log:<ISO8601Z>`
  - Example: `log:2025-09-10T14:22Z`
- Tasks: `task:<slug>`
  - Example: `task:offline-date-canary`
- Deep dives: `dd:<slug>`
  - Example: `dd:offline-strategies`

Logs
- ISO 8601 Z timestamps; one event per entry; do not rewrite history. Add reversals as new entries.

Tasks
- Sections: Current / Next / Later. Mark `[IN PROGRESS]`, `[DONE]`, or blockers inline; link to Logs/PRs when closing.

Cross‑Referencing
- Prefer relative links between docs when helpful; always include an anchor in commit messages (WHY/REFS/IMPACT) for traceability.

Front Matter (Required header; tools optional)
- All Markdown files must begin with a YAML front matter header.
- Tools are optional:
  - Your editor may provide a plugin to author and edit headers.
  - Or run the helper script to add headers in bulk: `python3 docs/scripts/add_frontmatter.py --write`.
 - Follow-up: After adding headers, the agent should propose reasonable `tags` and `categories` for each doc.

 
