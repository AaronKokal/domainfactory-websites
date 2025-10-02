---
title: Framework Contract — v2025.09
description: 
date: 2025-09-15T15:24:18Z
draft: false
tags: [Contract, Policy]
categories: [Framework]
---

Purpose
- Define the compact law of the land so humans and agents can act consistently.
- Keep this terse; link to detail in other framework docs.

Inventory & Roles
- Workspace agent instructions (e.g., `AGENTS.md`) — Highest-level behavior contract; points agents to this framework and any org defaults.
- `docs/project_docs/project_mission.md` — Purpose. Holds Intent, Invariants (MUST/MUST NOT), and Non-Goals.
- `docs/project_docs/project_structure.md` — Placement. Directory intents, routing rules, and aliases.
- `docs/project_docs/project_logs.md` — Memory. Consequential history with ISO 8601 Z timestamps; immutable entries.
- `docs/project_docs/project_tasks.md` — Near‑term plan. Current / Next / Later.
- `docs/deep_dives/` — Optional long context; index in Structure; referenced on demand.
- `docs/framework_docs/AGENT_OPERATING_PROCEDURE.md` — Deterministic warm‑up, stop rules, plan/placement/output rules.
- `docs/framework_docs/DOCUMENT_MAINTENANCE.md` — Formatting and hygiene to keep docs machine‑parsable.
- `docs/framework_docs/SETUP_GUIDE.md` — Fresh start and migration paths.
- `docs/framework_docs/ORG_CONTEXT.md` — Org/team‑level invariants above any project.

Precedence (highest → lowest)
Workspace Agent Instructions → `ORG_CONTEXT` → Mission → Structure → Logs → Tasks → Deep Dives → README → code comments.

Anchors
- Use anchors to cite rules and context in plans, commits, and PRs. The exact formats and examples are defined in `docs/framework_docs/DOCUMENT_MAINTENANCE.md`.

Change Rules
- New top-level directory requires a Structure update in the same PR.
- Reversal or key learning requires a Logs entry.
- Closing a Task requires linking Logs and/or PR.

Refusals (Stop at this boundary)
- If a requested change conflicts with a Mission invariant, stop and propose a Mission update PR.
- If a PR adds a top-level directory without a Structure update, request changes.

Operating Notes
- Agents must obey workspace agent instructions first, then follow AOP (Agent Operating Procedure) startup order and cite anchors in ephemeral plans and commits.
- Maintenance rules ensure consistent parsing and rendering; see `DOCUMENT_MAINTENANCE.md`.
- Framework docs are typically upstream-managed. Within project work, edit them only when necessary and with clear justification; prefer proposing changes upstream when possible.

Optional Editor Tooling
- Teams may use local editor extensions and helpers (front matter editors, Markdown authoring/linting/formatting). Use them individually or share selected configs in-repo if desired.
- By default, `.gitignore` assumes individual use and ignores these local artifacts. If your org wants to share configs, remove the relevant ignore lines and commit the chosen files.
