# expo-template

Minimal Expo/React Native template with tooling pre-configured.

## Stack

- **Expo SDK 54** / React Native 0.81 / React 19
- **TypeScript** (strict mode)
- **Biome** (formatting + import sorting) + **ESLint** (linting)
- **Jest** (testing)
- **GitHub Actions** CI (lint, format, typecheck, test)
- **Claude Code** skills & agents (issue planning, implementation, refactoring)

Experimental features enabled: **New Architecture**, **Typed Routes**, **React Compiler**

## Getting Started

### 1. Create a new repository

Click **"Use this template"** on GitHub, or:

```bash
gh repo create my-app --template adtak/expo-template --public --clone
cd my-app
```

### 2. Update app identity

Replace placeholder values with your app's info:

**`app.json`**
- `expo.name` — display name (e.g., `"MyApp"`)
- `expo.slug` — URL-safe name (e.g., `"my-app"`)
- `expo.scheme` — deep link scheme (e.g., `"my-app"`)
- `expo.ios.bundleIdentifier` — iOS bundle ID (e.g., `"com.yourname.myapp"`)
- `expo.extra.eas.projectId` — run `eas init` to generate

**`package.json`**
- `name` — package name (e.g., `"my-app"`)

### 3. Install and run

```bash
pnpm install
pnpm expo start --ios
```

### 4. Set up EAS (optional)

```bash
pnpm install -g eas-cli
eas init
eas build:configure
```

## Development

```bash
pnpm expo start          # Start dev server
pnpm expo lint           # ESLint
pnpm format              # Biome format (write)
pnpm format:check        # Biome format (check)
pnpm tsc --noEmit        # Type check
pnpm test                # Jest tests
```

## Claude Code Skills

| Skill | Command | Description |
|-------|---------|-------------|
| Plan Issue | `/plan-issue <number>` | Create an implementation plan for a GitHub issue |
| Implement Issue | `/implement-issue <number>` | Implement a GitHub issue via agent |
| Parallel Implement | `/agent-team-implement-issues <numbers>` | Implement multiple issues in parallel |
| Plan Refactor | `/plan-refactor` | Analyze codebase and propose refactoring issues |
| Init Kiro Steering | `/init-kiro-steering [doc-path]` | Generate Kiro steering documents |
