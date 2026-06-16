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

## Development Pipeline

The flow this template's Claude Code skills are built around.

1. **Ideate** — generate product ideas with [idea-generator](https://github.com/adtak/idea-generator), a separate Claude Code skill (`/idea-generator`) that turns a one-word hint (or nothing) into three scored product proposals. The chosen proposal seeds everything downstream.

2. **Wireframe, spec & visual direction** — explore wireframes and the spec in Claude Code. Once the structure is settled, brainstorm the visual surface — color, type, overall look & world — in Stitch. When the look is locked, export `DESIGN.md`: finalized color, type, and tokens that serve as the design *constitution*. The output is a handoff bundle: wireframes (screenshots / HTML) that double as the screen inventory, plus `DESIGN.md`. (Extracting `DESIGN.md`'s token-related parts into `theme.ts` is then handled as its own foundation Issue — see step 3.)

3. **Inventory & decompose into Issues** — hand the handoff bundle + `DESIGN.md` to Claude Code and turn it into ordered Issues:
   - **Inventory** — first produce a screen/flow list and a shared-component list. The wireframes are themselves the screen inventory.
   - **Decompose** — split into Issues in two layers. A wireframe screen is *not* one Issue: a single screen splits across **layout**, **data wiring**, and **state & edge cases**. Each Issue is sized to a single reviewable PR.
   - **Order by dependency** — land foundation Issues first (navigation skeleton; a token Issue that extracts `DESIGN.md`'s token-related parts into `theme.ts`; a motion-foundation Issue; shared components), then per-screen Issues, then edge-case & polish last — this minimizes rework. A finalized `DESIGN.md` is exactly what lets that token Issue go first.

     The motion-foundation Issue uses the [`motion-system`](#claude-code-skills) skill: its "Initialization" section (generate `motion-tokens.ts` → build the primitives the MVP needs → wire `check_motion.sh` into CI → build one screen and tune the springs on a real device) maps to this single Issue.

   Each Issue links to its target wireframe screen (screenshot / HTML), the relevant `DESIGN.md` tokens / rules, and acceptance criteria. No duplicated spec: **wireframe = source of visual truth, `DESIGN.md` = constitution, Issue = links to both.**

4. **Plan** — run `/plan-issue <number>` to brainstorm the spec (if unsettled) and append an implementation plan to the Issue body.

5. **Branch & implement** — create a feature branch off `main`, then implement with `/implement-issue <number>` (or `/agent-team-implement-issues <numbers>` for several in parallel). Link the PR back to the Issue.

6. **Pre-PR checks** — run `pnpm expo lint`, `pnpm format:check`, `pnpm tsc --noEmit`, and `pnpm test` locally (the same checks CI runs).

7. **Open a PR** — to `main`. GitHub Actions re-runs lint, format check, typecheck, and test on every PR.

8. **Merge** — once CI is green and the PR is reviewed.

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
