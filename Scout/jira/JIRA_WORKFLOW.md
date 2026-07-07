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
2. Tech Plan
3. Approval
4. Jira
5. Implementation
6. Pull Request
7. CI
8. Review
9. Merge

## Status Guidance

Suggested Jira statuses:

- `Backlog`: Work identified but not ready.
- `Planning`: Product or technical plan is being drafted.
- `Ready for Approval`: Plan or ticket is waiting for owner review.
- `Ready for Dev`: Ticket is approved and unblocked.
- `In Progress`: Implementation is active.
- `In Review`: Pull request is open.
- `Blocked`: Work cannot continue without a decision or dependency.
- `Done`: Work is merged and accepted.

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
