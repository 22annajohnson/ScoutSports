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

1. Idea
2. Roadmap
3. Implementation Tech Plan
4. Approval
5. Jira Epic
6. Jira Stories
7. Implementation
8. Review + CI
9. Complete

## Planning Rules

- Use `roadmap/` for lightweight long-term domain backlog items.
- Promote imminent work into `implementation/proposed/` before detailed engineering design begins.
- Create or update an implementation tech plan before major feature implementation.
- Mark architecture, database, API, design system, project organization, and long-term direction changes as proposals requiring approval.
- Stop before generating implementation tickets that depend on unapproved proposals.
- Break approved plans into small, sequential Jira tickets.
- Keep each ticket scoped to one product domain where possible.

## Implementation Rules

- Follow existing Swift/SwiftUI patterns in the current iOS app.
- Do not refactor unrelated code while addressing focused work.
- Do not change schema, auth flow, storage structure, or project organization without approval.
- Use the repository's existing validation workflow. For the current iOS app, check the root `Makefile`.

## Jira Status Rules

- When starting work on a Jira ticket, move the ticket to `In Progress`.
- Pull requests must follow the repository's GitHub PR template. Do not omit required template sections unless they are clearly not applicable and are marked as such.
- Jira automation moves tickets to `Awaiting CI` when a pull request is opened.
- After opening a pull request, monitor your ticket. Jira automation may move it back to `In Progress` if CI checks fail. If this happens, inspect the PR/check failures again, make the needed fix, and push an update.
- Jira automation may move the ticket to `Ready for Review` when CI passes and to `Done` when the PR is merged.
- Do not merge your own PRs unless explicitly instructed.
- Do not manually mark implementation tickets `Awaiting CI`, `Ready for Review`, or `Done` when automation is expected to handle those transitions.

## Handoff Expectations

Every handoff should explain:

- What changed
- Which files were touched
- What was verified
- Any risks, blockers, or follow-ups
