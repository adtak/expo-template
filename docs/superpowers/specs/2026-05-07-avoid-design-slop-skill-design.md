# Design Spec: `avoid-design-slop` Skill

Date: 2026-05-07
Status: Approved (ready for implementation plan)

## Goal

Add a Claude Code skill to the Expo template that helps Claude avoid common AI-generated UI design clichés ("design slop") when implementing UI in projects bootstrapped from this template.

## Source Material

Adrian Krebs, "Design Slop" — https://www.adriankrebs.ch/blog/design-slop

The blog enumerates anti-patterns frequently produced by LLM-driven UI work, grouped into four categories: Fonts, Colors, Layout quirks, and CSS patterns.

## Motivation

- Projects bootstrapped from this template are Expo/React Native apps, but the same projects also implement landing pages (Web) from time to time.
- Claude has a tendency to reach for the same overused defaults (Inter, centered hero with three feature cards, gradient/glow, default shadcn/ui look). A small, targeted reference loaded only when working on UI keeps the main `CLAUDE.md` lean while still nudging Claude away from these defaults.
- The user explicitly does not want Claude to invent React Native–specific anti-patterns that cannot be verified against a primary source. The spec must therefore stay faithful to the original article and only annotate platform applicability.

## Non-Goals

- Inventing new RN-specific anti-patterns not present in the source article.
- Translating Web-only patterns (e.g., Glassmorphism, shadcn/ui defaults) into RN equivalents through interpretation.
- Adding general design guidance unrelated to the source article.
- Modifying `setup.sh`. Files dropped under `template/` are copied verbatim to target projects, so no setup script changes are required.

## Approach

### Form: Skill (not `CLAUDE.md` rule)

Decision: implement as a skill rather than as guidance in `template/.claude/CLAUDE.md`.

Rationale:

- The content is large (~20 items) and only relevant when writing UI. Adding it to `CLAUDE.md` would bloat every session's context for tasks like CI changes, routing, or tests.
- The trigger condition ("implementing UI screens, components, styles, landing pages") is clear and well-suited to skill auto-invocation.
- This keeps `template/.claude/CLAUDE.md` focused on always-relevant project facts.

### Faithfulness Strategy

Each anti-pattern is tagged with one of:

- `[Web]` — taken from the article and applies to Web only (e.g., Landing Pages built in this repo's downstream projects).
- `[Both]` — taken from the article and judged platform-agnostic (applies to both Web and React Native).

There is no `[RN-only]` tag. The skill explicitly states that RN-specific anti-patterns are not invented; only the source article's items are listed.

The `[Both]` judgement is the only authoring discretion; the items themselves and their wording stay close to the source.

## Skill File

Location: `template/.claude/skills/avoid-design-slop/SKILL.md`

Frontmatter:

```yaml
---
name: avoid-design-slop
description: Use when implementing UI screens, components, styles, or landing pages — flags common AI-generated design clichés (overused fonts, generic layouts, low-contrast dark themes, gradient/glow overuse) so Claude proposes more distinctive designs. Sourced from Adrian Krebs' "Design Slop" article.
---
```

Notes:

- `disable-model-invocation` is intentionally omitted so the skill auto-fires on UI work.
- `allowed-tools` is omitted; this is a read-only reference skill.
- Description is in English to match the project convention for skill/agent artifacts.

Body content (English, per project convention):

```
# Avoid Design Slop

Source: https://www.adriankrebs.ch/blog/design-slop (Adrian Krebs)

## How to use this skill
- Before/while writing UI: scan the patterns below and avoid them.
- Tags: `[Web]` = Web-specific (e.g. landing pages); `[Both]` = applies to Web and React Native.
- Do not invent RN-specific anti-patterns; only flag what's listed.

## Fonts
- [Both] Inter used for everything, especially centered hero headlines
- [Both] Default LLM combos: Space Grotesk, Instrument Serif, Geist
- [Both] Serif italic on a single accent word in an otherwise-Inter hero

## Colors
- [Both] "VibeCode Purple" as the brand color
- [Both] Permanent dark mode with medium-grey body text and all-caps section labels
- [Both] Barely-passing body-text contrast in dark themes
- [Both] Gradient everything
- [Both] Large colored glows and colored box-shadows

## Layout quirks
- [Both] Centered hero set in a generic sans
- [Both] Badge directly above the hero H1
- [Both] Colored borders on cards (top or left edge)
- [Both] Identical 3-up feature cards with an icon on top
- [Both] Numbered "1, 2, 3" step sequences
- [Both] Stat banner rows
- [Both] Sidebar/nav with emoji icons
- [Both] All-caps headings and section labels

## CSS patterns
- [Web] Default shadcn/ui look
- [Web] Glassmorphism

## What to do instead
- Pick typography/color choices that reflect the product's identity, not LLM defaults.
- Verify dark-mode contrast against WCAG.
- Question every "centered hero + 3 cards + numbered steps" layout: does it serve the content, or is it filler?
- When using a UI library (shadcn/ui, NativeWind, Tamagui, etc.), customize tokens — don't ship defaults.
```

### Tagging Decisions

- **Fonts (3 items)** — all `[Both]`. Font overuse and italic-accent tropes apply equally to Web and RN.
- **Colors (5 items)** — all `[Both]`. Brand color clichés, contrast issues, gradients, and glows occur on both platforms.
- **Layout quirks (8 items)** — all `[Both]`. These are layout/structure patterns independent of rendering platform.
- **CSS patterns (2 items)** — `[Web]`. shadcn/ui is a Web component library; Glassmorphism in the article's sense refers to CSS `backdrop-filter` styling.

## Files Changed

- **Add**: `template/.claude/skills/avoid-design-slop/SKILL.md`
- **No changes**: `setup.sh`, `template/.claude/CLAUDE.md`, top-level `CLAUDE.md`.

## Acceptance Criteria

1. The new file exists at the path above with the frontmatter and body shown.
2. `setup.sh` continues to copy `template/` verbatim and the new skill arrives in target projects without further configuration.
3. The skill's description triggers on UI-related work in downstream projects.
4. No content beyond what is in the source article (plus platform tags and a short "What to do instead" section that summarizes the article's spirit) is introduced.

## Out of Scope (Future Work)

- Pulling in additional design guidance from other sources.
- Localizing the skill content (kept English to match project artifact conventions).
- Adding example "good" components — the skill is a checklist, not a pattern library.
