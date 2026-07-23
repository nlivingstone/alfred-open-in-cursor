#!/bin/bash
# Based on alfred-open-in-vscode by vivaxy
# Copyright (C) 2026 Neil Livingstone
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

# Alfred workflow config variable (optional).
if [ -n "${cursor_cli:-}" ] && [ -x "$cursor_cli" ]; then
  echo "$cursor_cli"
  exit 0
fi

if [ -n "${CURSOR_CLI:-}" ] && [ -x "$CURSOR_CLI" ]; then
  echo "$CURSOR_CLI"
  exit 0
fi

candidates=(
  "/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
  "$HOME/Applications/Cursor.app/Contents/Resources/app/bin/cursor"
)

for candidate in "${candidates[@]}"; do
  if [ -x "$candidate" ]; then
    echo "$candidate"
    exit 0
  fi
done

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"
if command -v cursor >/dev/null 2>&1; then
  command -v cursor
  exit 0
fi

while IFS= read -r app_path; do
  candidate="$app_path/Contents/Resources/app/bin/cursor"
  if [ -x "$candidate" ]; then
    echo "$candidate"
    exit 0
  fi
done < <(mdfind "kMDItemCFBundleIdentifier == 'com.todesktop.230313mzl4w4u92'" 2>/dev/null)

echo "Cursor CLI not found. Install Cursor or set the Cursor CLI path in the workflow configuration." >&2
exit 1
