---
name: plan-refactor
description: Analyze the codebase for refactoring opportunities, create a plan, and file GitHub issues for each proposal.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(gh *), WebFetch
---

# Plan Refactor

Analyze the codebase for refactoring opportunities, present a plan to the user, and create GitHub issues for each approved proposal.

## Steps

1. **Analyze the codebase** — Explore the codebase to identify refactoring opportunities. Focus on:
   - **Large files** — Files that mix multiple concerns and could benefit from extraction (hooks, utilities, constants)
   - **Duplication** — Repeated styles, logic, or patterns across files
   - **Inconsistency** — Style definitions, naming conventions, or patterns that differ from the rest of the codebase
   - **Magic numbers** — Hardcoded values that should be named constants
   - **Dead code** — Unused imports, variables, or exports

   Use the project's CLAUDE.md to understand conventions and architecture.

2. **Clarify unknowns** — If the analysis reveals ambiguous areas or multiple valid approaches, ask the user before proceeding. Do not make assumptions on ambiguous points.

3. **Draft the plan** — Write a refactoring plan listing each proposal. Use the template in [plan-template.md](plan-template.md) for each proposal. Keep proposals independent — each should be implementable on its own.

4. **Present to the user** — Show the full plan and ask for approval. The user may:
   - Approve all proposals
   - Remove or modify specific proposals
   - Ask for additional analysis

   Do NOT proceed to issue creation until the user explicitly approves.

5. **Create GitHub issues** — For each approved proposal, create a separate GitHub issue using `gh issue create --title "<title>" --body "<plan>"`. Use a HEREDOC for the body to preserve formatting. Title is Short, imperative, in English (e.g., "Extract shared validation logic into a utility module").

6. **Report results** — After all issues are created, show the user a summary table with issue numbers, titles, and URLs.

## Guidelines

- Write all issue content in English (project convention).
- Converse with the user in Japanese (project convention).
- Keep proposals minimal and focused — one concern per issue.
- Do not propose changes that add complexity without clear benefit.
- Reference actual file paths discovered during exploration, not guessed paths.
- For each file change, specify whether it is Create, Modify, or Delete.
- Do not include full code in the plan — describe what changes are needed and why.
- Code snippets are acceptable when they clarify intent (e.g., type definitions, key structures).
