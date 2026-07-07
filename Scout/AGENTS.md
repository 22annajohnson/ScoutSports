# Scout Agent Guide

## Role

This repository is the future Scout monorepo. AI agents should optimize for maintainability, modularity, and clear human review.

## Current Repository State

- The iOS app currently lives at the repository root.
- `apps/ios/` is a placeholder for a future migration.
- `apps/web/` is a placeholder for a future web app migration.
- Do not move production code without an approved migration technical plan.

## Default Workflow

Use the Scout software factory pipeline:

1. Product Vision
2. Technical Plan
3. Approval
4. Jira Tickets
5. Implementation
6. CI
7. Review
8. Merge

## Planning Rules

- Create or update a technical plan before major feature implementation.
- Mark architecture, database, API, design system, project organization, and long-term direction changes as proposals requiring approval.
- Stop before generating implementation tickets that depend on unapproved proposals.
- Break approved plans into small, sequential Jira tickets.
- Keep each ticket scoped to one product domain where possible.

## Implementation Rules

- Follow existing Swift/SwiftUI patterns in the current iOS app.
- Do not refactor unrelated code while addressing focused work.
- Do not change schema, auth flow, storage structure, or project organization without approval.
- Use the repository's existing validation workflow. For the current iOS app, check the root `Makefile`.

## Handoff Expectations

Every handoff should explain:

- What changed
- Which files were touched
- What was verified
- Any risks, blockers, or follow-ups
