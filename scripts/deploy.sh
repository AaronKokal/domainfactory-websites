#!/usr/bin/env bash
set -euo pipefail

# Simple, safe rsync deploy for a site in this monorepo.
# Usage:
#   scripts/deploy.sh aaron-kokal.com [--dry-run] [--alias df-admin]
# or provide HOST/USER/PORT via the site's deploy.env

SITE=${1:-}
shift || true

DRY_RUN=false
SSH_ALIAS=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run|-n) DRY_RUN=true; shift ;;
    --alias) SSH_ALIAS=${2:-}; shift 2 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "$SITE" ]]; then
  echo "Site name required. Example: scripts/deploy.sh aaron-kokal.com" >&2
  exit 2
fi

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)

# Allow site repos to live either inside this repo (legacy) or as a sibling folder (current layout).
if [[ -d "$ROOT_DIR/sites/$SITE" ]]; then
  SITE_DIR="$ROOT_DIR/sites/$SITE"
elif [[ -d "$ROOT_DIR/../sites/$SITE" ]]; then
  SITE_DIR=$(cd "$ROOT_DIR/../sites/$SITE" && pwd)
else
  echo "Could not locate site repository for '$SITE'. Expected '$ROOT_DIR/sites/$SITE' or '$(cd "$ROOT_DIR/.." && pwd)/sites/$SITE'." >&2
  exit 1
fi

ENV_FILE="$SITE_DIR/deploy.env"

if [[ ! -d "$SITE_DIR/public" ]]; then
  echo "Missing $SITE_DIR/public — nothing to deploy" >&2
  exit 1
fi

if [[ -f "$ENV_FILE" ]]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
else
  echo "Missing $ENV_FILE. Create it with WEBROOT and (optional) HOST/USER/PORT." >&2
  exit 1
fi

HOST=${HOST:-}
PORT=${PORT:-22}
USER=${USER:-}
WEBROOT=${WEBROOT:-}

# Default rsync source to the site's public directory when not overridden in deploy.env.
SOURCE=${SOURCE:-"${SITE_DIR}/public/"}
if [[ "$SOURCE" != /* ]]; then
  SOURCE="$SITE_DIR/${SOURCE#./}"
fi
EXCLUDES=${EXCLUDES:-}

if [[ -z "$WEBROOT" ]]; then
  echo "WEBROOT not set in $ENV_FILE" >&2
  exit 1
fi

# Safety checks
case "$WEBROOT" in
  /kunden/*/webseiten/*) : ;; # ok
  *) echo "Refusing to deploy to WEBROOT='$WEBROOT' (does not look like a site path)" >&2; exit 1 ;;
esac

RSYNC_FLAGS=( -az --delete )

# Support exclude files relative to the site directory.
if [[ -n "$EXCLUDES" ]]; then
  if [[ -f "$EXCLUDES" ]]; then
    RSYNC_FLAGS+=( --exclude-from="$EXCLUDES" )
  elif [[ -f "$SITE_DIR/$EXCLUDES" ]]; then
    RSYNC_FLAGS+=( --exclude-from="$SITE_DIR/$EXCLUDES" )
  else
    echo "Warning: EXCLUDES file '$EXCLUDES' not found; continuing without it." >&2
  fi
fi
[[ "$DRY_RUN" == true ]] && RSYNC_FLAGS+=( -n -v )

if [[ -n "$SSH_ALIAS" ]]; then
  DEST="$SSH_ALIAS:$WEBROOT"
  RSYNC_SSH=( -e "ssh" )
elif [[ -n "$HOST" && -n "$USER" ]]; then
  DEST="$USER@$HOST:$WEBROOT"
  RSYNC_SSH=( -e "ssh -p ${PORT}" )
else
  echo "Provide either --alias df-admin or HOST/USER in $ENV_FILE" >&2
  exit 2
fi

echo "Deploying '$SITE' → $DEST"
rsync "${RSYNC_FLAGS[@]}" "${RSYNC_SSH[@]}" "$SOURCE" "$DEST"
echo "Done." 
