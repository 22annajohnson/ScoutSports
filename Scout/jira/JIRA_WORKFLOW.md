# Scout Jira Workflow

## Purpose

Scout Jira should turn approved technical plans into small, sequential, independently reviewable implementation tickets.

## Project Organization

Use the following Jira project keys:

- `ARCH`: Architecture, technical direction, cross-cutting decisions, monorepo structure, and system-wide refactors.
- `CORE`: Core product infrastructure, shared app foundations, authentication foundations, data access foundations, CI, and developer experience.
- `SOCIAL`: User-facing social features such as profiles, swipe, match, feed, messaging, events, and connection flows.
- `INFRA`: Backend infrastructure, Supabase, migrations, storage, deployment, observability, and environment management.

Additional domain keys may be proposed later, but adding or changing project organization requires explicit approval.

## Epic Conventions

Epics should map to approved technical plans or clearly bounded product initiatives.

Epic names should use this format:

`<DOMAIN>: <Outcome-Oriented Initiative>`

Examples:

- `SOCIAL: Improve Swipe Match Quality`
- `CORE: Standardize Auth Session Handling`
- `INFRA: Document Supabase Storage Policies`
- `ARCH: Prepare Monorepo Application Layout`

Each epic should include:

- Link to approved technical plan
- Product domain
- Problem statement
- Goals and non-goals
- Dependencies
- Milestones
- Definition of Done

## Ticket Naming Conventions

Tickets should use this format:

`<Domain>: <Imperative implementation task>`

Examples:

- `Profile: Add editable skill level field`
- `Swipe: Load candidate cards from repository`
- `Infra: Document profile image storage paths`
- `Core: Add session restoration test coverage`

Ticket descriptions should include:

- Jira ticket key
- Approved tech plan
- Affected repo area: `iOS`, `web`, `Supabase`, `docs`, or `CI/CD`
- Context
- Scope
- Out of scope
- Acceptance criteria
- Implementation notes
- Dependencies
- Validation steps
- Links to relevant docs, plans, and designs

## Ticket Sizing

Prefer tickets that can be completed in a few hours.

Story points estimate developer-day effort for an AI-assisted workflow, including both agent implementation time and human review time.

Use fractional story points in `0.25` increments. Values such as `0.75`, `1.25`, and `1.5` are valid when they best represent the combined implementation, validation, review, and revision effort.

- `0.25`: Agent can complete the work and a human can review it in about 2 total hours.
- `0.5`: Agent implementation takes about 2 hours and human review takes about 2 hours.
- `1`: Roughly one developer day of combined implementation, validation, review, and revision effort.
- `2+`: Larger than one developer day and should usually be split unless there is a clear reason not to.

When estimating, include:

- Agent implementation time.
- Human review time.
- Expected revision time.
- Validation time.
- Documentation or ticket handoff time.

Tickets should be:

- Independently reviewable
- Small enough for one focused implementation pass
- Explicit about dependencies
- Clear about validation expectations
- Scoped to one product domain when possible

Avoid tickets that combine unrelated UI, backend, data model, and CI changes unless the coupling is unavoidable and explained.

## Workflow

Scout work should follow this pipeline:

1. Idea
2. Roadmap
3. Implementation Tech Plan
4. Approval
5. Jira Epic
6. Jira Stories
7. Implementation
8. Review + CI
9. Complete

Roadmap items should stay lightweight until work is imminent. Once a roadmap item is ready to begin, create a detailed implementation tech plan in `implementation/proposed/`. After approval, move it to `implementation/approved/`, create the Jira epic and stories, then move it through `implementation/in-progress/` and `implementation/complete/` as work progresses.

## Status Guidance

Suggested Jira statuses:

- `Backlog`: Work identified but not ready.
- `Planning`: Product or technical plan is being drafted.
- `Ready for Approval`: Plan or ticket is waiting for owner review.
- `Ready for Dev`: Ticket is approved and unblocked.
- `In Progress`: Implementation is active.
- `Awaiting CI`: Pull request is open and CI is running.
- `Ready for Review`: CI has passed and the pull request is ready for human review.
- `Blocked`: Work cannot continue without a decision or dependency.
- `Done`: Work is merged and accepted.

## Ticket Status Automation

Agents are responsible for starting work and monitoring their own PRs:

- When an agent starts a ticket, it must move the Jira ticket to `In Progress`.
- Pull requests must follow the repository's GitHub PR template. Required template sections should be completed, or marked as not applicable with a short explanation.
- Pull requests must follow the canonical GitHub label review workflow in `AGENTS.md` and `docs/agents/AGENTS.md`.

Scout Jira automation handles PR, CI, review, and merge transitions:

- When a pull request is opened, automation may move the ticket to `Awaiting CI`.
- If CI checks fail, automation may move the ticket from `Awaiting CI` back to `In Progress`.
- If CI checks pass, automation may move the ticket to `Ready for Review`.
- If the pull request is merged, automation may move the ticket to `Done`.

After opening a pull request, an agent should monitor its ticket. When an agent notices that one of its tickets has moved back to `In Progress`, it should treat that as a signal to inspect the pull request, review failed checks, update the code or documentation as needed, and push a follow-up commit. Agents should not ignore tickets that automation returns to `In Progress`.

Agents should not manually mark their own implementation tickets `Awaiting CI`, `Ready for Review`, or `Done` when Jira automation is configured to do so. If automation does not run, the agent should mention the status gap in its handoff rather than guessing.

## Pull Request Label Workflow

Jira status and GitHub labels answer different questions. Jira tracks ticket execution state, while GitHub labels track PR review ownership and risk.

General PR labels:

- `documentation`: Documentation, tech plans, architecture docs, or planning artifacts.
- `ruby`: CI, GitHub Actions, Fastlane, Ruby scripts, Markdown validation, or repository automation.

Author identity labels:

- `author-stephan`: PR was authored by Stephan.
- `author-tom`: PR was authored by Tom.
- `author-jerry`: PR was authored by Jerry.

Agents should apply the author label that matches their Scout identity when opening a PR.

Documentation PRs:

- Start with `documentation` and `needs-stephan-review`.
- If Stephan authored the documentation PR, skip Stephan self-review and start with `documentation` and `needs-human-review`.
- Stephan reviews for architecture consistency, planning quality, roadmap alignment, implementation readiness, and documentation quality.
- Stephan leaves a written GitHub comment and does not approve.
- If changes are required, use `needs-changes`.
- When Stephan review is complete, replace `needs-stephan-review` with `needs-human-review`.

Implementation PRs:

- Start with `needs-ai-review`.
- The opposite worker agent reviews, leaves a written GitHub review comment, and does not approve. Jerry reviews Tom-authored PRs, and Tom reviews Jerry-authored PRs.
- If changes are required, use `needs-changes`.
- When AI review is complete, replace `needs-ai-review` with `ai-reviewed` and `needs-human-review`.

Manual QA and risk labels:

- Use `needs-human-qa` for significant UI changes, animations, camera, push notifications, gesture-heavy interactions, accessibility concerns, or anything difficult to validate in CI.
- Use `architecture-risk` for architecture violations, technical debt, bypassed repository boundaries, or questionable abstractions.
- Use `scope-risk` for PRs that exceed Jira scope, include feature creep, or bundle unrelated changes.
- Use `follow-up-ticket` when deferred work or cleanup should be tracked separately.

Agents must never approve PRs, merge PRs, or review their own PRs.

Agents should include their Scout identity in PR descriptions and handoffs.

## Approval Rules

Explicit approval is required before implementation tickets are created for changes to:

- Overall architecture
- Database schema, RLS, storage, or migrations
- Public APIs or shared service contracts
- Design system direction
- Repository organization
- Long-term technical direction

An Architecture Decision Record in `docs/decisions/` is required before implementation for changes to:

- App structure
- Backend ownership
- Database architecture
- Auth strategy
- Shared packages
- CI strategy

## Architecture Planning Tickets

Architecture foundation tickets should be documentation or planning tickets unless an approved technical plan explicitly authorizes implementation.

For `ARCH-001`, Jira breakdown should be limited to:

- `ARCH: Document architecture authority model`
- `ARCH: Create ADR template for major architecture decisions`
- `ARCH: Document current approved repository state`
- `ARCH: Document implementation ticket reference requirements`
- `ARCH: Draft iOS migration technical plan`
- `ARCH: Draft web migration technical plan`
- `ARCH: Document future monorepo CI planning questions`

Do not create migration implementation tickets from `ARCH-001`. Moving iOS or web requires a separate approved migration plan.

## AI Agent Expectations

Jira tickets should be written so an AI coding agent can implement them without guessing. Each ticket should identify the files or feature areas likely to be touched, validation commands, edge cases, and expected handoff notes.
