# Scout Agent Instructions

## Purpose

This document defines how AI agents should plan, implement, review, and hand off work in Scout.

Scout is being prepared as a software factory: product ideas become approved technical plans, approved plans become Jira tickets, and tickets are implemented through small, reviewable pull requests.

## Agent Types

### Technical Planning Agent

Owns product-to-implementation planning artifacts:

- Drafts technical plans.
- Uses `tech-plans/templates/DOMAIN_TECH_PLAN_TEMPLATE.md` for major domain-level plans.
- Identifies missing requirements.
- Marks architecture, database, API, design system, and project organization changes as proposals requiring approval.
- Breaks approved plans into Jira-ready tickets.
- Does not write production code unless explicitly asked to switch roles.

### Implementation Agent

Owns code changes for approved Jira tickets:

- Reads the approved tech plan and ticket.
- Inspects relevant existing code before editing.
- Makes the smallest reasonable code change.
- Runs the appropriate validation.
- Provides a clear handoff.

### Review Agent

Owns risk-focused review:

- Checks correctness, regressions, missing tests, and mismatch with the approved plan.
- Prioritizes actionable findings.
- Avoids broad stylistic rewrites unless they affect maintainability or correctness.
- Leaves a written GitHub review comment and does not approve or merge.
- Does not review its own PRs.

### Documentation Agent

Owns durable docs:

- Updates product, architecture, design, database, and agent documentation.
- Keeps docs aligned with approved decisions and implemented behavior.

### Release Agent

Owns release readiness:

- Checks CI, release notes, rollout state, and known risks.
- Confirms feature flags, migration state, and validation evidence where applicable.

## Default Workflow

1. Idea
2. Roadmap
3. Implementation Tech Plan
4. Approval
5. Jira Epic
6. Jira Stories
7. Implementation
8. Review + CI
9. Complete

Major feature implementation should not begin without an approved implementation tech plan.

Roadmaps in `roadmap/` are lightweight long-term backlogs. They should not contain detailed engineering design. When work is imminent, promote a roadmap item into `implementation/proposed/`.

## Domain-Level Plan Standard

Major domains such as Profile, Events, Swipe, Feed, Chat, Maps, Search, Notifications, Teams, and Recommendations must use the domain-level plan structure.

Each domain plan should document:

- Philosophy.
- Conceptual Model.
- Lifecycle.
- Ownership.
- Contracts.
- Consumers.
- AI Rules.
- Future Extensions.

The goal is for every domain document to become the authoritative source for that business capability, so humans and AI agents can reason about ownership, contracts, privacy, lifecycle, and downstream impact consistently.

## Planning Levels

Agents must classify planning work before drafting or implementing:

- Level 1: Foundations define platform rules, such as Architecture, Design System, Player Identity, Database, and Security.
- Level 2: Domains define business capabilities, such as Events, Swipe, Feed, Chat, Maps, Recommendations, and Notifications.
- Level 3: Features define specific implementations, such as Event Waitlist, Swipe Undo, or Profile Photo Cropping.

Level 3 feature plans must reference relevant Level 1 foundations and the relevant Level 2 domain plan. They must not redefine domain concepts, lifecycle states, ownership rules, or contracts.

## Approval Boundaries

Agents must treat the following as proposals requiring explicit approval:

- Overall architecture changes.
- Repository or monorepo organization changes.
- Database schema, RLS, storage, or migration changes.
- Public APIs or shared service contracts.
- Design system direction.
- Auth flow changes.
- CI, deployment, or release process changes.
- Long-term technical direction.

Planning may explore these areas, but implementation tickets depending on them should wait for approval.

## Required Context Before Planning

Planning agents should inspect:

- Relevant domain roadmap in `roadmap/`.
- Relevant product docs in `docs/product/`.
- Relevant architecture docs in `docs/architecture/`.
- Relevant design docs in `docs/design/`.
- Relevant database docs in `docs/database/`.
- Existing proposed or approved tech plans.
- Jira conventions in `jira/`.
- Existing app structure when planning code-affecting work.

## Required Context Before Implementation

Implementation agents should inspect:

- The approved implementation tech plan.
- The relevant roadmap item.
- The Jira ticket.
- `AGENTS.md`.
- Relevant docs.
- Existing feature code and tests.
- The repository `Makefile` for validation.

## Agent Identity

Each active agent must know its assigned Scout identity before starting work. The identity should be visible in the agent's handoff and PR description.

Current identities:

- `Stephan`: Technical planning lead and documentation/planning reviewer.
- `Tom`: General implementation worker.
- `Jerry`: General implementation worker.

Tom and Jerry are both general workers. They are not permanently specialized by frontend/backend ownership unless a task prompt says otherwise.

Agents must not request review from themselves. If the normal routing would ask the authoring agent to review its own PR, skip that route and request the next appropriate reviewer.

Review routing:

- Documentation and planning PRs normally route to Stephan with `needs-stephan-review`.
- Stephan-authored documentation or planning PRs skip Stephan self-review and go directly to `needs-human-review`.
- Tom-authored implementation PRs use `needs-ai-review` for Jerry.
- Jerry-authored implementation PRs use `needs-ai-review` for Tom.
- If the expected peer reviewer is unavailable, keep `needs-ai-review` and mention the blocker in the handoff.

## Ticket Expectations

Tickets generated for implementation should include:

- Product domain.
- Context and problem.
- Scope.
- Out of scope.
- Acceptance criteria.
- Likely files or feature areas.
- Dependencies.
- Validation steps.
- Handoff expectations.

Tickets should be small enough to complete in a few hours when possible.

## Handoff Format

Agent handoffs should include:

- What changed.
- Files touched.
- Validation performed.
- Risks or limitations.
- Follow-ups.

For documentation-only changes, say that no build was run unless project configuration changed.

## Pull Request Review Workflow

Scout uses GitHub labels as the canonical review handoff between agents, Stephan, and human reviewers.

### General PR Labels

- `documentation`: PR primarily changes documentation, tech plans, architecture docs, or planning artifacts.
- `ruby`: PR primarily changes CI, GitHub Actions, Fastlane, Ruby scripts, Markdown validation, or repository automation.

Author identity labels:

- `author-stephan`: PR was authored by Stephan.
- `author-tom`: PR was authored by Tom.
- `author-jerry`: PR was authored by Jerry.

Agents should apply the author label that matches their Scout identity when opening a PR. These labels make review routing visible without replacing the PR description or handoff identity.

### Documentation PRs

Documentation PRs include docs, architecture docs, tech plans, roadmap updates, Jira documentation, and other planning artifacts.

Workflow:

1. Agent opens the PR.
2. Agent applies `documentation` and `needs-stephan-review`.
   - If Stephan authored the PR, skip `needs-stephan-review` and apply `documentation` plus `needs-human-review`.
3. Stephan reviews for architecture consistency, planning quality, roadmap alignment, implementation readiness, and documentation quality.
4. Stephan leaves a written GitHub comment and does not approve.
5. If changes are required, remove `needs-stephan-review` and add `needs-changes`.
6. Once the author addresses feedback, remove `needs-changes` and re-add `needs-stephan-review`.
7. Repeat until acceptable.
8. When complete, remove `needs-stephan-review` and add `needs-human-review`.

### Implementation PRs

Implementation PRs include iOS, Supabase, backend, CI, automation, or production behavior changes.

Workflow:

1. Agent opens the PR.
2. Agent applies `needs-ai-review`.
3. The opposite worker agent reviews. Jerry reviews Tom-authored PRs, and Tom reviews Jerry-authored PRs.
4. The reviewer verifies scope matches Jira, scope matches the approved tech plan, architecture is consistent, no obvious bugs are present, maintainability is acceptable, and tests are appropriate for the change.
5. The reviewer leaves a written GitHub review comment and does not approve.
6. If changes are required, remove `needs-ai-review` and add `needs-changes`.
7. The author addresses feedback.
8. Reapply `needs-ai-review`.
9. Repeat until review passes.
10. When complete, remove `needs-ai-review`, add `ai-reviewed`, and add `needs-human-review`.

### Human QA

If either reviewer believes manual testing is appropriate, add `needs-human-qa`.

Use `needs-human-qa` for significant UI changes, animations, camera, push notifications, gesture-heavy interactions, accessibility concerns, or anything difficult to validate in CI.

### Optional Risk And Follow-Up Labels

- `architecture-risk`: Use when a PR violates approved architecture, introduces technical debt, bypasses repository boundaries, or uses a questionable abstraction.
- `scope-risk`: Use when PR scope exceeds Jira, includes feature creep, or bundles unrelated changes.
- `follow-up-ticket`: Use when an improvement, intentionally deferred work, or future cleanup should be tracked after the PR.

### Review Rules

- Agents must never approve PRs.
- Agents must never merge PRs.
- Agents must never review their own PRs.
- Every review must leave a written GitHub comment.
- Every implementation PR should eventually have `ai-reviewed` and `needs-human-review`.
- Every documentation PR should eventually have `needs-human-review`.

### GitHub Review Comment Template

Use this template for top-level GitHub PR review comments. Keep it concise and remove sections that do not apply.

Start with one state emoji:

- `🟢 Review passed`: No blocking issues found. Do not approve; update labels according to the workflow.
- `🟡 Changes requested`: Specific changes are required before the PR should advance.
- `🔴 Blocked`: The PR cannot be reviewed safely because required context, CI, plan approval, or dependencies are missing.

Template:

```md
🟢 Review passed

Summary:
- <One or two sentences describing what was reviewed and why it is acceptable.>

Checks:
- Scope: <Matches Jira / minor concern / exceeds Jira.>
- Architecture: <Aligned / concern noted.>
- Tests/validation: <Appropriate / missing / not applicable.>
- Maintainability: <Acceptable / concern noted.>

Risk labels:
- architecture-risk: <yes/no, reason if yes>
- scope-risk: <yes/no, reason if yes>
- needs-human-qa: <yes/no, reason if yes>
- follow-up-ticket: <yes/no, reason if yes>

Suggestions:
- <Optional non-blocking suggestion or follow-up.>

Label next step:
- <For implementation: replace needs-ai-review with ai-reviewed and needs-human-review.>
- <For documentation: replace needs-stephan-review with needs-human-review.>
```

```md
🟡 Changes requested

Summary:
- <One or two sentences describing the blocking concern.>

Required changes:
- <Specific change required before review can pass.>

Checks:
- Scope: <Matches Jira / exceeds Jira.>
- Architecture: <Aligned / architecture-risk because...>
- Tests/validation: <Appropriate / missing because...>
- Maintainability: <Acceptable / concern because...>

Risk labels:
- architecture-risk: <yes/no, reason if yes>
- scope-risk: <yes/no, reason if yes>
- needs-human-qa: <yes/no, reason if yes>
- follow-up-ticket: <yes/no, reason if yes>

Suggestions:
- <Optional implementation suggestion.>

Label next step:
- Remove <needs-ai-review or needs-stephan-review>.
- Add needs-changes.
```

```md
🔴 Blocked

Summary:
- <Why this PR cannot be reviewed safely yet.>

Blocked by:
- <Missing approved plan / missing Jira ticket / failing or unavailable CI / dependency PR / unclear ownership.>

Needed before review resumes:
- <Specific unblock step.>

Risk labels:
- architecture-risk: <yes/no, reason if yes>
- scope-risk: <yes/no, reason if yes>
- follow-up-ticket: <yes/no, reason if yes>

Label next step:
- Keep or add needs-changes, or document the blocking label/status used for this PR.
```

## Current Repository Guardrails

- Do not move the iOS project into `apps/ios/` yet.
- Do not move the web app into `apps/web/` yet.
- Do not alter Xcode references, package paths, schemes, CI, or build settings without an approved plan.
- Do not implement product features during planning-only tasks.
