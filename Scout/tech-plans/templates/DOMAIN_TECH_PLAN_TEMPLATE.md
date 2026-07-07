# Domain Tech Plan: <Domain Name>

## Status

Proposed

## Owner

TODO

## Product Domain

TODO

## Planning Level

Level 2: Domain

References:

- Level 1 foundation documents:
- Related Level 2 domain plans:

## Purpose

Describe why this document is the authoritative source for the domain and which future plans, Jira tickets, and AI agents should reference it.

## Problem Statement

Describe the user problem, business problem, and system problem this domain solves.

## Philosophy

Explain why this system exists and what user outcome it serves.

This section should answer:

- What real user problem does this domain solve?
- What product behavior should this domain encourage?
- What should this domain avoid optimizing for?
- How does this domain support Scout's mission of helping people connect offline through sports?

## Conceptual Model

Define the core entities, concepts, and relationships in the domain.

Use a modular structure similar to:

```text
<Domain>
├── <Concept>
├── <Concept>
├── <Concept>
└── <Concept>
```

Include Mermaid diagrams when relationships are easier to understand visually.

## Lifecycle

Describe how the primary entities evolve over time.

Include:

- Lifecycle stages.
- Allowed transitions.
- Who or what can trigger transitions.
- What user actions are available at each stage.
- What system behavior changes at each stage.

Use a Mermaid state diagram when useful.

## Ownership

Document which system owns each concept and which systems only consume it.

Include an ownership matrix:

| Concept | Owning System | Consumers | Boundary Rule |
| --- | --- | --- | --- |
| TODO | TODO | TODO | TODO |

The owning system is responsible for the source of truth. Consumers should not duplicate ownership or redefine meaning.

## Contracts

Define the summaries, projections, or interfaces this domain exposes to other domains.

Examples:

- Card summary.
- Detail view contract.
- Feed preview.
- Notification summary.
- Editable owner view.
- Public view.
- Admin or moderation view.

Each contract should define:

- Purpose.
- Intended consumers.
- Included concepts.
- Excluded concepts.
- Privacy or visibility rules.
- Fallback behavior when data is missing.

## Consumers

List every feature or subsystem that depends on this domain.

For each consumer, document:

- Which contract it should use.
- Which fields or concepts it depends on.
- Whether it affects ranking, notifications, privacy, or user-facing copy.
- What can break if the domain changes.

## AI Rules

Define implementation guardrails for future AI coding agents.

Rules should cover:

- What agents must not create or change without an approved tech plan.
- Which contracts agents must reuse.
- Which lifecycle transitions must remain centralized.
- Which privacy, safety, or ownership boundaries must never be bypassed.
- What downstream consumers must be checked before changing the domain.

## Future Extensions

Describe how the system should evolve without breaking existing assumptions.

Include:

- Future concepts that should fit into the model.
- Extension points.
- What must be proposed through a new approved tech plan.
- What should not become a parallel system.

## Goals / Non-goals

### Goals

- TODO

### Non-goals

- TODO

## User Stories

- As a `<user type>`, I want `<capability>` so that `<outcome>`.

## UX Flow

Describe the user flow, entry points, exit points, empty states, loading states, errors, and accessibility considerations.

## Architecture

Describe affected modules, ownership boundaries, service boundaries, and alternatives considered.

Flag any architecture-changing decisions as proposals requiring explicit approval.

## Database Changes

Describe conceptual database implications without deciding schema prematurely.

If no database changes are approved by this plan, state that explicitly.

## API / Service Changes

Describe conceptual service and contract implications.

If no API or service changes are approved by this plan, state that explicitly.

## UI Components

Describe likely screens, components, states, and design system dependencies.

Do not approve implementation unless this plan is explicitly scoped for implementation.

## Dependencies

List product, design, engineering, backend, analytics, CI, and third-party dependencies.

## Milestones

1. TODO
2. TODO
3. TODO

## Risks

Describe technical, product, UX, data, privacy, safety, rollout, and schedule risks.

## Testing Strategy

Describe conceptual validation and future implementation validation.

Include contract tests, lifecycle tests, permission tests, privacy tests, and downstream consumer validation where applicable.

## Rollout Plan

Describe feature flags, staged rollout, migration order, monitoring, rollback, and communication needs.

## Definition of Done

- Domain philosophy approved.
- Conceptual model approved.
- Lifecycle approved.
- Ownership matrix approved.
- Contracts approved.
- Consumers documented.
- AI rules documented.
- Future extensions documented.
- Jira tickets created and linked after relevant approvals.
- Tests and validation pass for implemented work.
- Documentation updated.

## Jira Breakdown Candidates

- TODO

## Open Questions

- TODO
