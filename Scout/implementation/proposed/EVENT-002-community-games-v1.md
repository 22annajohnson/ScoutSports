# Implementation Tech Plan: EVENT-002 Community Games V1

## Status

Proposed

## Product Domain

EVENT / SOCIAL

## Jira Project

SOCIAL

## Source of Truth

References:

- `tech-plans/approved/EVENT-001-games-and-events.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/DB-001-supabase-database-foundation.md`
- `implementation/proposed/PROFILE-004-profile-database-schema.md`
- `implementation/proposed/PROFILE-005-public-profile-and-owner-profile.md`
- `implementation/proposed/FEED-002-feed-backend.md`

## Problem Statement

Scout needs the first production Community Games implementation so players can create, discover, join, leave, and coordinate lightweight local games. The implementation must support real-world play without expanding into leagues, tournaments, payments, clubs, maps, or moderation.

## Goals

- Implement MVP event domain models and repository boundaries.
- Persist community games and participants in Supabase.
- Support create, edit, cancel, join, and leave flows.
- Enforce organizer ownership, capacity, visibility, and participant state rules.
- Expose Event Card, Event Detail, Participant Summary, and Feed Preview contracts.
- Provide hooks for Feed and future Notification integration without implementing delivery.

## Non-goals

- Leagues, tournaments, payments, clubs, court reservations, maps, moderation tooling, or recurring events.
- Advanced organizer dashboards.
- Push notification delivery.
- Chat implementation beyond handoff hooks.
- Recommendation ranking.

## Architecture

```text
Community Games UI
  -> Event ViewModels
  -> EventRepository protocol
  -> SupabaseEventRepository
  -> community_games / community_game_participants
  -> Event contracts for Feed, Notifications, Profile, and future Chat
```

Events own lifecycle, organizer permissions, participant state, capacity, visibility, and event contracts. Profile owns player identity. Feed, Notifications, Chat, Maps, and Recommendations consume Event contracts rather than directly owning event state.

## Domain Ownership

| Concept | Owner | Consumers |
| --- | --- | --- |
| Event lifecycle | Events | Feed, Notifications, Chat, Profile, Recommendations |
| Organizer permissions | Events | Event UI, Notifications, future moderation |
| Participant state | Events | Feed, Chat, Notifications, Profile |
| Venue display data | Events | Feed, Maps, Notifications |
| Profile identity | Profile | Events consumes profile contracts |
| Feed preview | Events publishes contract, Feed consumes | Feed |

## Backend Ownership

Supabase owns durable event and participant records. All schema and policy work must follow DB-001 conventions. Event tables are owned by the Events domain and must not be mutated by Feed, Chat, Notifications, or Recommendations except through approved EventRepository APIs or future server-owned functions.

## iOS Responsibilities

- Provide create/edit/cancel organizer flows.
- Provide join/leave participant flows.
- Render event card, detail, capacity, participant, and lifecycle states.
- Route event actions through EventRepository.
- Avoid direct Supabase calls from SwiftUI.

## Data Model Scope

The implementation may define V1 tables for community games and participants. Required conceptual fields include event identity, organizer, sport, title, description, schedule, venue summary, capacity, visibility, lifecycle state, participant state, timestamps, and audit metadata. Exact SQL belongs in implementation PRs and must follow approved migration conventions.

## Event Lifecycle

V1 supports:

```text
Draft -> Published -> Filling -> Confirmed -> In Progress -> Completed
                      \-> Cancelled
```

Archived remains a future presentation/storage concern. Lifecycle transitions must be centralized and tested.

## Participant States

V1 supports a small participant state set: invited/future, requested/future, joined, waitlisted/future, left, removed, no_show/future. The implementation should only activate states required for MVP join/leave/cancel behavior. New active states require an approved tech plan.

## Implementation Sequencing

1. Add Event domain models, contracts, and repository protocol.
2. Add community game and participant migrations with RLS.
3. Implement SupabaseEventRepository create/edit/cancel/join/leave operations.
4. Build create/edit/cancel organizer flows.
5. Build event card/detail and join/leave participant flows.
6. Add Feed Preview and Notification Summary hooks.
7. Add repository, lifecycle, capacity, and ViewModel tests.

## Repository Ownership

EventRepository owns event reads/writes, lifecycle transitions, capacity checks, participant state mapping, and error translation. ViewModels own presentation state. Generated Supabase types must be mapped into domain models before reaching SwiftUI.

## Validation Strategy

- Migration validation for tables, constraints, indexes, and RLS.
- Repository tests for create/edit/cancel/join/leave.
- Lifecycle transition tests.
- Capacity and duplicate participant tests.
- ViewModel tests for loading, empty, success, and error states.
- Manual dev validation using seed community games.

## Rollout Strategy

1. Land schema and RLS behind dev-only flows.
2. Land repository and tests.
3. Land organizer create/edit/cancel.
4. Land participant join/leave and event detail.
5. Connect Feed preview after contracts stabilize.

## Risks

- Event lifecycle state leaking into feature-specific logic.
- Capacity and participant state bugs creating overfilled games.
- Feed or Notifications mutating event records directly.
- Venue precision exposing more location data than intended.
- Scope creep into leagues, maps, tournaments, or moderation.

## Definition of Done

- Community Games V1 schema and RLS are implemented and validated.
- EventRepository supports create, edit, cancel, join, and leave.
- Organizer and participant UI flows consume EventRepository.
- Event contracts are available for Feed and future Notifications.
- Lifecycle, capacity, RLS, repository, and ViewModel behavior are tested.
- No leagues, tournaments, payments, maps, clubs, or moderation are implemented.

## Jira Breakdown

- Epic: `SOCIAL-115` - EVENT-002: Community Games V1

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `SOCIAL-116` | Events: Add Community Game domain models and repository protocol | 🤖 AI Implementation | 1 | EVENT-002 |
| 2 | `SOCIAL-117` | Events: Create community games schema and RLS | 🤖 AI Implementation | 2 | DB-001, PROFILE-004, `SOCIAL-116` |
| 3 | `SOCIAL-118` | Events: Implement EventRepository backend operations | 🤖 AI Implementation | 2 | `SOCIAL-116`, `SOCIAL-117` |
| 4 | `SOCIAL-119` | Events: Build create edit and cancel organizer flows | 🤖 AI Implementation | 2 | `SOCIAL-118` |
| 5 | `SOCIAL-120` | Events: Build event detail join and leave flows | 🤖 AI Implementation | 2 | `SOCIAL-118`, PROFILE-005 |
| 6 | `SOCIAL-121` | Events: Add Feed Preview and Notification Summary hooks | 🤖 AI Implementation | 1 | `SOCIAL-116`, `SOCIAL-118` |
