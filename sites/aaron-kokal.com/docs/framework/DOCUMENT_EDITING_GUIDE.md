---
title: DOCUMENT EDITING GUIDE
description: Guide for editing and maintaining Markdown documentation, focusing on consistency across projects.
date: 2025-08-24T18:00:00Z
categories:
  - Documentation
tags:
  - Markdown
  - Editing
  - Guide
---

## 📖 DOCUMENT EDITING GUIDE

This guide explains how we **edit and maintain Markdown documentation** in our projects, ensuring consistency, reliability, and ease of maintenance. It covers the required document structure, editing rules, and best practices for human collaborators and AI agents.

## Contents

1. **Setup & Environment Preparation**
2. **Requirements (extensions + configs)**
3. **Rules for Maintenance (formatting, structure, images, etc.)**

---

## 1️⃣ Setup & Environment Preparation

1. Clone the repository.
2. Open it in **VS Code (when on Windows, WSL: Ubuntu)**.
3. Install the required extensions listed below.
4. Ensure `.prettierrc` and `.markdownlint.json` exist in the repo:

   * If missing, copy them from another project or ask the user to provide them.
   * These files define the shared formatting and linting rules.

---

## 2️⃣ Requirements

### VS Code Extensions

- Front Matter (id: `eliostruyf.vscode-front-matter`): manages YAML front matter and content folders.
- Markdown All in One (id: `yzhang.markdown-all-in-one`): authoring conveniences.
- Prettier (id: `esbenp.prettier-vscode`): formatting.
- Markdownlint (id: `DavidAnson.vscode-markdownlint`): linting.

After installing Front Matter, open the "Front Matter" panel and verify it recognizes the content folders defined in `frontmatter.json` (`docs/project_docs` and `docs/framework`).

If some Markdown files are missing YAML front matter, you can add minimal headers automatically:

```bash
python3 scripts/add_frontmatter.py --write
```

This script adds `title`, `description`, `date`, `draft`, `tags`, and `categories` to files that do not start with a front matter block.

* **Markdown All in One** → shortcuts, TOC, better editing.
* **Markdownlint** → checks Markdown style (rules in `.markdownlint.json`).
* **Prettier – Code formatter** → auto-formatting for Markdown & YAML (rules in `.prettierrc`).
* **Front Matter** → sidebar for editing YAML front matter (`--- ... ---`).
* **Path Intellisense** → autocomplete for relative file/image links.
* **YAML (Red Hat)** → schema validation for `mkdocs.yml`.
* **MDX (unifiedjs)** → syntax support for `.mdx` files (Docusaurus).
* **Code Spell Checker** → catch typos.
* **EditorConfig** → consistent indentation, line endings, and whitespace.

### Config Files

* `.prettierrc` → defines formatting rules (e.g., line wrapping, quotes).
* `.markdownlint.json` → defines linting rules (e.g., relaxed line length).

---

## 3️⃣ Rules for Maintenance

### Framework vs. Project (Immutability)

Framework documents under `docs/framework/` are read‑only once copied into a project. Do not modify them inside project repositories. If a change is needed, propose it upstream to this framework repository and consume it via an update.

Recommended safeguards (optional for project maintainers):
- CODEOWNERS require approval for `docs/framework/**`.
- CI check blocks PRs that modify `docs/framework/**` outside the framework repo.

### Formatting

* Prettier auto-formats Markdown **on save**.
* Key Prettier setting: `proseWrap: "always"` → avoids giant one-line paragraphs.
* Markdownlint ensures consistent headings, spacing, and lists.
* Common rule relaxations:

  * Disable line-length rule (`MD013`).
  * Allow inline HTML in Markdown (`MD033`).

### Structure

* All docs live under the root `/docs` directory.
* **Core Project Documents** reside in `docs/project_docs/`.
* **Framework Documents** (like this one) reside in `docs/framework/`.
* Use other subfolders as needed (e.g., `docs/img/`, `docs/strategy/`).
* Keep filenames lowercase with underscores, e.g., `project_mission.md`.

### Doc Placement (Decision Tree)

Use this to decide where new or revised content belongs:

- Is it a cross‑project standard or template? → Update this framework upstream (not in a project repo).
- Is it specific to one project and explanatory/how‑to? → Place a single source of truth in `docs/deep_dives/` and link to it from concise sections in `docs/project_docs/` (e.g., stack, tasks, structure). Avoid duplication.
- Is it a short pointer for navigation? → Add a brief note/link in `project_docs` (avoid repeating deep‑dive content).
- Do not create new top‑level doc categories unless agreed by maintainers; prefer extending existing sections.

### Front Matter

* All new Markdown files **must** include a YAML front matter block.
* The required fields and their types are defined in `frontmatter.json`.
* Consult this file to ensure all new documents have the correct metadata structure.

### Images

* Store all images in `docs/img/`.
* Insert with relative links:

  ```md
  ![Alt text](./img/screenshot.png)
  ```

* For Docusaurus projects: images in `static/img/` can be referenced as `/img/...`.

### Maintenance

* Update `project_structure.md` when the repo layout changes.
* Keep docs concise but complete.
* When logs (`project_logs.md`) grow too large, condense old entries while preserving timestamps.
* Project‑level documentation conventions (e.g., where to place deep dives) should live in `docs/project_docs/project_structure.md` as a brief subsection, not as a new standalone policy file. This keeps guidance discoverable and avoids sprawl.

### The Module README: Documenting Subsystems

For any significant, self-contained subdirectory (e.g., a new microservice, a complex feature library, a new `strategy` section), a `README.md` file **must** be placed at its root. This "Module README" serves as the official entry point and a "local context" guide for that subsystem.

A Module README should be concise and answer three key questions:

1.  **What is this? (The "One-Liner")**
    - A single sentence describing the subsystem's purpose.
    - *Example:* "This module handles user authentication via JWTs."

2.  **How do I use it? (The Public API / Contract)**
    - A clear description of the subsystem's inputs, outputs, and public-facing contract. This should not detail the internal implementation.
    - *Example (for an API):* List the key endpoints and their expected payloads.
    - *Example (for a code library):* Describe the main public functions and their arguments.

3.  **Who do I talk to? (Dependencies & Upstream Links)**
    - A list of its explicit dependencies (e.g., "depends on the PostgreSQL database").
    - A link back to relevant high-level project documents (e.g., `../project_docs/project_stack.md`) to provide broader context without duplicating information.

#### Guiding Principles

* **Proactive Maintenance**: You are allowed and expected to edit existing documents if you discover factual errors or if documents fall out of sync with reality. This ensures documentation always reflects the current state of the project. Be careful to preserve original structure and intent.
* **Continuous Logging**: For `project_logs.md`, aim for more granular and continuous updates. Include:
  * Milestone completions (e.g., successful service installs).
  * Challenges faced and solutions found.
  * Learnings from failures, retries, and testing.
    This creates a comprehensive narrative of the project's evolution.

---

## 📂 Required Project Documents

Every project adhering to this framework is required to maintain a set of core documentation files within the **`docs/project_docs/`** directory. This is a **fixed set of documents**, and their `project_*` naming convention signifies their special status.

New documents should not follow the `project_*` naming convention. Instead, they should be placed in appropriate subdirectories (e.g., `docs/strategy/`, `docs/deep-dives/`) or given descriptive names that clearly distinguish them from the core project documents.

The core project documents are:

1.  **`project_mission.md`** → Explains the **"why"** of the project: Goals, pain points it addresses, and expected outcomes.
2.  **`project_stack.md`** → Documents all **tooling and architecture choices** for the project. This includes programming languages, frameworks, libraries, databases, and deployment strategies. Update this as the stack evolves.
3.  **`project_structure.md`** → Provides a readable **repository tree** with short explanations for each directory and key file within the project's repository.
4.  **`project_logs.md`** → Serves as a **project diary**, recording significant events, decisions, problems encountered, and their reasoning. Follow the "Continuous Logging" principles outlined above.
5.  **`project_tasks.md`** → Lists all **prioritized and actionable work tasks** in the active project pipeline. This document is intentionally kept lean to provide clear focus and manage context.
6.  **`project_considerations.md`** → Records **backlog items, far-out future ideas, alternatives considered, and deferred decisions**. This acts as a comprehensive 'parking lot' for thoughts that are not immediately actionable but may be revisited. This document may grow over time.

---

✅ By following this guide, everyone contributes to documentation in the same way — making it **consistent, reliable, and easy to maintain** across projects.
