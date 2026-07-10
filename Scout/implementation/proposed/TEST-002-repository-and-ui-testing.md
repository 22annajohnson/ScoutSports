# Implementation Tech Plan: TEST-002 Repository & UI Testing

## Status

Proposed

## Product Domain

INFRA / CORE

## Jira Project

INFRA

## Source of Truth

References:

- `tech-plans/approved/ARCH-001-app-architecture.md`
- `implementation/proposed/INFRA-003-ci-cd-foundation.md`
- `implementation/proposed/DB-001-supabase-database-foundation.md`
- `implementation/proposed/PROFILE-004-profile-database-schema.md`
- `implementation/proposed/PROFILE-005-public-profile-and-owner-profile.md`
- `implementation/proposed/SWIPE-004-discovery-candidate-queue.md`
- `implementation/proposed/FEED-002-feed-backend.md`
- `implementation/proposed/EVENT-002-community-games-v1.md`

## Problem Statement

Scout is moving from mock-driven flows to repository-backed production behavior. Implementation agents need a shared testing structure so repository, ViewModel, navigation, and UI-state changes can be reviewed safely and independently.

## Goals

- Establish repository test fixture and mock conventions.
- Expand coverage for onboarding, profile, swipe, feed, and navigation flows.
- Add a lightweight snapshot/screenshot strategy for high-risk reusable UI states.
- Ensure tests are compatible with CI and local validation.
- Keep tests focused enough for small agent PRs.

## Non-goals

- Rewriting the app architecture for testability.
- Full end-to-end automation across real Supabase environments.
- Mandatory snapshots for every view.
- Replacing existing CI workflows.
- Broad production code refactors.

## Architecture

```text
Feature ViewModels
  -> Repository protocols
  -> Mock repositories / fixtures
  -> Unit and UI-state tests
  -> CI validation
```

Tests should verify domain behavior at repository and ViewModel boundaries. SwiftUI rendering checks should focus on reusable components, key states, and regression-prone screens rather than duplicating every manual QA path.

## Repository Ownership

Infrastructure owns test conventions, fixture helpers, snapshot strategy, and CI compatibility. Each product domain owns tests for its own repository, ViewModel, and UI states.

## Domain Ownership

| Test Area | Owner | Consumers |
| --- | --- | --- |
| Fixture helpers | INFRA | Profile, Discovery, Feed, Events |
| Repository mock conventions | INFRA | All repository-backed domains |
| Profile tests | Profile | Discovery, Events, Chat |
| Swipe tests | Discovery | Feed, Match |
| Feed tests | Feed | Events, Discovery |
| Navigation tests | CORE | All feature flows |
| Snapshot strategy | Design / INFRA | ScoutDesign, feature UI |

## Backend Ownership

TEST-002 does not create Supabase schema. Repository tests may use mocks, local Supabase fixtures, or generated type fixtures depending on the relevant implementation plan. Any real database test workflow must follow DB-001.

## iOS Responsibilities

- Add test doubles for repository protocols.
- Keep ViewModels testable through dependency injection.
- Cover loading, empty, error, success, and permission states.
- Validate navigation routes that connect core product flows.
- Use snapshots/screenshots selectively for reusable components and critical state regressions.

## Testing Scope

Initial coverage targets:

- Repository fixtures and mock conventions.
- Onboarding readiness and transition tests.
- Profile owner/public/editing ViewModel tests.
- Swipe queue and decision state tests.
- Feed loading/empty/error/refresh tests.
- Navigation smoke tests for onboarding -> profile -> main app.
- Snapshot/screenshot strategy for shared cards, empty states, loading states, and high-risk profile/swipe/feed screens.

## Implementation Sequencing

1. Add shared fixture and mock repository conventions.
2. Add onboarding/profile ViewModel tests.
3. Add swipe/feed repository and ViewModel tests.
4. Add navigation smoke tests.
5. Add selective snapshot/screenshot harness.
6. Document local test commands and CI compatibility.

## Validation Strategy

- Run relevant Swift tests locally.
- Ensure test targets run in CI without expensive duplication.
- Verify tests do not require production secrets.
- Confirm snapshots are deterministic or documented as screenshot/manual artifacts.

## Rollout Strategy

1. Land fixture conventions first.
2. Add tests domain by domain alongside implementation PRs.
3. Introduce snapshots only for stable reusable UI and critical states.
4. Expand coverage as Profile, Discovery, Feed, and Events move from plans into code.

## Risks

- Overly broad tests slowing agent iteration.
- Snapshot churn from unstable UI.
- Tests accidentally depending on real dev data.
- Mock conventions drifting from repository contracts.
- CI runtime increasing too quickly.

## Definition of Done

- Repository fixture and mock conventions exist.
- Core onboarding/profile/swipe/feed/navigation tests are planned and ticketed.
- Snapshot/screenshot strategy is defined for selective adoption.
- Test work can run locally and in CI without secrets.
- Future implementation agents have clear testing tickets tied to production features.

## Jira Breakdown

- Epic: `INFRA-47` - TEST-002: Repository and UI Testing
- Story points use Scout's `0.25` increment scale. Values such as `0.75` and `1.5` are valid.

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `INFRA-48` | Testing: Add repository fixtures and mock conventions | 🤖 AI Implementation | 0.75 | TEST-002 |
| 2 | `INFRA-49` | Testing: Add onboarding and profile ViewModel coverage | 🤖 AI Implementation | 1.5 | `INFRA-48`, PROFILE-005 |
| 3 | `INFRA-50` | Testing: Add swipe and feed repository state coverage | 🤖 AI Implementation | 1.5 | `INFRA-48`, SWIPE-004, FEED-002 |
| 4 | `INFRA-51` | Testing: Add navigation smoke tests for core app flows | 🤖 AI Implementation | 1 | `INFRA-48`, current navigation architecture |
| 5 | `INFRA-52` | Testing: Add selective snapshot and screenshot strategy | 🤖 AI Implementation | 1 | `INFRA-48`, DESIGN-002/DESIGN-004 |
| 6 | `INFRA-53` | Testing: Document local test commands and CI compatibility | 🤖 AI Implementation | 0.5 | INFRA-003, TEST-002 |
