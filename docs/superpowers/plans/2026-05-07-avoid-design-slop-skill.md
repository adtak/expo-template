# avoid-design-slop Skill Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a documentation-only Claude Code skill (`template/.claude/skills/avoid-design-slop/SKILL.md`) that flags AI-generated UI design clichés sourced from Adrian Krebs' "Design Slop" article.

**Architecture:** Single Markdown file under the template's `.claude/skills/` directory. The file is auto-copied into target Expo projects by the existing `setup.sh` (no setup script changes). The skill auto-fires on UI work via its frontmatter `description`. There is no executable code, so this plan does not use TDD; verification is by inspecting file contents and running the existing setup script in a scratch directory.

**Tech Stack:** Markdown, YAML frontmatter (Claude Code skill format).

**Spec:** `docs/superpowers/specs/2026-05-07-avoid-design-slop-skill-design.md`

---

## File Structure

- **Create:** `template/.claude/skills/avoid-design-slop/SKILL.md`
- **No modifications** to `setup.sh`, `template/.claude/CLAUDE.md`, or any existing file. The new file lands in target projects automatically because `setup.sh` does `cp -r template/. .`.

---

### Task 1: Create the skill directory and SKILL.md

**Files:**
- Create: `template/.claude/skills/avoid-design-slop/SKILL.md`

- [ ] **Step 1: Create the directory**

Run from repo root:

```bash
mkdir -p template/.claude/skills/avoid-design-slop
```

Expected: directory exists, no error.

- [ ] **Step 2: Write `SKILL.md` with the exact content below**

Path: `template/.claude/skills/avoid-design-slop/SKILL.md`

```markdown
---
name: avoid-design-slop
description: Use when implementing UI screens, components, styles, or landing pages — flags common AI-generated design clichés (overused fonts, generic layouts, low-contrast dark themes, gradient/glow overuse) so Claude proposes more distinctive designs. Sourced from Adrian Krebs' "Design Slop" article.
---

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

Important notes for the implementer:

- The file uses `---` YAML frontmatter delimiters at the very top.
- The `description` field is one logical line (no embedded newlines) — this is what Claude Code uses to decide when to auto-invoke the skill.
- Body uses standard Markdown headings. Do not change wording, ordering, or tag values; the spec was approved with this exact text.

- [ ] **Step 3: Verify file content**

Run from repo root:

```bash
cat template/.claude/skills/avoid-design-slop/SKILL.md
```

Expected: prints the exact content above (frontmatter + body), 4 categories with the right tag distribution: Fonts (3 × Both), Colors (5 × Both), Layout quirks (8 × Both), CSS patterns (2 × Web).

- [ ] **Step 4: Verify frontmatter parses as a Claude Code skill**

Spot-check the frontmatter visually: it must start with `---` on line 1, contain `name:` and `description:` keys, end with `---`, and not include `disable-model-invocation` (auto-invocation is intentionally enabled).

Run:

```bash
head -5 template/.claude/skills/avoid-design-slop/SKILL.md
```

Expected output:

```
---
name: avoid-design-slop
description: Use when implementing UI screens, components, styles, or landing pages — flags common AI-generated design clichés (overused fonts, generic layouts, low-contrast dark themes, gradient/glow overuse) so Claude proposes more distinctive designs. Sourced from Adrian Krebs' "Design Slop" article.
---

```

- [ ] **Step 5: Commit**

```bash
git add template/.claude/skills/avoid-design-slop/SKILL.md
git commit -m "Add avoid-design-slop skill to template

Adds a Claude Code skill that auto-fires on UI work and lists
common AI-generated design clichés to avoid. Sourced from
Adrian Krebs' \"Design Slop\" article. Items are tagged [Web]
or [Both] so the skill is useful for both Expo apps and the
landing pages occasionally built in downstream projects.

Spec: docs/superpowers/specs/2026-05-07-avoid-design-slop-skill-design.md"
```

Expected: 1 file changed, ~50 insertions, branch advances by one commit.

---

### Task 2: Verify the skill propagates through `setup.sh`

This task is a smoke test: it confirms `setup.sh` still copies the new skill into target projects. It does not modify any source files.

**Files:**
- Read-only: `setup.sh`, `template/.claude/skills/avoid-design-slop/SKILL.md`

- [ ] **Step 1: Inspect `setup.sh` to confirm `template/` is copied recursively**

Run:

```bash
grep -n "template" setup.sh
```

Expected: at least one line that copies the contents of `template/` into the current directory (e.g., `cp -r template/. .` or `cp -a template/. .`). If the grep returns nothing related to copying `template/`, stop and surface this as a blocker — the skill won't propagate without it.

- [ ] **Step 2: Dry-run the copy in a scratch directory**

```bash
TMPDIR=$(mktemp -d)
cp -r template/. "$TMPDIR"/
ls -la "$TMPDIR/.claude/skills/avoid-design-slop/"
```

Expected: `SKILL.md` appears in the destination directory with the same size as the source.

- [ ] **Step 3: Clean up the scratch directory**

```bash
rm -rf "$TMPDIR"
```

Expected: scratch directory removed; no untracked files appear in `git status`.

- [ ] **Step 4: Confirm `git status` is clean**

Run:

```bash
git status
```

Expected: `nothing to commit, working tree clean`. (Task 1's commit is already in.) If anything appears, investigate before declaring the work done.

---

## Self-Review

**Spec coverage check:**

- ✅ Skill file at `template/.claude/skills/avoid-design-slop/SKILL.md` — Task 1.
- ✅ Frontmatter with `name` and `description`, no `disable-model-invocation` — Task 1, Steps 2 & 4.
- ✅ Body content matches spec verbatim — Task 1, Step 2.
- ✅ No changes to `setup.sh` or `template/.claude/CLAUDE.md` — explicit non-goal; Task 2 is read-only.
- ✅ Skill auto-propagates via existing `setup.sh` copy — Task 2 verifies.
- ✅ Tag distribution preserved (Fonts/Colors/Layout = `[Both]`; CSS = `[Web]`) — Task 1, Step 3.

**Placeholder scan:** No "TBD", "TODO", or vague instructions. All commands are exact, all file content is shown in full.

**Type/name consistency:** The frontmatter `name` (`avoid-design-slop`) matches the directory name; description triggers (`UI screens, components, styles, landing pages`) are consistent with the spec's stated trigger conditions.

No open issues.
