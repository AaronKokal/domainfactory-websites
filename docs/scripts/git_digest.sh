#!/usr/bin/env bash
set -euo pipefail

# Simple, optional helper to print a recent git digest.
# Usage:
#   docs/scripts/git_digest.sh [<since> | <count>]
# Examples:
#   docs/scripts/git_digest.sh 7.days
#   docs/scripts/git_digest.sh 20

cd "$(git rev-parse --show-toplevel)" 2>/dev/null || true

arg="${1:-7.days}"

if [[ "$arg" =~ ^[0-9]+$ ]]; then
  git log -n "$arg" --pretty='format:%h %ad | %s' --date=iso
else
  git log --since="$arg" --pretty='format:%h %ad | %s' --date=iso
fi

echo
echo "Tip: Include WHY/REFS/IMPACT in commit messages to aid summaries."
