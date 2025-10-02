#!/usr/bin/env python3
"""
Add minimal YAML front matter to Markdown files that are missing it.
Also normalizes the first H1 so the front matter title is the only H1:
- If the first body H1 matches the inferred title, remove it.
- Otherwise, demote that first H1 to H2 so content is preserved.

Defaults:
- If --root is not provided, operate on the parent directory of this script (i.e., the docs/ folder).
- Dry run by default; write changes only with --write.

Usage:
  python3 docs/scripts/add_frontmatter.py [--root <path>] [--write]
"""
import argparse
import datetime as dt
import os
import re
import sys
from pathlib import Path

FM_LINE = re.compile(r"^---\s*$")
H1_LINE = re.compile(r"^#\s+.+$")

def has_front_matter(text: str) -> bool:
    lines = text.splitlines()
    if not lines or not FM_LINE.match(lines[0]):
        return False
    for i in range(1, min(len(lines), 200)):
        if FM_LINE.match(lines[i]):
            return True
    return False

def infer_title(path: str, text: str) -> str:
    # Prefer first level-1 heading in the body
    for line in text.splitlines()[:50]:
        if H1_LINE.match(line):
            return line.lstrip('#').strip()
    # Fallback to filename
    name = os.path.splitext(os.path.basename(path))[0]
    return name.replace('-', ' ').replace('_', ' ').title()

def normalize_first_h1(text: str, title: str) -> str:
    lines = text.splitlines()
    for i, line in enumerate(lines):
        if H1_LINE.match(line):
            body_h1 = line.lstrip('#').strip()
            if body_h1 == title:
                # Remove this H1 and a single following blank line if present
                j = i + 1
                if j < len(lines) and lines[j].strip() == "":
                    j += 1
                return "\n".join(lines[:i] + lines[j:])
            else:
                # Demote to H2 to preserve content
                lines[i] = '## ' + body_h1
                return "\n".join(lines)
    return text

def build_front_matter(title: str) -> str:
    now = dt.datetime.utcnow().replace(microsecond=0).isoformat() + 'Z'
    return (
        '---\n'
        f'title: {title}\n'
        'description: \n'
        f'date: {now}\n'
        'draft: false\n'
        'tags: []\n'
        'categories: []\n'
        '---\n\n'
    )

def process_file(path: str, write: bool) -> bool:
    try:
        with open(path, 'r', encoding='utf-8') as f:
            text = f.read()
    except Exception:
        return False
    if has_front_matter(text):
        return False
    title = infer_title(path, text)
    body = normalize_first_h1(text, title)
    fm = build_front_matter(title)
    new_text = fm + body
    if write:
        with open(path, 'w', encoding='utf-8', newline='\n') as f:
            f.write(new_text)
    else:
        sys.stdout.write(f"Would add front matter to: {path}\n")
    return True

def should_skip(path: str) -> bool:
    parts = set(Path(path).parts)
    return any(p in parts for p in ('.git', 'node_modules', '.frontmatter', 'dist', 'build', 'scripts'))

def main():
    default_root = Path(__file__).resolve().parents[1]  # docs/ folder containing this script
    parser = argparse.ArgumentParser(description='Add YAML front matter to Markdown files missing it.')
    parser.add_argument('--root', default=str(default_root), help='Root directory to scan (default: docs/ containing this script)')
    parser.add_argument('--write', action='store_true', help='Write changes (default: dry run)')
    args = parser.parse_args()

    changed = 0
    updated_files = []
    for root, dirs, files in os.walk(args.root):
        if should_skip(root):
            dirs[:] = []
            continue
        for name in files:
            if not name.lower().endswith('.md'):
                continue
            path = os.path.join(root, name)
            if process_file(path, args.write):
                changed += 1
                updated_files.append(path)
    if args.write:
        print(f"Updated {changed} file(s) with front matter.")
        if updated_files:
            print("Files updated:")
            for p in updated_files:
                print(f"- {p}")
            print("\nFollow-up: propose reasonable tags and categories for the updated docs.")
    else:
        print(f"Dry run complete. {changed} file(s) would be updated.")

if __name__ == '__main__':
    main()
