---
title: Framework Philosophy
description: High-level principles and intent behind the documentation framework.
date: 2025-09-15T00:00:00Z
draft: false
tags: [Philosophy]
categories: [Framework]
---

Purpose
- Capture the guiding ideas behind this framework. These are durable principles that inform the concrete rules in the Contract, AOP, and Document Maintenance.
- Assume a higher-order agent instructions file (e.g., workspace-level `AGENTS.md`) exists. That file is the entry point for human intent and must point to this framework whenever the docs system is present in a repo.

Thesis
- Stable, collaborator‑level behavior from an IDE‑embedded LLM comes from explicit purpose, explicit placement, and explicit memory — not orchestration daemons or brittle agent rails.

Why this framework exists
- Humans enter projects carrying context (why, who, non‑negotiables). Agents parachute into repos without it. Code rarely encodes purpose or prohibitions, which is where chaos starts.
- Left alone, an agent adopts defaults (frameworks, online deps, fashionable abstractions) that can conflict with goals, causing divergence, drift, and duplication.

The shift in documentation philosophy
- Traditional advice: keep docs short. With LLMs, verbosity can be useful if organized as layered clarity: concise tops, optional depth, clear anchors.
- Docs become scaffolding that gives agents the same north star humans carry by default.

Core problems to solve
- Context vacuum; session amnesia; overlapping truths; structural drift; re‑trying dead ends; over‑engineering that buries intent.

Design Principles
- Dials, not rails: control behavior with a few adjustable constraints.
- Model‑agnostic: plain Markdown; any LLM can read it.
- Deterministic ritual: consistent warm‑up order; stop on conflict.
- Separation of truths: Mission (intent), Structure (placement), Logs (why), Tasks (next), Deep Dives (exploration).
- Persistence over cleverness: rehydrate state from text at every session.
- Abort early, loudly: surface conflicts instead of pushing through.

Context Asymmetry
- Humans arrive with who/why/constraints; agents arrive “cold.” The framework encodes that missing context so the agent can act like a steady teammate.

Layered Context (Inversion)
- Short tops, optional depth, clear anchors. Long context is fine if the model can find the high‑signal parts.

Human–agent symmetry
- Mission supplies the tacit purpose humans bring.
- Structure supplies the architectural mental model humans infer intuitively.
- Logs supply the remembered narrative humans carry.
- Tasks supply the near‑future intent humans jot down.
- Deep Dives supply counterfactual context: “Didn’t we already decide against that?”

Working Theory (Pragmatism)
- This is a field guide, not dogma. Remove the core and old failures return; add optional layers only when they pay for themselves.

Where to apply these
- Top-level agent instruction files tell the model to load this framework; treat them as upstream of everything written here.
- For rules and precedence: see `FRAMEWORK_CONTRACT.md`.
- For operating steps and stop rules: see `AGENT_OPERATING_PROCEDURE.md`.
- For writing and anchors: see `DOCUMENT_MAINTENANCE.md`.
