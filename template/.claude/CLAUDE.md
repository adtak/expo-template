# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Language

- Conversation with the user: **Japanese**
- Git commit messages, PR titles/descriptions, code comments, CLAUDE.md, and other project artifacts: **English**

## Project Overview

Expo/React Native app using TypeScript (strict mode). Package manager is **pnpm**.

Key experimental features enabled in `app.json`:

- **New Architecture** (React Native)
- **Typed Routes** (Expo Router)
- **React Compiler**

## Development Commands

Always use **pnpm** to run Expo CLI commands (not npx).

```bash
# Install dependencies
pnpm install

# Start Expo development server
pnpm expo start

# Run on specific platforms
pnpm expo start --ios
pnpm expo start --android
pnpm expo start --web

# Lint
pnpm expo lint

# Format
pnpm format          # format all files (write)
pnpm format:check    # check formatting (CI)

# Test
pnpm test            # run Jest tests

```

## Environment

- `EXPO_DEBUG=1` is set via `.claude/settings.json`

## Architecture

### Routing (Expo Router — file-based)

Routes live in `app/`. Directory structure maps directly to URL structure.

- `app/_layout.tsx` — Root layout
- `app/index.tsx` — Home screen

<!-- Add new routes here as you create them -->

### Linting & Formatting

- **ESLint** (`pnpm expo lint`) — Linting only. Kept for Expo-specific rules and React Compiler integration
- **Biome** (`pnpm format`) — Formatting and import sorting via `biome check` (linter disabled in `biome.json`)
- The two tools have fully separated roles with no conflicts

### Import Aliases

Use `@/` to import from the project root (configured in `tsconfig.json`):

```typescript
import { Example } from "@/components/example";
```

## Development Workflow

### Issue Granularity

Keep Issues small enough that each results in a single, reviewable PR. An Issue may be a vertical slice of user-facing functionality or a horizontal slice (e.g., backend setup, UI layer) when the full vertical slice would produce a PR that is too large to review effectively.

Technical enablement work (e.g., infrastructure setup) that has no direct user-facing behavior should also be its own Issue when it is independently deliverable.

### Workflow

1. Create a GitHub Issue describing the user story or bug
2. Run `/plan-issue <issue-number>` to generate an implementation plan in the Issue
3. Create a feature branch and implement, linking PRs back to the Issue

## Git Workflow

### Branching Strategy

- **main** — production branch. Never commit directly to main.
- **Always** create a feature branch from `main` for every change — even if the work depends on an unmerged branch.
- Branch names: kebab-case, descriptive (e.g., `add-user-profile`, `fix-tab-navigation`).
- After work is complete, open a PR to merge back into `main`.

### Commits

- Keep commits small and focused — each commit should represent a single logical change.
- Do not bundle unrelated changes into one commit.

### Before Creating a PR

1. Run these checks locally — they also run in CI on every PR:

```bash
pnpm expo lint         # ESLint
pnpm format:check      # Biome format check
pnpm tsc --noEmit      # TypeScript type check
pnpm test              # Jest tests
```

2. Check if the PR changes require updating this CLAUDE.md (e.g., new routes, new directories, changed commands). If so, include the update in the same PR.

## Testing Policy

### What to test

| Priority | Target | Examples |
|----------|--------|----------|
| **Required** | Pure business logic and utility functions | Calculations, parsers, transformers |
| **Required** | Stateful logic | Rate limiters, caches, state machines |
| **Recommended** | Service layer with mocked external dependencies | Repository (DB), API clients |
| **Recommended** | Components/hooks with non-trivial logic | Error boundaries, complex state |

### What NOT to test

- **Thin wrappers and barrel files** — hooks that only delegate to repository functions, `index.ts` re-exports
- **Static definitions and config** — theme tokens, config objects, type-only files
- **UI component appearance** — at this project scale, manual verification is sufficient; snapshot tests are not worth the maintenance cost

### Decision rule

> "If a bug were introduced in this module, would I catch it without a test?"
> - Caught by `tsc` type checking → no test needed
> - Obvious from visual inspection on device → no test needed
> - Requires execution to detect (logic bug, edge case) → **test needed**

### Conventions

- **Test location**: `__tests__/` directory alongside the module being tested (e.g., `lib/__tests__/example.test.ts`)
- **Mocking**: Only mock external boundaries (DB, filesystem, network). Do not mock internal modules.
- **Framework**: Jest (configured via `pnpm test`)
