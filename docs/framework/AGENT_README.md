---
title: AGENT README
description: Guidelines for AI agents on managing project documentation within the standardized framework.
date: 2025-08-20T18:43:38.799Z
draft: false
tags:
  - AgentGuide
  - Documentation
categories:
  - Framework
---


## 🤖 Agent README

This document serves as your guide as an AI agent operating within our standardized documentation framework. Your primary role is to ensure documentation is consistently structured, maintained, and reflects the current state of the project.

---

## 🚀 Onboarding Protocol: Your First Five Minutes

As an AI agent, your first priority is to rapidly gain context and understand your immediate task. Follow this protocol at the start of every session.

### Step 0: Ensure Front Matter tooling is ready

1. Confirm the VS Code "Front Matter" extension is installed and enabled.
2. Ensure `frontmatter.json` exists at the repo root and that the extension recognizes the content folders (`docs/project_docs`, `docs/framework`).
3. Verify every Markdown file has YAML front matter. If some are missing, run the helper: `scripts/add_frontmatter.py --write` from the repo root to add minimal headers.

4. Guardrails: Do not modify `docs/framework/**` inside project repositories. Framework files are immutable at the project level. If a change seems warranted, propose it upstream to the framework repository instead.

### Step 1: Determine Project State

Your first action is to check the status of the `docs/project_docs/project_tasks.md` file.

- **`read_file('docs/project_docs/project_tasks.md')`**

The result of this check determines your next step.

### Step 2: Follow the Correct Path

#### Path A: The Project is New or In Setup

**If `docs/project_docs/project_tasks.md` is empty or does not exist, your goal is to establish the project's foundation.**

1.  **Read the Mission:**
    - `read_file('docs/project_docs/project_mission.md')`
2.  **Interview the User:**
    - Ask the user what the first high-level goal for the project is.
3.  **Create the First Task:**
    - Based on the user's answer, create the first entry in `docs/project_docs/project_tasks.md`.

#### Path B: The Project is Ongoing

**If `docs/project_docs/project_tasks.md` contains tasks, your goal is to execute the next priority.**

1.  **Identify the Next Task:**
    - Review the contents of `docs/project_docs/project_tasks.md` to identify the highest-priority incomplete task.
2.  **Get Recent Context:**
    - Read the **most recent entry** in `docs/project_docs/project_logs.md` to understand what just happened. This prevents you from repeating failed steps.
3.  **Execute:**
    - Begin working on the identified task. If you need more context on the project's technology or layout, consult `docs/project_docs/project_stack.md` and `docs/project_docs/project_structure.md`.
    - Documentation changes: Apply the Doc Placement Decision Tree from `DOCUMENT_EDITING_GUIDE.md`.
      - Cross‑project standards → propose upstream framework changes.
      - Project‑specific how‑tos → create/extend a single deep dive under `docs/deep_dives/`, and link to it from `project_docs` summaries.
      - Avoid creating redundant files; prefer adding a short “Documentation Conventions (Project)” subsection to `project_structure.md` over new policy files.

---

### Project Documentation vs. Framework Documents

It's crucial to understand the distinction between documentation types:

* **Project Documentation (`docs/project_docs/`)**: These are the "living documents" specific to *each individual project*. Your key responsibility is to check for, create, and maintain these files over time. Ensure each file includes a valid YAML front matter header. The full list of required project documents and their detailed descriptions can be found in the `DOCUMENT_EDITING_GUIDE.md`.

* **Framework Documents (`docs/framework/`)**: These are fixed templates and guides that define the documentation workflow itself. You should familiarize yourself with these files to understand the overarching standards and processes.

  * [`DOCUMENT_EDITING_GUIDE.md`](./DOCUMENT_EDITING_GUIDE.md): This guide explains how to edit and maintain Markdown documentation, and lists all required project-specific files.
  * [`MIGRATION_GUIDE.md`](./MIGRATION_GUIDE.md): Provides instructions for migrating existing project documentation to this framework.
  * [`SYSTEM_BLUEPRINT.md`](./SYSTEM_BLUEPRINT.md): Defines the core technical standards and guiding principles for all projects using this framework.
  * [`PROJECT_README.md`](./PROJECT_README.md): A template for an individual project's root README.

---

## 📋 Responsibilities

As an AI agent, your responsibilities regarding project documentation (`docs/project_docs/` files) include:

* **Check & Create**: Ensure all required project-specific documentation files exist in the `docs/project_docs/` directory. If a file is missing, create a valid first version (interviewing the user if necessary to gather initial content).
* **Create Module READMEs**: When creating a new, significant subsystem (e.g., a new microservice, a new `strategy` folder), you are responsible for creating a `README.md` at its root that follows the **Module README** pattern defined in the `DOCUMENT_EDITING_GUIDE.md`.
* **Adhere to Standards & Maintain**: Follow all Markdown editing, formatting, and maintenance rules as defined in the `DOCUMENT_EDITING_GUIDE.md`. This guide provides comprehensive instructions for keeping all `docs/project_docs/` files updated, consistent, and correctly structured (e.g., frontmatter, log management, structure updates).
* **Respect Framework Immutability**: Never alter `docs/framework/**` in a project repo. Open issues/PRs in the framework repository for any improvements.
* **Explain**: When interacting with human collaborators, ensure tasks related to documentation are clear, referring them to the appropriate guides.
