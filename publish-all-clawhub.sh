#!/usr/bin/env bash
# Publish every skill under plugins/auth0/skills/ to ClawHub under owner=auth0.
# Usage: ./tmp/publish-all.sh <version> <changelog>
# Breaks on first failure so you can debug.

set -u

if [ $# -ne 2 ] || [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
  echo "Usage: $0 <version> <changelog>" >&2
  echo "Example: $0 1.0.2 'Fix secret literals flagged by scanner'" >&2
  exit 1
fi

VERSION="$1"
CHANGELOG="$2"
SKILLS_DIR="plugins/auth0/skills"

if [ ! -d "$SKILLS_DIR" ]; then
  echo "Skills directory not found: $SKILLS_DIR (run from repo root)" >&2
  exit 1
fi

for dir in "$SKILLS_DIR"/*/; do
  skill="$(basename "$dir")"
  echo "=== Publishing $skill@$VERSION ==="
  npx clawhub skill publish "$dir" \
    --owner auth0 \
    --version "$VERSION" \
    --changelog "$CHANGELOG"
  rc=$?
  if [ $rc -ne 0 ]; then
    echo "FAILED: $skill (exit $rc)" >&2
    exit $rc
  fi
done

echo "All skills published at version $VERSION."
