---
name: init-kiro-steering
description: Initialize Kiro steering documents (product.md, structure.md, tech.md) for a project. Use this skill when the user wants to set up Kiro steering files, bootstrap .kiro/steering/, or prepare a project for Kiro spec-driven development.
argument-hint: [path-to-proposal-or-spec-doc]
allowed-tools: Read, Grep, Glob, Bash(ls *), Bash(find *), WebFetch, Write, Edit, Agent
---

# Initialize Kiro Steering Documents

Generate the three foundational Kiro steering files (`product.md`, `structure.md`, `tech.md`) under `.kiro/steering/` based on an existing proposal or spec document and the actual codebase.

## Input

- `$ARGUMENTS` — path to a proposal, PRD, or spec document that describes the product (optional; if omitted, ask the user)

## Steps

### 1. Gather context

Do these in parallel:

- **Read the proposal/spec document** at `$ARGUMENTS` to extract product vision, target users, features, monetization, and business objectives.
- **Explore the codebase** to understand:
  - Directory structure (especially routing, components, config files)
  - Tech stack from `package.json`, `tsconfig.json`, framework config files
  - CI/CD setup
  - Existing conventions (naming, imports, formatting)

### 2. Check Kiro best practices

Fetch the official Kiro steering documentation to ensure the output follows current recommendations:

- https://kiro.dev/docs/steering/

Key principles to follow:
- Each file gets YAML front matter with `inclusion: always`
- Explain **why** behind decisions, not just **what** the standards are
- Use live file references: `#[[file:relative_path]]` to link to actual project files
- Keep each file focused on a single domain

### 3. Create `.kiro/steering/` directory

```bash
mkdir -p .kiro/steering
```

### 4. Write the three files

#### `product.md` — Product context

Extract from the proposal and organize into these sections:

- **What is the product?** — one-paragraph summary + tagline
- **Target Users** — primary audience, core pain point, current workarounds
- **Business Objectives** — short/medium-term goals, success metrics
- **Key Design Principles** — each with a "Why:" explaining the reasoning
- **Feature Roadmap** — MVP vs later phases, numbered list
- **Monetization** — pricing table and rationale

#### `structure.md` — Code structure

Discover from the actual codebase and document:

- **Directory Layout** — tree diagram of key directories
- **Routing** — framework, conventions, typed routes if applicable
- **Navigation** — current navigation structure
- **Naming Conventions** — files, components, hooks, utilities
- **Import Aliases** — configured path aliases with examples
- **State Management** — current approach or "not yet decided"
- **Data Persistence** — current approach or "not yet decided"

Include `#[[file:...]]` references to relevant config files (e.g., tsconfig.json, layout files).

#### `tech.md` — Tech stack & constraints

Discover from package.json, config files, and CI setup:

- **Core Stack** — table with Layer / Technology / Why columns
- **Experimental Features** — if any, with rationale
- **Development Commands** — common dev, lint, test, build commands
- **CI Pipeline** — what runs and when
- **Key Dependencies** — already-installed packages with one-line descriptions
- **Constraints** — package manager rules, git workflow, language conventions

Include `#[[file:...]]` references to package.json, framework config, CI workflow files.

### 5. Verify

After writing, re-read all three files and check:

- [ ] YAML front matter `inclusion: always` is present in each file
- [ ] "Why" explanations are included for key decisions
- [ ] `#[[file:...]]` references point to files that actually exist
- [ ] Content is derived from the actual codebase, not assumed
- [ ] No sensitive data (API keys, secrets) is included

## Guidelines

- Derive everything from the proposal doc and actual codebase — do not invent information.
- If the proposal is missing business objectives or monetization, note them as "TBD" rather than guessing.
- Keep files concise. Steering docs are loaded into every Kiro session, so brevity matters.
- Use English for all file content (following typical Kiro conventions).
