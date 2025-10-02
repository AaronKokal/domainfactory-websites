# Scripts

Purpose
- Provide optional helpers that aid common workflows with this framework.

Included
- `add_frontmatter.py` — Adds minimal YAML front matter to Markdown files that are missing it. Defaults to operating on the `docs/` folder containing this script.
- `git_digest.sh` — Prints a simple recent git history digest (by days or count).

Usage
- Add front matter (dry run): `python3 docs/scripts/add_frontmatter.py`
- Add front matter (write): `python3 docs/scripts/add_frontmatter.py --write`
- Git digest (last 7 days): `docs/scripts/git_digest.sh 7.days`
- Git digest (last 20 commits): `docs/scripts/git_digest.sh 20`

Notes
- Scripts are optional. If you prefer, you can perform the same actions manually as described in the AOP and guides.
