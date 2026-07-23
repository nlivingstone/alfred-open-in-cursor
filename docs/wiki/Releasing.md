# Releasing

Publishing to npm is automated when you publish a GitHub release.

## One-time setup: trusted publishing

Classic and automation npm tokens were revoked in December 2025. CI publishing requires **trusted publishing (OIDC)**.

On [npm → alfred-open-in-cursor → Settings → Publishing access → Trusted Publishers](https://www.npmjs.com/package/alfred-open-in-cursor/access), add:

- **Provider:** GitHub Actions
- **Repository:** `nlivingstone/alfred-open-in-cursor`
- **Workflow filename:** `release.yml`

The release workflow (`.github/workflows/release.yml`) uses Node.js 24 (npm ≥ 11.5.1) and OIDC — no npm token secret is needed.

Remove any `NPM_TOKEN` secret from GitHub repository settings. A leftover token can override OIDC and cause `EOTP` or `ENEEDAUTH` failures.

## Create a release

1. Install the [GitHub CLI](https://cli.github.com/) and authenticate with `gh auth login`
2. From `main` with a clean working tree, run:

   ```bash
   ./scripts/release.sh patch
   # or
   ./scripts/release.sh minor
   ./scripts/release.sh major
   # or
   npm run release:github -- patch
   ```

This will:

- Bump `package.json`, `package-lock.json`, `info.plist`, and `CHANGELOG.md`
- Create the release commit and tag (for example `v1.1.2`)
- Push to GitHub
- Run `gh release create v1.1.2 --generate-notes`

When the GitHub release is published, the **Publish to npm** workflow runs tests and publishes that tag to [npm](https://www.npmjs.com/package/alfred-open-in-cursor).

The release tag must match `package.json` (for example tag `v1.1.2` → version `1.1.2`).

## Bump version locally (no GitHub release)

To bump the version locally without creating a GitHub release:

```bash
npm run release:patch
npm run release:minor
npm run release:major
```

These run [standard-version](https://github.com/conventional-changelog/standard-version) only. They do not push tags or publish to npm.
