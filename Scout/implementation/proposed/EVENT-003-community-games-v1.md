# Implementation Tech Plan: Community Games V1

## Status

Proposed

## Owner

TODO

## Product Domain

EVENT / SOCIAL

## Jira Project

SOCIAL

## Source of Truth

This plan narrows Scout Events into the first production implementation slice for lightweight community games. It builds on, but does not redefine:

- `tech-plans/approved/EVENT-001-games-and-events.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-004-profile-contracts.md`
- `tech-plans/approved/DESIGN-001-design-system.md`
- `docs/architecture/API_BOUNDARIES.md`
- `docs/database/RLS.md`

Implementation must wait until this plan, required Profile contracts, and the Event schema/RLS plan are approved.

## Problem Statement

Scout needs a small Events implementation that helps players create, discover, join, and leave real-world community games. The first slice should support the core coordination loop without expanding into leagues, tournaments, payments, maps, clubs, or moderation.

This plan defines the iOS and Supabase implementation boundary for Community Games V1 so agents can build domain models, repositories, flows, and RLS-backed data access in small PRs.

## Goals

- Define MVP community game scope.
- Define Event domain models and repository responsibilities.
- Define lifecycle, participant states, organizer actions, capacity, and summaries.
- Define create, join, leave, and organizer-management flows.
- Define Feed and Notification integration hooks without implementing full Feed/Notifications domains.
- Define Supabase ownership and RLS requirements.
- Produce implementation stories that directly unblock iOS and Supabase agents.

## Non-goals

- Leagues, tournaments, ladders, seasons, payments, reservations, clubs, or teams.
- Map-based discovery or venue inventory.
- Rich moderation workflows.
- Event chat implementation beyond future hook points.
- Multi-organizer support.
- Advanced recommendations.
- Attendance/reputation scoring.

## MVP Scope

Community Games V1 supports:

- Create a game.
- Publish a game.
- View game summaries.
- View game detail.
- Join a game when capacity allows.
- Leave a game before completion.
- Organizer cancels a game.
- Organizer removes a participant when allowed.
- Basic capacity and participant-state enforcement.
- Feed-ready event summaries.
- Notification-ready event change hooks.

## Event Domain Models

Domain models should sit between Supabase DTOs and SwiftUI:

- `CommunityGame`: full detail contract for event detail and organizer management.
- `EventSummary`: lightweight contract for Feed/discovery lists.
- `EventParticipant`: participant contract and state.
- `EventOrganizerSummary`: organizer display contract using approved Profile summary.
- `EventSchedule`: date, start, end, and time zone.
- `EventVenueSummary`: approximate venue/location only for V1 unless exact reveal is approved.
- `EventCapacity`: min/max capacity, joined count, and availability state.
- `EventLifecycleState`: approved lifecycle subset.

Generated Supabase types must map into these domain models before reaching ViewModels.

## Event Lifecycle

V1 lifecycle subset:

- `draft`: local/incomplete event, not discoverable.
- `published`: visible to eligible users.
- `full`: capacity reached, join disabled unless waitlist is approved later.
- `cancelled`: organizer cancelled, no new joins.
- `completed`: game is over.

Deferred states from EVENT-001:

- `filling` and `confirmed` may be derived in V1.
- `in_progress` and `archived` may be deferred until attendance/completion workflows exist.

Lifecycle transitions must be centralized in repository/service logic and must not be UI-only.

## Participant States

V1 participant states:

- `none`: viewer is not participating.
- `joined`: user has joined.
- `left`: user left before completion.
- `removed`: organizer removed participant.
- `cancelled`: participation ended because event was cancelled.

Deferred participant states:

- `requested`
- `invited`
- `waitlisted`
- `declined`
- `attended`
- `no_show`

No implementation may introduce extra participant states without an approved plan update.

## Repository Responsibilities

`EventRepository` should:

- Fetch event summaries for eligible viewers.
- Fetch event detail.
- Create and publish community games.
- Join and leave events.
- Cancel organizer-owned events.
- Remove participants when allowed.
- Map Supabase DTOs to domain models.
- Map errors into user-safe domain errors.
- Enforce client-side validation before Supabase calls.
- Provide mock repositories for previews/tests.

`EventRepository` should not:

- Own Profile data.
- Own Feed ranking.
- Send push notifications directly.
- Own Chat conversations.
- Bypass RLS or lifecycle rules.
- Expose generated Supabase types to SwiftUI.

## Create Game Flow

Required fields:

- Sport.
- Date and start time.
- Duration or end time.
- Approximate location/venue label.
- Capacity.
- Skill expectation or play level.
- Description, optional.

Flow:

1. User opens create game.
2. App validates required fields.
3. Repository creates draft or publishes directly based on approved UI.
4. Supabase persists event and organizer ownership.
5. UI routes to event detail or confirmation.

## Join Flow

Join rules:

- User must be authenticated.
- User must meet Event Ready profile requirements once approved.
- Event must be published and not full/cancelled/completed.
- User must not be organizer if organizer self-participation is disallowed.
- User must not already be joined.
- Blocked/restricted relationships must be respected when available.

Join should be idempotent where possible.

## Leave Flow

Leave rules:

- Joined participant can leave before event completion.
- Leaving frees capacity if event is still active.
- Leaving after a cutoff time may require future policy; V1 can allow or block based on approved product decision.
- Organizer cannot use participant leave flow to cancel owned event.

## Organizer Actions

V1 organizer actions:

- Edit draft before publish.
- Publish game.
- Cancel game.
- Remove participant when event is not completed/cancelled.
- View participant summaries.

Deferred organizer actions:

- Approval queue.
- Waitlist management.
- Multi-organizer delegation.
- Organizer analytics.
- Reputation/trust scoring.

## Capacity Management

V1 capacity rules:

- Event has max capacity.
- Joined participants count toward capacity.
- Removed/left/cancelled participants do not count.
- Join is blocked when capacity is full.
- Capacity updates must be transactional or protected by database constraints/RLS policies.

No waitlist is included in V1.

## Event Summaries and Detail

`EventSummary` supports Feed/discovery lists:

- Event ID.
- Sport.
- Time summary.
- Approximate location summary.
- Capacity status.
- Skill/play expectation.
- Organizer summary.
- Viewer participation state.
- Primary action.

`CommunityGame` detail supports:

- Full event description.
- Schedule.
- Approximate venue.
- Capacity.
- Participants through approved Profile summaries.
- Organizer controls if viewer is organizer.
- Join/leave/cancel/remove actions based on lifecycle and permissions.

## Feed Integration

Feed should consume `EventSummary` only. Events owns event state; Feed must not mutate events directly.

V1 may expose a repository method that returns event summaries suitable for Feed. Feed ranking, personalization, and mixed content ordering are out of scope.

## Notification Hooks

V1 should define notification-ready domain events but not require a full push system:

- Event created/published.
- Participant joined.
- Participant left.
- Participant removed.
- Event cancelled.
- Event updated, future.

The repository may emit local app events or return results that future Notification services consume. Push delivery is deferred.

## Supabase Ownership and RLS

Events owns:

- `events`, future table.
- `event_participants`, future table.
- Event lifecycle and participant state.
- Event visibility and capacity constraints.

Profile owns player identity fields consumed by Event summaries. Notifications, Feed, Chat, and Discovery consume Event contracts rather than mutating Event tables.

RLS requirements:

- Authenticated users can read discoverable published events.
- Organizers can read and update owned events within lifecycle rules.
- Participants can read joined event detail.
- Users can insert their own participant row when join rules allow.
- Users can update their own participant row for leave where lifecycle allows.
- Organizers can update participant rows only for owned events and approved actions.
- Service role behavior must be documented before notification fan-out or automation.

## Validation Strategy

- Unit-test lifecycle transitions.
- Unit-test participant-state transitions.
- Unit-test capacity full/available behavior.
- Unit-test domain mapping.
- Unit-test repository errors for full, cancelled, unauthorized, already joined, and not found.
- RLS tests must cover organizer, participant, unrelated user, blocked/restricted user when available, and service role.
- UI PRs must include screenshots for create/detail/join/leave states.

## Rollout Plan

1. Add Event domain models, repository protocol, and mocks.
2. Add Supabase schema/RLS migration after approval.
3. Implement create game flow.
4. Implement event summary/detail loading.
5. Implement join and leave.
6. Implement organizer cancel/remove.
7. Add Feed summary hook.
8. Add notification hook placeholders.

## Risks

- Capacity race conditions if joins are not database-protected.
- Location privacy can be weakened if exact venue details leak into summaries.
- Events can become CRUD-heavy unless lifecycle/participant transitions remain centralized.
- Feed/Notifications may accidentally own event state if contracts are not enforced.
- Profile readiness and participant summary dependencies can block implementation.

## Definition of Done

- Community Games V1 supports create, list/detail, join, leave, cancel, and organizer removal.
- Event state and participant state are centrally managed.
- Supabase schema and RLS are reviewed before production use.
- Event summaries feed other surfaces through contracts.
- No leagues, tournaments, payments, maps, clubs, or moderation are implemented.
- Jira stories are complete, reviewed, and merged.

## Jira Breakdown

- Epic: `SOCIAL-64` - EVENT-003: Community Games V1
- `SOCIAL-65` - Events: Create Community Game domain models and contracts
- `SOCIAL-66` - Events: Add EventRepository protocol and mock repository
- `SOCIAL-67` - Events: Create Supabase schema migration for community games
- `SOCIAL-68` - Events: Add RLS policies for community games
- `SOCIAL-69` - Events: Implement Supabase EventRepository
- `SOCIAL-70` - Events: Build create community game flow
- `SOCIAL-71` - Events: Build event summary and detail loading UI
- `SOCIAL-72` - Events: Implement join and leave flows
- `SOCIAL-73` - Events: Implement organizer cancel and remove participant actions
- `SOCIAL-74` - Events: Add Feed summary and notification hook contracts
- `SOCIAL-75` - Events: Add Community Games lifecycle and repository regression tests
