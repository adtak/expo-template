---
name: plan-issue
description: Brainstorm an issue's spec (if not already settled) and append a concrete implementation plan to the issue body.
disable-model-invocation: true
argument-hint: [issue-number]
allowed-tools: Read, Grep, Glob, Bash(gh *), WebFetch, Skill
---

# Plan Issue

Create an implementation plan for GitHub issue #$ARGUMENTS.

This skill covers **two phases** in sequence:

1. **Spec phase** — confirm *what* will be built. Triggered only when the issue body is not yet settled (see Step 3 readiness check). Output: an updated issue body.
2. **Plan phase** — confirm *how* it will be built. Always runs. Output: an implementation plan appended below the issue body.

## Interview style (grill-me)

Both the spec interview (Step 4) and the technical interview (Step 6) follow this style. The goal is to reach shared understanding by walking the full decision tree, not by stopping at the first ambiguity.

1. **Walk the whole decision tree.** Enumerate every meaningful branch the spec or implementation depends on, and resolve them one at a time in dependency order. Don't quit after the headline question is answered — keep grilling until the remaining branches are either decided or explicitly deferred.
2. **Codebase first.** Before asking the user a question, check whether reading the code (file structure, existing patterns, types, tests, CLAUDE.md) already answers it. Only escalate genuinely user-facing decisions; resolve the rest silently.
3. **One question at a time.** No batched questionnaires. Wait for each answer before moving to the next branch — answers often reshape later branches.
4. **Always carry a recommendation.** Every question states your recommended answer with a one-line rationale, so the user can confirm with a single word when the call is obvious.

Adapted from [mattpocock/skills `grill-me`](https://github.com/mattpocock/skills/blob/main/skills/productivity/grill-me/SKILL.md).

## Steps

1. **Read the issue** — Run `gh issue view $ARGUMENTS` to get the issue title, body, and labels.

2. **Grasp the project status** — Run `gh issue list` to see open issues and understand where this issue fits in the overall project roadmap.

3. **Spec readiness check** — Decide whether the spec phase is needed by inspecting the current issue body:

   The spec is **settled** (skip to Step 5) when all of the following hold:
   - A concrete `## Goal` or equivalent exists.
   - Deliverables / sections to ship are described concretely (not just a one-line summary).
   - `## Acceptance Criteria` exists and each criterion is specific enough to verify.
   - An out-of-scope list exists (what is intentionally excluded).
   - The body does **not** contain hedging phrases like "sketch — refine via `/plan-issue`", "TBD", or "to be decided".

   Otherwise, the spec is **not settled** — proceed to Step 4.

4. **Spec brainstorming (only if not settled)** — Invoke the `superpowers:brainstorming` skill via the `Skill` tool and follow its protocol to settle the spec with the user:

   - Ask clarifying questions **one at a time**; prefer multiple-choice options.
   - Propose 2–3 approaches with trade-offs before settling.
   - Present the design and get explicit user approval before writing anything.

   Apply the **Interview style (grill-me)** principles above on top of brainstorming's defaults — keep grilling until every branch of the spec decision tree is resolved or explicitly deferred, not just the headline ambiguity.

   **Adaptation for this skill:** the brainstorming skill's default is to write a design doc to `docs/superpowers/specs/`. Override that — the artifact here is the **GitHub Issue body**, not a separate file. After approval, rewrite the issue body via `gh issue edit $ARGUMENTS --body '...'` with these sections:

   - `## Goal`
   - `## Sections shipped` (or equivalent — concrete deliverables)
   - `## Out of scope` (with pointers to other issues that own deferred work)
   - `## Depends on` (other issues / prior work)
   - `## Acceptance Criteria`

   Once the user confirms the updated issue body, continue to Step 5. Do not start the plan phase before the spec body is committed.

5. **Understand the technical context** — Based on the (now-settled) issue body, explore the codebase to understand:
   - Which files are relevant
   - Current architecture and patterns (refer to CLAUDE.md)
   - Dependencies and constraints

6. **Clarify technical unknowns** — Walk the implementation decision tree following the **Interview style (grill-me)** above. Enumerate every non-obvious implementation choice surfaced by Step 5 (data shape, error handling, file/module boundaries, naming, test scope, rollout). For each choice, first check whether the codebase or CLAUDE.md already pins the answer; if not, ask the user one question at a time with your recommended answer and a one-line rationale. The *spec* is already settled — questions here are strictly about *how*, not *what*.

7. **Draft the plan** — Write a concrete implementation plan using the template in [plan-template.md](plan-template.md). The plan should be:
   - Specific enough that another developer (or Claude) can implement it without ambiguity
   - Scoped to only what the issue requires — Out of Scope can reference the issue body's list rather than duplicate it
   - Written in English (project convention)

8. **Append to the issue** — Append the plan below the existing issue description using `gh issue edit $ARGUMENTS --body '<existing body + plan>'`. Preserve the original content as-is, then add a `---` separator followed by the plan sections. Use single quotes around the body to preserve Markdown formatting (backticks, double quotes, etc.). If the text contains single quotes, escape them with `'"'"'`.

## Guidelines

- **Split if too large** — If the resulting plan would be too large for a single reviewable PR (e.g., many files across multiple independent concerns), propose splitting the issue into smaller issues instead of writing one large plan. Explain the proposed split to the user and get confirmation before creating the new issues. This applies in the spec phase too: if brainstorming reveals the issue is actually multiple issues, decompose first.
- **Motion / animation specs** — If the issue involves motion, gestures, transitions, or haptics, and the project already has a motion foundation (`src/motion/motion-tokens.ts` exists), plan it in that vocabulary: name the tokens and primitives the screen needs (e.g., "`SpringCard`, `threshold` tuned to `weighty`, `success` haptic on commit, list uses `ListItemEntrance`") rather than describing raw animation. Read the `motion-system` skill to choose them. If no motion foundation exists yet, treat building it as its own prerequisite Issue rather than inlining motion setup here.
- Keep the plan minimal. Do not over-engineer or add unnecessary steps.
- If the issue is unclear or missing information, always ask the user rather than assuming. In the spec phase use brainstorming's one-question-at-a-time protocol; in the plan phase keep questions tightly scoped to implementation choices.
- Reference actual file paths discovered during exploration, not guessed paths.
- For each file change, specify whether it is Create, Modify, or Delete.
- Do not include full code in the plan — describe what changes are needed and why.
- Code snippets are acceptable when they clarify intent (e.g., type definitions, key structures).
