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

### Command-invoked

| Skill | Command | Description |
|-------|---------|-------------|
| Plan Issue | `/plan-issue <number>` | Brainstorm an issue's spec (if unsettled) and append an implementation plan to the issue body |
| Implement Issue | `/implement-issue <number>` | Implement a GitHub issue via agent |
| Parallel Implement | `/agent-team-implement-issues <numbers>` | Implement multiple issues in parallel |
| Plan Refactor | `/plan-refactor` | Analyze codebase and propose refactoring issues |

### Auto-triggered

These skills activate automatically when the task matches; there is no command to run.

| Skill | Triggers on | Description |
|-------|-------------|-------------|
| Avoid Design Slop | Building UI / styles / landing pages | Flags AI-generated design clichés (overused fonts, generic layouts, low-contrast themes, gradient/glow overuse) and pushes for more distinctive design |
| Motion System | Animation, gestures, transitions, haptics, draggable/throwable UI | Enforces a small vocabulary of motion tokens + interaction primitives so motion feels physical and consistent instead of improvised per-screen |
