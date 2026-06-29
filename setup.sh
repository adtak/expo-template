#!/usr/bin/env bash
set -euo pipefail

# Resolve the directory where this script (and template/) lives
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/template"

# ── Validation ──────────────────────────────────────────────────────────────

if [[ ! -f "app.json" ]]; then
  echo "Error: app.json not found. Run this script from inside an Expo project." >&2
  exit 1
fi

if ! node -e "const c = JSON.parse(require('fs').readFileSync('app.json','utf8')); if (!c.expo) process.exit(1)" 2>/dev/null; then
  echo "Error: app.json does not contain an 'expo' key." >&2
  exit 1
fi

if ! command -v pnpm &>/dev/null; then
  echo "Error: pnpm is required. Install it first: https://pnpm.io/installation" >&2
  exit 1
fi

if [[ ! -d "$TEMPLATE_DIR" ]]; then
  echo "Error: template/ directory not found at $TEMPLATE_DIR" >&2
  exit 1
fi

echo "Setting up Expo project with expo-template..."
echo ""

# ── Copy template files ────────────────────────────────────────────────────

echo "Copying config files..."
mkdir -p .claude .github .vscode
cp -r "$TEMPLATE_DIR/.claude/." .claude/
cp -r "$TEMPLATE_DIR/.github/." .github/
cp -r "$TEMPLATE_DIR/.vscode/." .vscode/
cp "$TEMPLATE_DIR/.npmrc" .npmrc
cp "$TEMPLATE_DIR/biome.json" biome.json
cp "$TEMPLATE_DIR/jest.config.js" jest.config.js
# Ship a pre-formatted eslint.config.js. Otherwise `expo lint` generates an
# unformatted one on first run (in CI, before the Biome format check), and the
# format check fails on it.
cp "$TEMPLATE_DIR/eslint.config.js" eslint.config.js

# ── Add devDependencies ────────────────────────────────────────────────────

echo "Installing devDependencies..."
# jest / @types/jest are pinned to the major version Expo SDK 56 (jest-expo)
# requires; unpinned, pnpm pulls jest 30 and expo-doctor fails the version check.
pnpm add -D \
  @biomejs/biome \
  "@testing-library/react-native" \
  "@types/jest@^29.5.14" \
  "jest@^29.7.0" \
  jest-expo \
  react-test-renderer \
  expo-build-properties \
  expo-doctor

# ── Add scripts to package.json ────────────────────────────────────────────

echo "Adding scripts to package.json..."
node -e "
const fs = require('fs');
const pkg = JSON.parse(fs.readFileSync('package.json', 'utf8'));
pkg.scripts = {
  ...pkg.scripts,
  go: 'expo start --go',
  format: 'biome check --write .',
  'format:check': 'biome check .',
  test: 'jest',
};
fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2) + '\n');
"

# ── Modify app.json ────────────────────────────────────────────────────────

echo "Updating app.json..."
node -e "
const fs = require('fs');
const config = JSON.parse(fs.readFileSync('app.json', 'utf8'));

// Add schema field at the top if missing
const schema = 'https://raw.githubusercontent.com/expo/expo/main/docs/public/static/schemas/unversioned/app-config-schema.json';
const configWithSchema = config['\$schema']
  ? config
  : { '\$schema': schema, ...config };

const expo = configWithSchema.expo;

// Add iOS bundleIdentifier if missing
if (!expo.ios) expo.ios = {};
if (!expo.ios.bundleIdentifier) {
  expo.ios.bundleIdentifier = 'com.example.myapp';
}

// Add expo-build-properties plugin if missing
if (!expo.plugins) expo.plugins = [];
const hasBuildProps = expo.plugins.some(
  (p) => (Array.isArray(p) ? p[0] : p) === 'expo-build-properties'
);
if (!hasBuildProps) {
  expo.plugins.push([
    'expo-build-properties',
    { ios: { deploymentTarget: '16.4' } },
  ]);
}

// Add EAS project ID placeholder if missing
if (!expo.extra) expo.extra = {};
if (!expo.extra.eas) expo.extra.eas = {};
if (!expo.extra.eas.projectId) {
  expo.extra.eas.projectId = '';
}

fs.writeFileSync('app.json', JSON.stringify(configWithSchema, null, 2) + '\n');
"

# ── Clean up boilerplate from create expo-app ─────────────────────────────

rm -rf app-example

# create-expo-app generates root CLAUDE.md (@AGENTS.md) and AGENTS.md. This
# template consolidates all agent instructions under .claude/CLAUDE.md (which
# already embeds the Expo SDK versioned-docs guidance), so remove the roots.
rm -f CLAUDE.md AGENTS.md

# ── Format existing code ───────────────────────────────────────────────────

echo "Formatting code with Biome..."
pnpm format

# ── Summary ─────────────────────────────────────────────────────────────────

echo ""
echo "Done! The following have been added to your project:"
echo ""
echo "  .claude/         Claude Code config, agents, and skills"
echo "  .github/         GitHub Actions CI + Dependabot"
echo "  .vscode/         VSCode extension recommendations and Biome settings"
echo "  .npmrc           pnpm node-linker=hoisted"
echo "  biome.json       Biome formatter config"
echo "  jest.config.js   Jest test config"
echo ""
echo "Scripts added to package.json:"
echo "  pnpm format        Format code (Biome)"
echo "  pnpm format:check  Check formatting"
echo "  pnpm test          Run tests (Jest)"
echo "  pnpm go            Start Expo (Go mode)"
echo ""
echo "Next steps:"
echo "  1. Update app identity in app.json:"
echo "     - expo.name, expo.slug, expo.scheme"
echo "     - expo.ios.bundleIdentifier"
echo "  2. Run: eas build:configure  (to generate eas.json)"
echo "  3. Run: pnpm expo start"
