#!/bin/bash
# Based on alfred-open-in-vscode by vivaxy
# Copyright (C) 2026 Neil Livingstone
# SPDX-License-Identifier: GPL-3.0-or-later
set -euo pipefail

if [ $# -lt 1 ] || [ -z "$1" ]; then
  echo "Usage: open-project.sh <project-path>" >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CURSOR_CLI="$("$SCRIPT_DIR/bin/find-cursor-cli.sh")"

"$CURSOR_CLI" --classic -n "$1"
open -a Cursor
