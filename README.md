# expo-template

Setup script that adds opinionated tooling on top of a fresh Expo project.

## Philosophy

`create expo-app` and `eas build:configure` handle the core scaffolding. This repo covers only what those tools don't: formatting, testing, CI, and AI-assisted development workflow.

If something can be initialized by an official Expo or EAS command, it stays out of this repo.

## What's Included

| Category | What | Details |
|----------|------|---------|
| Formatting | Biome | `biome check` for formatting + import sorting (ESLint handles linting) |
| Testing | Jest + Testing Library | `jest-expo` preset with `@/` alias support |
| CI | GitHub Actions | Lint, format check, typecheck, test on every PR |
| Build | EAS Build | Run `eas build:configure` after setup — not managed by this repo |
| AI | Claude Code | CLAUDE.md, agents, and skills for issue planning & implementation |

## Quick Start

### 1. Create a new Expo app

```bash
pnpm create expo-app@latest ~/repo/my-app
cd ~/repo/my-app
```

### 2. Run the setup script

```bash
~/repo/expo-template/setup.sh
```

### 3. Update app identity

Replace placeholder values in `app.json`:

- `expo.name` — display name
- `expo.slug` — URL-safe name
- `expo.scheme` — deep link scheme
- `expo.ios.bundleIdentifier` — iOS bundle ID (e.g., `com.yourname.myapp`)

Then set up EAS:

```bash
eas build:configure
```

This generates `eas.json` with development, preview, and production build profiles.

### 4. Verify

```bash
pnpm expo start
```

## Development

```bash
pnpm expo start          # Start dev server
pnpm go                  # Start dev server (Go mode)
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
