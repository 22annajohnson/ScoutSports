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

## Agent Identity

Each active AI agent must know its assigned Scout identity before starting work. The identity should be included in handoffs and PR descriptions.

Current identities:

- `Stephan`: Technical planning lead and documentation/planning reviewer.
- `Tom`: General implementation worker.
- `Jerry`: General implementation worker.

Agents must not request review from themselves. If an agent-created PR would normally route back to the same agent, skip that self-review step and request the next appropriate reviewer.

Review routing:

- Documentation and planning PRs normally use `needs-stephan-review`.
- Stephan-authored documentation or planning PRs skip `needs-stephan-review` and go directly to `needs-human-review`.
- Tom-authored implementation PRs use `needs-ai-review` for Jerry.
- Jerry-authored implementation PRs use `needs-ai-review` for Tom.
- If Tom or Jerry is unavailable, leave `needs-ai-review` and mention the blocker in the handoff.

## Jira Status Rules

- When starting work on a Jira ticket, move the ticket to `In Progress`.
- Pull requests must follow the repository's GitHub PR template. Do not omit required template sections unless they are clearly not applicable and are marked as such.
- Jira automation moves tickets to `Awaiting CI` when a pull request is opened.
- After opening a pull request, monitor your ticket. Jira automation may move it back to `In Progress` if CI checks fail. If this happens, inspect the PR/check failures again, make the needed fix, and push an update.
- Jira automation may move the ticket to `Ready for Review` when CI passes and to `Done` when the PR is merged.
- Do not merge your own PRs unless explicitly instructed.
- Do not manually mark implementation tickets `Awaiting CI`, `Ready for Review`, or `Done` when automation is expected to handle those transitions.

## Testing and CI Expectations

- The first validation pass should run on the pull request through GitHub Actions.
- Agents do not need to run local tests before opening a PR unless the ticket, implementation plan, or reviewer explicitly asks for local validation.
- Run local tests when actively debugging a failed CI check, reproducing a CI failure, or validating a fix before pushing an update.
- Documentation-only and workflow-only PRs should not run iOS tests locally unless they are debugging a failed CI check.
- PR descriptions and handoffs should state that validation is expected to run in PR CI when no local tests were run.

## Pull Request Label Workflow

Agents must use GitHub labels to make review state visible.

General labels:

- `documentation`: PR primarily changes documentation, tech plans, architecture docs, or planning artifacts.
- `ruby`: PR primarily changes CI, GitHub Actions, Fastlane, Ruby scripts, Markdown validation, or repository automation.

Author identity labels:

- `author-stephan`: PR was authored by Stephan.
- `author-tom`: PR was authored by Tom.
- `author-jerry`: PR was authored by Jerry.

When opening a PR, apply the author label that matches your Scout identity.

Documentation PRs:

- When opening a documentation PR, apply `documentation` and `needs-stephan-review`.
- If Stephan authored the documentation PR, do not request Stephan self-review; apply `documentation` and `needs-human-review` instead.
- Stephan reviews for architecture consistency, planning quality, roadmap alignment, implementation readiness, and documentation quality.
- Stephan leaves a written GitHub comment but does not approve.
- If changes are required, remove `needs-stephan-review` and add `needs-changes`.
- After the author addresses feedback, remove `needs-changes` and re-add `needs-stephan-review`.
- When Stephan review is complete, remove `needs-stephan-review` and add `needs-human-review`.

Implementation PRs:

- When opening an implementation PR, apply `needs-ai-review`.
- The opposite worker agent reviews the PR, leaves a written GitHub review comment, and does not approve.
- The reviewer checks Jira scope, approved tech plan alignment, architecture consistency, obvious bugs, maintainability, and test appropriateness.
- If changes are required, remove `needs-ai-review` and add `needs-changes`.
- After the author addresses feedback, remove `needs-changes` and re-add `needs-ai-review`.
- When AI review is complete, remove `needs-ai-review`, add `ai-reviewed`, and add `needs-human-review`.

Human QA and risk labels:

- Add `needs-human-qa` when manual testing is appropriate, including significant UI changes, animations, camera, push notifications, gesture-heavy interactions, accessibility concerns, or anything difficult to validate in CI.
- Add `architecture-risk` when a PR violates approved architecture, introduces technical debt, bypasses repository boundaries, or uses a questionable abstraction.
- Add `scope-risk` when PR scope exceeds Jira, includes feature creep, or bundles unrelated changes.
- Add `follow-up-ticket` when an improvement, cleanup, or deferred work should be tracked after the PR.

PR review rules:

- Agents must never approve PRs.
- Agents must never merge PRs.
- Agents must never review their own PRs.
- Every review must leave a written GitHub comment using the review comment template in `docs/agents/AGENTS.md`.
- Every implementation PR should eventually have `ai-reviewed` and `needs-human-review`.
- Every documentation PR should eventually have `needs-human-review`.

## Handoff Expectations

Every handoff should explain:

- What changed
- Which files were touched
- What was verified
- Any risks, blockers, or follow-ups
