---
name: plan-issue
description: Create an implementation plan for a GitHub issue and write it to the issue description.
disable-model-invocation: true
argument-hint: [issue-number]
allowed-tools: Read, Grep, Glob, Bash(gh *), WebFetch
---

# Plan Issue

Create an implementation plan for GitHub issue #$ARGUMENTS.

## Steps

1. **Read the issue** — Run `gh issue view $ARGUMENTS` to get the issue title, body, and labels.

2. **Grasp the project status** — Run `gh issue list` to see open issues and understand where this issue fits in the overall project roadmap.

3. **Understand the context** — Based on the issue description, explore the codebase to understand:
   - Which files are relevant
   - Current architecture and patterns (refer to CLAUDE.md)
   - Dependencies and constraints

4. **Clarify unknowns** — If the issue is unclear, missing information, or there are multiple valid approaches, ask the user before proceeding. Do not make assumptions on ambiguous points.

5. **Draft the plan** — Write a concrete implementation plan using the template in [plan-template.md](plan-template.md). The plan should be:
   - Specific enough that another developer (or Claude) can implement it without ambiguity
   - Scoped to only what the issue requires — explicitly call out what is out of scope
   - Written in English (project convention)

6. **Write to the issue** — Append the plan below the existing issue description using `gh issue edit $ARGUMENTS --body '<existing body + plan>'`. Preserve the original content (User Story, Acceptance Criteria, etc.) as-is, then add a `---` separator followed by the plan sections. Use single quotes around the body to preserve Markdown formatting (backticks, double quotes, etc.). If the text contains single quotes, escape them with `'"'"'`.

## Guidelines

- **Split if too large** — If the resulting plan would be too large for a single reviewable PR (e.g., many files across multiple independent concerns), propose splitting the issue into smaller issues instead of writing one large plan. Explain the proposed split to the user and get confirmation before creating the new issues.
- Keep the plan minimal. Do not over-engineer or add unnecessary steps.
- If the issue is unclear or missing information, always ask the user rather than assuming.
- Reference actual file paths discovered during exploration, not guessed paths.
- For each file change, specify whether it is Create, Modify, or Delete.
- Do not include full code in the plan — describe what changes are needed and why.
- Code snippets are acceptable when they clarify intent (e.g., type definitions, key structures).
