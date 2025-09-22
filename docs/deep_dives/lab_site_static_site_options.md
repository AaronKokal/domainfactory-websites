---
title: lab.aron-kokal.com Static Site Options
description: Compare staying on Jekyll versus adopting Docusaurus, with guidance on Front Matter authoring workflows.
date: 2025-09-17T00:00:00Z
draft: false
tags: [Plan, Jekyll, Docusaurus]
categories: [DeepDive]
---

# Context

`lab.aron-kokal.com` originally ran on Jekyll. Authoring happened via Markdown files managed through VS Code with the Front Matter extension. We explored Docusaurus as a potential replacement, but the preference was initially to keep Jekyll and improve the authoring and presentation flow. This document surveys the options and outlines upgrade paths for both staying on Jekyll and pursuing Docusaurus later if desired. *(Update: the site now uses Docusaurus deployed to GitHub Pages.)*

# Option A — Enhance the Existing Jekyll Stack

## Goals

- Keep the familiar Jekyll build and deployment setup.
- Allow Front Matter to discover and manage posts/pages directly from configured folders.
- Improve the landing page/blog presentation without abandoning the current toolchain.

## Front Matter Integration

- Front Matter already supports Jekyll collections. Update `frontmatter.json` in the site repo so `docs/_posts` is registered with a content type that includes common fields (title, description, categories, tags).
- Add additional `pageFolders` entries for other content directories (e.g., pages, data) if needed.
- Define content-type defaults for posts (slug pattern, layout, default tags) to streamline new post creation.
- Leverage Front Matter `previewPath` to open the local dev server (`bundle exec jekyll serve`) directly from the CMS sidebar.

## Improving Blog Presentation

- Use Jekyll layouts (`_layouts/`) and includes to create a tagged archive, category landing pages, or featured post sections on the homepage.
- Consider adding the [jekyll-archives](https://github.com/jekyll/jekyll-archives) plugin for automatic archive pages if supported by the hosting environment.
- Introduce Sass or Tailwind via the Jekyll asset pipeline for more polished styling.

## Authoring Experience Enhancements

- Create Front Matter snippets/templates for new posts to prefill front matter and scaffolding.
- Configure the VS Code workspace so running the dev server is a one-command task (launch configuration or npm script invoking `bundle exec jekyll serve --livereload`).
- Document the authoring workflow in `sites/lab.aron-kokal.com/README.md` for future contributors.

## Deployment Considerations

- The existing deploy script that copies the Jekyll-generated `_site/` to DomainFactory can remain unchanged.
- If enabling additional plugins, ensure they are compatible with the Ruby environment used during build (local or CI).

# Option B — Adopt Docusaurus Later

If, after enhancing Jekyll, the site needs richer React-based components or Docs+Blog navigation, Docusaurus remains a viable alternative. The previous Docusaurus plan still applies with adjustments for a staged migration. Key highlights:

- Scaffold Docusaurus in a subfolder to run parallel with Jekyll during evaluation.
- Update Front Matter configuration to point at `docusaurus/blog` and `docusaurus/docs` if/when switching.
- Reuse GitHub Pages by publishing the Docusaurus `build/` output via the standard deploy script.

# Decision Guide

| Requirement | Jekyll (Enhanced) | Docusaurus |
| --- | --- | --- |
| Markdown-first authoring with Front Matter | ✅ | ✅ (with MDX capability) |
| Custom domain on DomainFactory | ✅ (existing) | ✅ (requires Node build) |
| Rich React components | ⚠️ (require custom scripts) | ✅ built-in |
| Learning curve | Low (current stack) | Medium (React-based) |
| Multi-language docs | Plugins required | Built-in |

# Recommended Next Steps

~~1. Update `sites/lab.aron-kokal.com/frontmatter.json` to fine-tune Jekyll content types and fields.~~

~~2. Define or refine Jekyll layouts/includes to surface blog posts prominently on the homepage.~~

~~3. Add documentation in the site repo for running the Jekyll dev server and using Front Matter.~~

With the decision made to adopt Docusaurus, the immediate follow-up items shift to:

1. Finalize the Docusaurus content migration and remove any remaining starter assets.
2. Keep the GitHub Actions workflow (`.github/workflows/jekyll-gh-pages.yml`) healthy so pushes to `main` continue deploying automatically.
3. Update contributor docs (this deep dive plus site README) as workflows evolve.
4. Reassess the need for keeping legacy Jekyll notes once the new stack has been live for a full iteration.
