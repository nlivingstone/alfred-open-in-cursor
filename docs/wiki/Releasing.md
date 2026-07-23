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
- Create the release commit and tag (for example `v1.0.1`)
- Push to GitHub
- Run `gh release create v1.0.1 --generate-notes`

When the GitHub release is published, the **Publish to npm** workflow runs tests and publishes that tag to [npm](https://www.npmjs.com/package/alfred-open-in-cursor).

The release tag must match `package.json` (for example tag `v1.0.1` → version `1.0.1`).

## Finish the 1.0.0 npm reset

If all previous npm versions must be removed before the canonical `1.0.0` publish:

1. Unpublish the entire package (requires npm 2FA OTP):

   ```bash
   npm unpublish alfred-open-in-cursor --force
   ```

2. Wait **24 hours** (npm policy after a full unpublish).

3. Tag and publish the reset release from `main`:

   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   gh release create v1.0.0 --generate-notes --title v1.0.0
   ```

GitHub Actions will publish `alfred-open-in-cursor@1.0.0` to npm.

## Bump version locally (no GitHub release)

To bump the version locally without creating a GitHub release:

```bash
npm run release:patch
npm run release:minor
npm run release:major
```

These run [standard-version](https://github.com/conventional-changelog/standard-version) only. They do not push tags or publish to npm.
