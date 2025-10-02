---
title: Workspace Agent Instructions Template
description: Copy this to your workspace root or other high level position as AGENTS.md and customize it while keeping the framework references.
date: 2025-09-15T15:24:18Z
draft: false
tags: [Agent, Template]
categories: [Framework]
---

# Workspace Agent Instructions (Template)

> Customize names, ordering, or additional rules for your workspace, but keep a clear pointer to the docs framework so agents load it every session.

## Docs Framework Awareness
- At the start of any session (or when switching repositories), check whether the repo contains the docs framework: look for a top-level `docs/` directory with `framework_docs/` and `project_docs/` inside. If `docs/framework_docs/AOP.md` or `docs/framework_docs/AGENT_OPERATING_PROCEDURE.md` exists, treat that as the authoritative Agent Operating Procedure for the repo.
- When the AOP is present, read it immediately and obey its mode-detection ritual, stop rules, and anchor requirements. Assume the project expects full compliance unless the user explicitly suspends the framework.
- If `docs/framework_docs/FRAMEWORK_PHILOSOPHY.md` is available, skim it once per repo to refresh intent. Use it for judgment calls when the AOP does not cover a situation directly.

## When the Framework Is Missing or Incomplete
- If the repo lacks the framework directories, ask the user whether to bootstrap it using the t-0 docs framework template before proceeding with substantive work.
- If parts of the framework are present but incomplete (e.g., `project_docs/` missing, obvious placeholders), ask which AOP mode to enter and propose remediation steps before continuing.

## General Conduct
- Default precedence: Workspace instructions → Repo AOP/Contract → User request. If a conflict arises, pause and confirm with the user before acting.
- Keep changes aligned with the framework’s emphasis on anchors, deterministic warm-ups, and documentation hygiene. When editing docs, preserve the structure defined in `docs/framework_docs/DOCUMENT_MAINTENANCE.md` if it exists.
- Log any assumptions or deviations in the project’s `project_logs.md` per the AOP before finishing a task in that repo.
