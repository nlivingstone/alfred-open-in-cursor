# Alfred Open in Cursor

[![npm version](https://img.shields.io/npm/v/alfred-open-in-cursor.svg?style=flat-square)](https://www.npmjs.com/package/alfred-open-in-cursor)
[![npm downloads](https://img.shields.io/npm/dt/alfred-open-in-cursor.svg?style=flat-square)](https://www.npmjs.com/package/alfred-open-in-cursor)

Alfred workflow to quickly open projects in [Cursor](https://cursor.com/).

> **Fork notice:** This project is a fork of [vivaxy/alfred-open-in-vscode](https://github.com/vivaxy/alfred-open-in-vscode), originally created by [vivaxy](https://github.com/vivaxy). It has been updated to work with Cursor, including opening projects in classic editor mode via the `--classic` flag.

## Features

- Fuzzy search projects from a configurable glob pattern
- Open the selected project in Cursor (classic editor, new window)
- Open the current Finder folder in Cursor
- Project list refreshes automatically while you type

## Requirements

- [Alfred](https://www.alfredapp.com/) 4 or 5 with Powerpack
- [Cursor](https://cursor.com/) for macOS
- [Node.js](https://nodejs.org/) (used by the workflow script filter)

## Installation

### Install from npm (recommended)

Requires [Node.js](https://nodejs.org/) and [Alfred](https://www.alfredapp.com/) with Powerpack.

```bash
npm i -g alfred-open-in-cursor
```

This installs the workflow globally and links it into Alfred via [Alfy](https://github.com/sindresorhus/alfy).

Then configure it in Alfred:

1. Open **Alfred → Workflows**
2. Select **Open in Cursor**
3. Click the `[x]` configuration button
4. Set **Project directories** to a glob pattern for your projects, for example:

   ```
   /Users/me/Developer/*
   ```

5. Optionally set **Cursor CLI path** if auto-detection does not work on your machine

Try it: type `cursor` followed by a space in Alfred to search for a project.

To update later:

```bash
npm update -g alfred-open-in-cursor
```

To uninstall:

```bash
npm uninstall -g alfred-open-in-cursor
```

### Install from source

For local development or contributing:

```bash
git clone https://github.com/nlivingstone/alfred-open-in-cursor.git
cd alfred-open-in-cursor
npm install
npm i -g .
```

A global install (`npm i -g .`) is required; a local-only `npm install` does not link the workflow to Alfred.

## Configuration

Open **Alfred → Workflows → Open in Cursor** and click the `[x]` configuration button.

Set **Project directories** to a glob pattern that matches your project folders, for example:

```
/Users/me/Developer/*
```

That would match projects like `/Users/me/Developer/alfred-open-in-cursor` and `/Users/me/Developer/my-app`.

Optionally set **Cursor CLI path** if Cursor is installed in a non-standard location. Leave it blank to auto-detect from:

- `/Applications/Cursor.app`
- `~/Applications/Cursor.app`
- `cursor` on your `PATH` (for example `/usr/local/bin/cursor`)

## Usage

| Trigger | Action |
| --- | --- |
| `cursor` + space | Search projects and press **Return** to open the selected project in Cursor |
| `cursor` (no space) | Open the frontmost Finder window folder in Cursor |

Projects are opened with:

```bash
cursor --classic -n /path/to/project
```

This opens a new classic editor window rather than focusing an existing Cursor window.

## Troubleshooting

- Type `cursor DEBUG` in the script filter to show debug info (Node version, etc.).
- If the script filter returns no results, confirm **Project directories** is set in the workflow configuration.
- If projects do not open in Cursor, verify the CLI is installed in Cursor with **Shell Command: Install "cursor" command in PATH**, or set **Cursor CLI path** manually in the workflow configuration.
- Test Cursor detection from the terminal:

  ```bash
  ./bin/find-cursor-cli.sh
  ./open-project.sh /path/to/project
  ```

- After editing workflow files locally, reload the workflow in Alfred (right-click → **Reload**).
- To reinstall from npm:

  ```bash
  npm i -g alfred-open-in-cursor
  ```

## Development

```bash
npm install
npm test
```

Test opening a project from the terminal:

```bash
./open-project.sh /path/to/project
```

## Related

- [vivaxy/alfred-open-in-vscode](https://github.com/vivaxy/alfred-open-in-vscode/) — original Alfred workflow for Visual Studio Code
- [vivaxy/alfred-open-in-webstorm](https://github.com/vivaxy/alfred-open-in-webstorm) — same idea for WebStorm
- [Alfy](https://github.com/sindresorhus/alfy) — framework this workflow is built on
- [Alfred 4 Workflow Open in VSCode](https://vivaxyblog.github.io/2019/08/14/alfred-workflow-open-in-vscode.html) — article about the original workflow

## License

GPL-3.0-or-later. See [LICENSE](LICENSE) and [NOTICE](NOTICE).

This project is a modified work based on [alfred-open-in-vscode](https://github.com/vivaxy/alfred-open-in-vscode) by [vivaxy](https://github.com/vivaxy). The original work is copyright vivaxy; modifications are copyright Neil Livingstone.
