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

## Authority Chain

Agents must follow Scout's planning authority in this order:

1. Product docs define product direction.
2. Architecture docs and ADRs define system structure and durable technical direction.
3. Approved tech plans define implementation approach.
4. Jira epics group approved work.
5. Jira stories define executable scope.

When these sources conflict, agents must stop implementation and document the conflict. Product conflicts belong in product planning, architecture conflicts belong in architecture docs or ADRs, implementation-plan conflicts belong in the tech plan, and execution-scope conflicts belong in Jira. Do not resolve conflicts by guessing in code.

Implementation agents should use the most specific approved source for scope. A Jira story may narrow an approved plan, but it must not expand product behavior, architecture, database ownership, auth strategy, shared contracts, CI behavior, or repository structure.

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

## Current Repository Guardrails

- Do not move the iOS project into `apps/ios/` yet.
- Do not move the web app into `apps/web/` yet.
- Do not alter Xcode references, package paths, schemes, CI, or build settings without an approved plan.
- Do not implement product features during planning-only tasks.

## Open Agent Workflow Questions

- What exact Jira fields should be required for AI-generated tickets?
- What review checklist should be mandatory before merge?
- Should plans include implementation prompts for agents?
- How should agent handoffs be stored or linked from Jira?
