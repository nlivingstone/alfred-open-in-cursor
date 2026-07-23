#!/bin/bash
# Based on alfred-open-in-vscode by vivaxy
# Copyright (C) 2026 Neil Livingstone
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

RELEASE_TYPE="${1:-patch}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

usage() {
  echo "Usage: $0 [patch|minor|major]"
  echo
  echo "Bumps the version, pushes the release tag, and creates a GitHub release."
  echo "Publishing to npm runs automatically via GitHub Actions."
}

case "$RELEASE_TYPE" in
  patch | minor | major) ;;
  -h | --help | help)
    usage
    exit 0
    ;;
  *)
    usage
    exit 1
    ;;
esac

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required. Install it from https://cli.github.com/" >&2
  exit 1
fi

cd "$ROOT_DIR"

if [ -n "$(git status --porcelain)" ]; then
  echo "Working tree is not clean. Commit or stash changes before releasing." >&2
  exit 1
fi

BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$BRANCH" != "main" ]; then
  echo "Releases must be created from main (current branch: $BRANCH)." >&2
  exit 1
fi

npm run "release:${RELEASE_TYPE}"

VERSION="$(node -p "require('./package.json').version")"
TAG="v${VERSION}"

echo "Pushing ${TAG} to origin..."
git push --follow-tags origin main

echo "Creating GitHub release ${TAG}..."
gh release create "$TAG" --generate-notes --title "$TAG"

echo "Done. GitHub Actions will publish ${TAG} to npm when the release is published."
