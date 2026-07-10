# ScoutSports

[![iOS Tests](https://github.com/22annajohnson/ScoutSports/actions/workflows/ios-tests.yml/badge.svg?branch=develop)](https://github.com/22annajohnson/ScoutSports/actions/workflows/ios-tests.yml)
[![Docs Validation](https://github.com/22annajohnson/ScoutSports/actions/workflows/docs-validation.yml/badge.svg?branch=develop)](https://github.com/22annajohnson/ScoutSports/actions/workflows/docs-validation.yml)
[![GitHub Actions Validation](https://github.com/22annajohnson/ScoutSports/actions/workflows/github-actions-validation.yml/badge.svg?branch=develop)](https://github.com/22annajohnson/ScoutSports/actions/workflows/github-actions-validation.yml)

Scout is a Swift/SwiftUI product for helping people find compatible local sports partners and get into real-world games, starting with pickleball.

This repository currently contains the iOS app and planning foundation. It is being prepared to become the future Scout monorepo. The existing iOS app still lives under `Scout/` at the current app location; `Scout/apps/ios/` and `Scout/apps/web/` are placeholders for future migrations and must not receive moved production code without an approved migration plan.

## Table of Contents

- [Current State](#current-state)
- [Repository Map](#repository-map)
- [Documentation Entry Points](#documentation-entry-points)
- [Planning Workflow](#planning-workflow)
- [Jira Workflow](#jira-workflow)
- [Implementation Rules](#implementation-rules)
- [CI and Validation](#ci-and-validation)
- [README Naming Convention](#readme-naming-convention)
- [Working With Agents](#working-with-agents)
- [What Not To Do Yet](#what-not-to-do-yet)

## Current State

- The iOS application is currently in `Scout/` and has not been moved into `Scout/apps/ios/`.
- The future web app currently lives outside this repository; `Scout/apps/web/` is a placeholder.
- Supabase work is currently documentation and planning focused unless an approved implementation plan explicitly authorizes schema, migration, storage, or Edge Function work.
- Approved foundation plans define architecture, design, player identity, events, discovery, and implementation guardrails.
- Jira is the source of truth for executable implementation work once a plan is approved.

## Repository Map

| Path | Purpose |
| --- | --- |
| `Scout/` | Current iOS app, ScoutDesign package, planning docs, and future monorepo scaffolding. |
| `Scout/Scout/` | Current Swift/SwiftUI app source. |
| `Scout/ScoutDesign/` | Local Swift package for reusable Scout design-system primitives. |
| `Scout/apps/` | Future app workspace placeholders. Do not move production app code here yet. |
| `Scout/backend/` | Backend planning surface, including Supabase documentation placeholders. |
| `Scout/docs/` | Foundation documentation for product, architecture, design, database, agents, and decisions. |
| `Scout/roadmap/` | Living domain roadmaps and dependency dashboard. |
| `Scout/tech-plans/` | Approved domain/foundation technical plans and reusable templates. |
| `Scout/implementation/` | Proposed, approved, in-progress, and complete implementation tech plans. |
| `Scout/jira/` | Jira workflow, ticket conventions, and delivery-process documentation. |
| `.github/` | GitHub Actions, PR template, issue templates, CODEOWNERS, and repository automation docs. |

## Documentation Entry Points

Start here for orientation:

- [Agent guide](Scout/AGENTS.md)
- [Roadmap dashboard](Scout/ROADMAP.md)
- [Roadmap system](Scout/roadmap/README_roadmap.md)
- [Jira workflow](Scout/jira/JIRA_WORKFLOW.md)
- [Approved tech plans](Scout/tech-plans/approved/README_approved.md)
- [Implementation planning](Scout/implementation/README_implementation.md)
- [Architecture docs](Scout/docs/architecture/README_architecture.md)
- [Design docs](Scout/docs/design/README_design.md)
- [Database docs](Scout/docs/database/README_database.md)
- [Agent docs](Scout/docs/agents/README_agents.md)
- [GitHub automation docs](.github/README_github.md)

## Planning Workflow

Scout uses a software-factory workflow:

```text
Idea
  -> Roadmap
  -> Implementation Tech Plan
  -> Approval
  -> Jira Epic
  -> Jira Stories
  -> Implementation
  -> Review + CI
  -> Complete
```

Use `Scout/roadmap/` for lightweight long-term domain planning. Promote imminent work into `Scout/implementation/proposed/`. After approval, move the plan to `Scout/implementation/approved/` and create Jira epics/stories from that approved plan.

Do not generate implementation work from roadmap ideas alone.

## Jira Workflow

Jira tickets should follow [Scout Jira Workflow](Scout/jira/JIRA_WORKFLOW.md).

Key rules:

- Move a ticket to `In Progress` when starting work.
- Open focused PRs that follow the GitHub PR template.
- Jira automation moves tickets to `Awaiting CI` when a PR opens.
- If automation moves a ticket back to `In Progress`, inspect failed checks and update the PR.
- Jira automation may move tickets to `Ready for Review` after CI passes and `Done` after merge.
- Do not merge your own PRs unless explicitly instructed.

## Implementation Rules

Before implementation work, read the relevant plan and docs:

- `Scout/AGENTS.md`
- `Scout/ROADMAP.md`
- Related approved foundation/domain tech plans in `Scout/tech-plans/approved/`
- Related implementation plan in `Scout/implementation/approved/`
- Related Jira epic and story

Implementation should be small, reviewable, and scoped to the ticket. Do not change architecture, schema, auth, storage, public APIs, design-system direction, project structure, or CI strategy without explicit approval and the required ADR/tech plan.

## CI and Validation

Primary workflows live in `.github/workflows/`.

- `iOS Tests` runs Swift/iOS validation for app-relevant changes.
- `Docs Validation` validates Markdown/documentation changes.
- `GitHub Actions Validation` validates workflow/config syntax.

Docs-only and GitHub metadata/config-only changes should avoid unnecessary iOS macOS jobs where path filtering supports that. App-relevant changes must still run iOS validation.

For local iOS validation, check `Scout/Makefile` before inventing custom commands.

## README Naming Convention

Only this root file should be named `README.md`.

Nested repo-owned guide files should use contextual names:

```text
README_{context}.md
```

Examples:

- `Scout/docs/README_docs.md`
- `Scout/jira/README_jira.md`
- `Scout/apps/ios/README_ios.md`
- `Scout/implementation/proposed/README_proposed.md`

Generated dependency/build-output README files should not be renamed or edited.

## Working With Agents

AI agents should treat this repository as a long-term product system, not a scratchpad.

Agents should:

- Follow [Scout Agent Guide](Scout/AGENTS.md).
- Prefer existing patterns over new abstractions.
- Keep PRs small and tied to Jira stories.
- Preserve current iOS project paths until a migration plan is approved.
- Use approved tech plans as authority for implementation decisions.
- Follow the GitHub PR template.
- Leave clear handoffs with changed files, validation, risks, and follow-ups.

## What Not To Do Yet

- Do not move the iOS app into `Scout/apps/ios/`.
- Do not move the web app into `Scout/apps/web/`.
- Do not create Supabase migrations, tables, buckets, or Edge Functions without an approved implementation plan.
- Do not change Xcode paths, schemes, package references, or build settings as part of documentation work.
- Do not create implementation tickets from roadmap ideas that have not been promoted into approved implementation plans.
