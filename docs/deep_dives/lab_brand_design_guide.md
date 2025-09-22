---
title: lab.aron-kokal.com Design Guide
description: Palette, tokens, and component guidance for the lab site brand system.
date: 2025-09-17T00:00:00Z
draft: false
tags: [Design, Brand, Palette]
categories: [DeepDive]
---

# Purpose

Capture the color system, accessibility rules, and component guidance for `lab.aron-kokal.com` so future updates stay consistent. This summary distills the latest palette review and maps every color to a UI role.

# Core Palette

| Role | Hex | Notes |
| --- | --- | --- |
| **Forest** (Primary) | `#1A3A1A` | Buttons, brand accents, active navigation. White text when used as background. |
| **Periwinkle** (Accent) | `#6D758C` (800) | Links, focus states, subtle outlines. Lighter tints (`#F4F6FF`) for backgrounds. |
| **Raisin** (Neutral) | `#3B2C35` (500) | Default text on light backgrounds. Tints 50–200 handle surfaces and dividers. |
| **Olivine** (Support) | `#A6C36F` (500) | Success/positive highlights and badges. Use 700 (`#74884E`) for text. |
| **Amber** (Warning) | `#E3A008` | Status messaging, warning alerts. |
| **Claret** (Danger) | `#7D2C37` | Error states and destructive actions. |

`Cool gray #7A82AB` is **not** part of the core system; keep it only for disabled states if needed (use 600–700 to pass contrast).

# Accessibility Anchors

- Text on white (≤14 px) must hit **4.5:1**. Use Raisin 400+, Forest 400+, Periwinkle 800+, or Olivine 800+.
- Text on Forest 500–700 always uses **white**. Text on Raisin 500+ uses **Raisin 50–200** or white.
- Focus rings rely on **Periwinkle 800** (`#6D758C`), which clears contrast on both white and dark surfaces.

# Token Map

```css
:root {
  --lab-forest-600: #1A3A1A;
  --lab-peri-800: #6D758C;
  --lab-raisin-500: #3B2C35;
  --lab-olive-700: #74884E;
  --lab-warning-700: #9C6D04;
  --lab-danger-700: #7D2C37;
  --ifm-color-primary: var(--lab-forest-600);
  --ifm-link-color: var(--lab-peri-800);
  --ifm-focus-color: var(--lab-peri-800);
  --ifm-color-content: var(--lab-raisin-500);
}

[data-theme='dark'] {
  --ifm-background-color: #181215;
  --ifm-color-primary: #4B694B; /* forest-400 */
  --ifm-link-color: #DDE5FF;    /* periwinkle-300 */
  --ifm-color-content: #D8D5D7; /* raisin-100 */
}
```

## Status Tokens

| Token | Background | Border | Text |
| --- | --- | --- | --- |
| `--alert-success` | Olivine 100 `#EDF3E2` | Olivine 400 `#B8CF8C` | Olivine 700 `#74884E` |
| `--alert-warning` | Amber 100 `#FFF4D6` | Amber 400 `#F2C44C` | Amber 700 `#9C6D04` |
| `--alert-danger` | Claret 100 `#F7E1E5` | Claret 400 `#C96271` | Claret 700 `#7D2C37` |

# Component Guidance

- **Buttons**
  - Primary: Forest 600 background, hover Forest 700, text white.
  - Secondary: Ghost outline, text Forest 600, hover Periwinkle 100 background.
  - Link/Tertiary: Periwinkle 800 text with underline on hover.
  - Destructive: Claret 700 background, hover 800, text white.
  - Disabled: Raisin 300 text, Neutral 200 border, background Raisin 50.

- **Inputs**
  - Default border Neutral 200, hover Neutral 300.
  - Focus border + ring Periwinkle 800.
  - Invalid border Claret 700 with Claret 100 background.

- **Navigation**
  - Top nav background white (light) / Raisin 900 (dark).
  - Active link Forest 600 underline, hover Periwinkle 100 background.

- **Cards**
  - Default: White surface, border Neutral 200, heading Raisin 500.
  - Emphasis: Periwinkle 100 background, border Periwinkle 300.

- **Alerts**: Follow status tokens table.

- **Chips**
  - Neutral: Raisin 100 background, Raisin 500 text.
  - Brand: Forest 100 background, Forest 700 text.
  - Info: Periwinkle 200 background, Periwinkle 900 text.

- **Data Viz**
  - Series 1 Forest 600, Series 2 Periwinkle 800, Series 3 Olivine 700.
  - Gridlines Neutral 200, Labels Raisin 400–500.

# Dark Mode Notes

- Background stack: Raisin 900 → Raisin 800 → per-surface panels.
- Text defaults swap to Raisin 100/200.
- Buttons lighten (Forest 400) to maintain contrast on dark backgrounds.
- Focus/links move to Periwinkle 300.

# Usage Checklist

1. Never use Olivine 500 or Periwinkle ≤700 for body text on white.
2. Keep Cool gray out of core interactions; reserve for disabled iconography if absolutely needed.
3. Focus states always use Periwinkle 800 (light) / 300 (dark).
4. Before shipping new components, audit with a11y contrast tooling to confirm 4.5:1 for text and 3:1 for large headings.

# Next Steps

- Extend these tokens into a shared CSS/TS constants module if we add other sites.
- Capture Tailwind/Figma libraries once the design stabilises across projects.
