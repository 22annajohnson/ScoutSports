# Contributing to Scout

## Purpose

Define how humans and AI agents contribute to Scout.

## Contribution Workflow

Scout work follows the software factory pipeline:

1. Idea.
2. Roadmap.
3. Implementation Tech Plan.
4. Approval.
5. Jira Epic.
6. Jira Stories.
7. Implementation.
8. Review + CI.
9. Complete.

Major feature work should not skip approved planning, Jira breakdown, implementation, CI, and review.

## Technical Plans

Create or update an implementation tech plan before major feature implementation. Architecture, database, API, design system, project organization, auth, CI, and long-term technical direction changes require explicit approval before implementation begins.

## Jira Tickets

Approved plans become small, independently reviewable Jira stories. When starting a ticket, move it to `In Progress`. Do not manually move tickets to `Awaiting CI`, `Ready for Review`, or `Done` when automation is expected to handle those transitions.

## Branches and Pull Requests

Pull requests must follow the repository's GitHub PR template. Required sections should be completed or marked not applicable with a short explanation.

Use these general labels:

- `documentation`: Documentation, tech plans, architecture docs, or planning artifacts.
- `ruby`: CI, GitHub Actions, Fastlane, Ruby scripts, Markdown validation, or repository automation.

Use the author label that matches the PR author's Scout identity:

- `author-stephan`: PR was authored by Stephan.
- `author-tom`: PR was authored by Tom.
- `author-jerry`: PR was authored by Jerry.

Documentation PR workflow:

1. Open the PR with `documentation` and `needs-stephan-review`.
   - If Stephan authored the PR, skip Stephan self-review and open with `documentation` plus `needs-human-review`.
2. Stephan reviews for architecture consistency, planning quality, roadmap alignment, implementation readiness, and documentation quality.
3. Stephan leaves a written GitHub comment and does not approve.
4. If changes are required, use `needs-changes`.
5. Once addressed, reapply `needs-stephan-review`.
6. When complete, replace `needs-stephan-review` with `needs-human-review`.

Implementation PR workflow:

1. Open the PR with `needs-ai-review`.
2. The opposite worker agent reviews for Jira scope, approved-plan alignment, architecture consistency, obvious bugs, maintainability, and appropriate tests. Jerry reviews Tom-authored PRs, and Tom reviews Jerry-authored PRs.
3. The reviewer leaves a written GitHub comment and does not approve.
4. If changes are required, use `needs-changes`.
5. Once addressed, reapply `needs-ai-review`.
6. When complete, replace `needs-ai-review` with `ai-reviewed` and `needs-human-review`.

Agents must never approve PRs, merge PRs, or review their own PRs. Every review must leave a written GitHub comment using the template in `docs/agents/AGENTS.md`.

Agents should include their Scout identity in PR descriptions and handoffs. Current identities are Stephan, Tom, and Jerry. Tom and Jerry are general workers unless a task prompt assigns a temporary specialty.

Use `needs-human-qa` when manual testing is appropriate, including significant UI changes, animations, camera, push notifications, gesture-heavy interactions, accessibility concerns, or anything difficult to validate in CI.

Optional risk labels:

- `architecture-risk`: Architecture violation, technical debt, bypassed repository boundary, or questionable abstraction.
- `scope-risk`: Scope exceeds Jira, feature creep, or unrelated bundled changes.
- `follow-up-ticket`: Deferred improvement, cleanup, or future work should be tracked separately.

## CI and Validation

PR CI is the default first full validation pass. Agents do not need to run the full local test suite before opening a PR unless the ticket, approved implementation plan, task prompt, or reviewer explicitly requires local validation.

Run targeted local tests when actively debugging a failed CI check, reproducing a CI failure, capturing requested visual evidence, or validating a fix before pushing an update. Avoid defaulting to `make test` for small changes while it may boot multiple simulators.

Documentation-only changes should state that no build was run unless project configuration changed. After opening a PR, monitor Jira and GitHub; if automation moves a ticket back to `In Progress` because CI failed, inspect the failure, fix it, and push an update.

## Documentation Updates

Update durable documentation when a change alters approved behavior, workflows, architecture, design guidance, database expectations, CI behavior, or agent instructions.
