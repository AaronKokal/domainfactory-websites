---
title: DOCUMENTATION FRAMEWORK MIGRATION GUIDE
description: Guide for agents to migrate existing project documentation to the standardized framework.
date: 2025-08-25T17:40:00Z
draft: false
tags:
  - Migration
  - AgentGuide
  - Documentation
categories:
  - Framework
---

## 📚 DOCUMENTATION FRAMEWORK MIGRATION GUIDE

This guide provides instructions for an AI agent to **migrate an existing project's documentation structure** to align with the standardized documentation framework. Existing projects may have varying documentation layouts, which must be carefully transformed.

## 🏁 Step 0: Bootstrapping the Framework

This crucial initial step ensures that the necessary framework files and configurations are present in the target project.

1. **Check for `docs/framework/`**: Verify if a `docs/framework/` directory already exists in the target project's root.
2. **Create `docs/framework/`**: If it doesn't exist, create this directory.
3. **Copy Framework Files**: Copy all the essential template files from *this* repository's `docs/framework/` directory into the target project's `docs/framework/` directory. This includes:
    * `AGENT_README.md`
    * `DOCUMENT_EDITING_GUIDE.md`
    * `MIGRATION_GUIDE.md` (this very file)
    * `PROJECT_README.md`
    * `SYSTEM_BLUEPRINT.md`
4. **Copy `frontmatter.json`**: Copy `frontmatter.json` and `.frontmatter/` from this repository's root to the root of the target project (or verify their presence). This ensures the Front Matter extension configuration is available.
5. **Confirm Setup (User Checkpoint)**: Confirm with the user that these framework files have been successfully copied. This setup ensures that subsequent steps, especially those involving `frontmatter.json` and linter configurations, operate correctly within the target project's environment.

## 🎯 Your Core Task

Your primary task is to **transform an existing project's documentation** (`docs/` folder contents or similar) to conform to this framework's structure and naming conventions. This requires a meticulous comparison and a cautious execution process.

## 🔍 Step 1: Analyze and Compare Existing Structure

Before any changes are made, you must thoroughly understand the current documentation setup of the target project.

1. **Identify Equivalent Files:** Compare the existing documentation files located in the target project with the required files of our framework, as detailed in the `DOCUMENT_EDITING_GUIDE.md`.
    * **Goal**: Determine which existing files correspond to our framework's documents.
    * **Method**: Read the content of the existing files to understand their purpose, even if their names don't match our conventions.

2. **Identify Missing Files:** Determine which framework documents are entirely absent in the existing project.
    * **Goal**: Note any gaps that will need to be filled.

3. **Identify Extra Files:** Identify any documentation files in the existing project that do not have a direct counterpart in our framework.
    * **Goal**: Understand residual content that may need to be integrated or archived.

4. **Identify Deviations in Naming/Location:** Pinpoint all files that have similar content but different names or are located outside a logical `docs/` structure.

5. **Assess Existing Frontmatter/Formatting:** Briefly review a sample of existing Markdown files to understand their current frontmatter (if any) and general formatting style.

## 🗺️ Step 2: Plan the Transformation (Crucial Step - User Checkpoint)

Based on the analysis, you must formulate a detailed transformation plan. This plan **MUST** be presented to the user for review and approval.

1. **Map Existing to New:** Propose a clear mapping for renaming and moving existing files to their new, standardized locations (e.g., `old_folder/legacy_faq.md` -> `docs/project_mission.md` if content is synonymous).
2. **Plan for Missing Files:** Outline how missing required framework files will be created (e.g., "Create a blank `docs/project_tasks.md` and instruct user to populate").
3. **Handle Extra Files:** Propose how to address extra files (e.g., "Integrate content of `old_api_endpoints.md` into `docs/project_stack.md`" or "Move `notes/random_thoughts.md` to `docs/project_considerations.md`"). For files with no clear mapping, propose archiving them or asking the user for clarification.
4. **Address Naming/Location Conflicts:** Explicitly list all files to be renamed or moved and their new paths.
5. **Highlight Risks:** This is critical. Actively identify and articulate potential problems or risks associated with the transformation.
    * **Data Loss Risk**: Any direct content overwrites, loss of version history, or potential misinterpretation of content.
    * **Ambiguity**: Cases where an existing file's purpose is unclear or could logically map to multiple framework documents.
    * **Complexity**: Transformations that are unusually complex or may require significant manual intervention from the user after your actions.
    * **Unforeseen Side Effects**: Any known build system dependencies or external references that might break due to file renames/moves.

**You MUST wait for explicit user approval before proceeding to Step 3.**

## 🛠️ Step 3: Execute Transformation with Care (User Checkpoints Recommended)

Upon user approval, you will execute the transformation.

1. **Backup (Implicit):** Remind the user (or ensure they are aware) that version control (Git) provides a robust backup.
2. **Create New Directories:** Create `docs/` and any necessary subdirectories (`docs/img/`) if they don't exist in the target project.
3. **Rename/Move Files:** Execute the proposed renames and moves according to the plan.
4. **Create Missing Files:** Create empty versions of any framework documents that were missing, optionally adding a placeholder content indicating they need to be populated.
5. **Verify Structure:** After changes, list the new `docs/` directory contents to confirm the structure matches the framework.

**You MUST seek user confirmation after significant batches of changes or if any unexpected error occurs.**

## ✅ Step 4: Final Verification and Clean-up

1. **Confirm Linting/Formatting:** Ensure all new and modified Markdown files adhere to the standards outlined in `docs_framework/DOCUMENT_EDITING_GUIDE.md`. Perform typical linting and formatting fixes, or guide the user on how to apply them.
2. **Review Content:** Prompt the user to review the transformed content for accuracy and completeness. Highlight areas where content was merged or potentially altered.
3. **Remove Obsolete Files/Folders:** Propose cleaning up the old, now obsolete documentation files or directories.
