#!/bin/bash
# Sync docs/wiki/*.md to the GitHub wiki repository.
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
WIKI_DIR="$(mktemp -d)"
WIKI_REPO="https://github.com/nlivingstone/alfred-open-in-cursor.wiki.git"

cleanup() {
  rm -rf "$WIKI_DIR"
}
trap cleanup EXIT

if ! git ls-remote "$WIKI_REPO" >/dev/null 2>&1; then
  echo "Wiki repository not found. Create the first page on GitHub first:" >&2
  echo "  https://github.com/nlivingstone/alfred-open-in-cursor/wiki/_new" >&2
  echo "Then run this script again." >&2
  exit 1
fi

git clone "$WIKI_REPO" "$WIKI_DIR"
cp "$ROOT_DIR"/docs/wiki/*.md "$WIKI_DIR"/

cd "$WIKI_DIR"
git add -A
if git diff --staged --quiet; then
  echo "Wiki is already up to date."
  exit 0
fi

git commit -m "Sync wiki from docs/wiki"
git push origin HEAD

echo "Wiki updated: https://github.com/nlivingstone/alfred-open-in-cursor/wiki"
