/**
 * Based on alfred-open-in-vscode by vivaxy
 * Copyright (C) 2024 vivaxy
 * Modified work Copyright (C) 2026 Neil Livingstone
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import glob from 'fast-glob';

/**
 * @param {string} globPattern
 * @returns Promise<Array<string>>
 */
export async function getProjectDirectories(globPattern) {
  const directories = await glob(globPattern, {
    cwd: '/',
    onlyDirectories: true,
    dot: true,
    suppressErrors: true,
  });

  return directories.sort();
}
