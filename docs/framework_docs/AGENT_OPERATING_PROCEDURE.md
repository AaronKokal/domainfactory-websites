---
title: Agent Operating Procedure (AOP)
description: 
date: 2025-09-15T15:24:18Z
draft: false
tags: [Agent, AOP]
categories: [Framework]
---

Purpose
- Provide a deterministic, context-aware way for an IDE-embedded agent to act.
- Keep behavior stable with clear stop rules and quoted anchors.

Read Me First
- Upstream contract: Workspace-level agent instructions (e.g., `AGENTS.md`) take precedence. They should direct you here; confirm there is no conflict before proceeding.
- Invocation: When a user says "see AOP" (or similar), read this document and execute the procedure below. Treat this file as the authoritative operating procedure.
- The correct mode depends on project context. Before acting, detect the mode and follow its path. When in doubt, ask the user to confirm the mode.

Modes & Entry Conditions
- Mode A — Fresh/Initializing or Onboarding
  - Signal: Framework just copied; `docs/project_docs/` exists but core docs are empty or missing.
  - Also: Repo was just cloned and already contains the framework; the structure exists, but the user and agent need context.
  - Actions:
    - Inform user about `docs/framework_docs/SETUP_GUIDE.md` (Fresh Start path) and request decisions where required. Offer short summaries of the Framework Contract, AOP, and Document Maintenance.
    - Create minimal skeletons in `docs/project_docs/`: `project_mission.md`, `project_structure.md`, `project_logs.md`, `project_tasks.md`, plus `project_stack.md`.
    - Seed Mission with placeholders for Intent, Invariants (MUST/MUST NOT), Non‑Goals.
    - Add initial Logs entry describing the baseline and next step. Seed Tasks with one Current and up to two Next items.
    - Produce a short plan and ask for confirmation before major structure decisions.

- Mode B — Migrating an Existing Project (framework deployed into a mature repo)
  - Signal: Codebase and structure exist; framework docs recently added or incomplete.
  - Actions:
    - Inform user about `docs/framework_docs/SETUP_GUIDE.md` (Migrate Existing Repo path). Ask clarifying questions early to save time.
    - Inventory top-level directories; infer Directory Intents and Aliases. Propose Structure mapping (canonical locations) for user review.
    - Draft Mission from README, commit messages, and observed constraints; mark uncertain items and ask to confirm.
    - Create/update Structure with Routing Rules and Aliases. Do not physically move files without explicit approval.
    - Write initial Logs entries for discovered decisions, reversals, and risky assumptions. Update Tasks with Current/Next items.
    - On approval, perform safe moves/renames; update Structure in the same PR.

- Mode C — Normal Session Start (project has properly applied the framework)
  - Signal: Core docs exist and look populated.
  - Actions: Run the Deterministic Warm‑Up (below). Produce an ephemeral plan citing anchors. If any stop rule triggers, pause and propose minimal doc updates or a PR.

- Mode D — Mid‑Session Refresh / Maintenance
  - Signal: You’re pointed to AOP during work; context may be stale or routine maintenance is needed.
  - Actions: Re-run a light Warm‑Up (skim Mission/Structure, latest Logs/Tasks). Perform maintenance: update Tasks status, add Logs for decisions or dead ends, adjust Structure if placement changed. Prepare a concise commit.

- Mode E — End of Session
  - Signal: User indicates the session is ending.
  - Actions: Update Tasks (DONE/BLOCKED; link Logs/PRs). Add a short Logs entry for any decision made. Ensure Structure reflects any tree change. Prepare and push a concise commit.

Deterministic Warm‑Up (Mode C baseline)
1) Mission — Read `docs/project_docs/project_mission.md`.
2) Structure — Read `docs/project_docs/project_structure.md`; restate Directory Intents, Routing Rules, and Aliases.
3) Logs — Read the last 7 days (or ~15 entries) of `docs/project_docs/project_logs.md`; list key Decisions with anchors.
4) Tasks — Read `docs/project_docs/project_tasks.md`; summarize Current/Next/Later; reconcile with recent Logs.
5) Git Digest — Summarize recent commits (e.g., last few days or N commits). Prefer entries that include clear context (WHY/REFS/IMPACT). If available, you may use the optional helper script under `docs/scripts/`.
6) Deep Dives — If referenced by Tasks/Logs/commits and clearly relevant to current tasks, read only those under `docs/deep_dives/` and capture their Status and Summary.

Rules of Engagement
- Plan Rule: Every proposed action must cite ≥1 anchor from Mission/Structure/Logs/Tasks or a referenced Deep Dive.
- Placement Rule: For each new/changed file, quote the relevant Structure rule in `docs/project_docs/project_structure.md` . If no rule exists, propose one.
- Precedence: Workspace Agent Instructions → `ORG_CONTEXT` → Mission → Structure → Logs → Tasks → Deep Dives → README → code comments (see `FRAMEWORK_CONTRACT.md`).
- Stop Rules:
  - Invariant conflict (Mission) — stop and propose a Mission update PR if intent changed.
  - New top‑level directory without Structure update — request changes, propose the minimal rule.
  - Secrets detected in Logs or docs — stop; remove; propose secure handling.
- Output Contract: Produce a short ephemeral plan and include the exact anchors you are obeying. For code/doc changes, prepare a clean commit referencing anchors (WHY/REFS/IMPACT).

Maintenance & Hygiene
- Keep docs machine‑parsable and human‑readable; see `docs/framework_docs/DOCUMENT_MAINTENANCE.md`.
- Use MUST/MUST NOT language for enforceable rules in Mission and Structure.
- Logs are immutable history; reversals are new entries with links.
- Cap Tasks “Later” list (~6) to avoid backlog bloat; promote to Deep Dives when research grows.

Commit/PR Guidance (no fixed template)
- Commits should explain WHY the change is needed (tie to Mission/Logs/Tasks), include references when relevant (e.g., log/task/deep‑dive anchors), and briefly note impact (dirs, size, operational effects).
- PRs should ensure docs match changes: update Structure if placement changed, add Logs entries for significant reversals/decisions, and link closed Tasks.

Compatibility Notes (v1.1 ↔ v1.2)

- Front Matter & Tooling:
  - v1.1 relied on YAML front matter and the Front Matter extension; scripts exist to add headers and track content folders.
  - v1.2 aims to be model‑agnostic with plain Markdown. Treat front matter as optional; do not depend on it for behavior.
- Framework Docs Naming:
  - v1.1: `AGENT_README.md`, `DOCUMENT_EDITING_GUIDE.md`, `MIGRATION_GUIDE.md`, `SYSTEM_BLUEPRINT.md`.
  - v1.2: `AGENT_OPERATING_PROCEDURE.md`, `FRAMEWORK_CONTRACT.md`, `DOCUMENT_MAINTENANCE.md`, `SETUP_GUIDE.md` (migration folded into setup), and optional `ORG_CONTEXT.md`.
- Immutability:
  - Both versions treat framework docs as immutable within project repos; propose changes upstream.
- System Blueprint:
  - v1.1’s `SYSTEM_BLUEPRINT.md` (e.g., Docker policy) may move to `ORG_CONTEXT.md` or a Deep Dive. Keep references minimal unless required by the org.

Escalation
- If any ambiguity remains after mode detection, ask the user to select Mode A/B/C/D/E and proceed accordingly.
