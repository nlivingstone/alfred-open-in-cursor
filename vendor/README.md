Patched copies of upstream Alfy helper packages with updated dependencies.

- `alfred-link` 0.3.2 — based on [SamVerschueren/alfred-link](https://github.com/SamVerschueren/alfred-link) 0.3.1 (MIT)
  - Uses `plist@3` instead of `plist@2` / `xmldom`
  - Replaces `del` with Node.js `fs.promises.rm` in `lib/link.js` and `lib/unlink.js`
- `alfred-notifier` 0.2.4 — based on [SamVerschueren/alfred-notifier](https://github.com/SamVerschueren/alfred-notifier) 0.2.3 (MIT)
  - Uses `plist@3` instead of `plist@2` / `xmldom`

Root `package.json` uses `$alfred-link` / `$alfred-notifier` overrides so `alfy` resolves to these vendored packages during install.

Remove these vendored packages when upstream adopts modern dependencies.
