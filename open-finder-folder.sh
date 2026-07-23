#!/bin/bash
# Based on alfred-open-in-vscode by vivaxy
# Copyright (C) 2026 Neil Livingstone
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
folder_path="$(
  osascript -e 'tell application "Finder" to get POSIX path of (folder of the front window as alias)' 2>/dev/null || true
)"

if [ -z "$folder_path" ]; then
  echo "No Finder folder found." >&2
  exit 1
fi

exec "$SCRIPT_DIR/open-project.sh" "$folder_path"
