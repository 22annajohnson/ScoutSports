# Implementation Tech Plan: Events V1

## Status

Proposed

## Owner

TODO

## Product Domain

SOCIAL / EVENTS

## Source of Truth

This plan narrows `tech-plans/approved/EVENT-001-games-and-events.md` into a proposed implementation plan for Events V1. It does not redefine the Events domain model.

This document remains `Proposed` until the product owner explicitly approves it. SOCIAL-15 creates this plan for review only; it does not authorize production code, schema changes, Supabase migrations, generated types, storage buckets, Edge Functions, or implementation Jira tickets.

Authoritative inputs:

- `tech-plans/approved/EVENT-001-games-and-events.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `docs/architecture/API_BOUNDARIES.md`
- `docs/database/DATABASE.md`
- `docs/database/SUPABASE.md`
- `docs/database/MIGRATIONS.md`
- `docs/database/RLS.md`

SOCIAL-10 through SOCIAL-14 are planning inputs for this proposed plan. If any of those review decisions change before approval, this plan must be updated before implementation work begins.

## Problem Statement

EVENT-001 defines Scout's conceptual model for real-world sports coordination, but it does not approve production implementation. Events V1 needs a focused implementation plan before iOS screens, data models, Supabase schema, lifecycle enforcement, notifications, safety surfaces, or cross-domain contracts are built.

The first Events implementation should support lightweight community games without expanding into leagues, tournaments, payments, reservations, club administration, or broad moderation infrastructure.

## Goals

- Define proposed Events V1 scope.
- Define lifecycle, participant state, organizer permissions, and event contracts at implementation-planning level.
- Identify data model, privacy, RLS, API, and service-boundary decisions required before implementation.
- Align Events with Profile contracts and safety/location principles.
- Define UI surfaces, testing expectations, rollout approach, and Definition of Done.
- Keep the plan small enough to review before implementation tickets are created.

## Non-goals

- Writing production iOS, web, backend, or Supabase code.
- Creating Supabase tables, migrations, policies, generated types, buckets, Edge Functions, or CI jobs.
- Creating implementation Jira tickets from this proposed plan.
- Implementing leagues, tournaments, ladders, payments, reservations, clubs, venue inventory, advanced moderation, ratings, reputation, or public web event pages.
- Finalizing legal, policy, or trust-and-safety operating procedures.

## Proposed V1 Scope

Events V1 should support lightweight community games organized by Scout users.

In scope:

- Creating an event for a supported sport.
- Publishing an event to eligible viewers.
- Showing event cards and event details with appropriate visibility.
- Joining or requesting to join an event, subject to the approved participation model.
- Organizer review of participants when approval is required.
- Participant status tracking.
- Capacity and basic waitlist behavior if approved.
- Event updates and cancellation.
- Safe location display using approximate versus exact precision rules.
- Basic notification-ready contracts for key event changes.

Out of scope for V1:

- League, tournament, ladder, or season management.
- Payments, deposits, refunds, or monetization.
- Venue reservation systems or court inventory.
- Public unauthenticated event pages.
- Advanced ranking, attendance scoring, or reputation.
- Rich moderation workflows beyond the minimum approved safety surface.
- Multi-organizer administration unless explicitly approved.

## Lifecycle Model

Events V1 should start from the EVENT-001 lifecycle:

1. `Draft`
2. `Published`
3. `Filling`
4. `Confirmed`
5. `In Progress`
6. `Completed`
7. `Archived`
8. `Cancelled`

Implementation planning must define:

- Which lifecycle states are user-visible.
- Which states are stored versus derived.
- Which transitions are organizer-controlled.
- Which transitions are system-derived.
- Whether `Filling` and `Confirmed` are distinct persisted states or derived from capacity and organizer confirmation.
- How cancellation behaves before and after exact location reveal.
- Whether completed and archived events remain visible to participants.

Invalid transition behavior must be explicit before implementation. UI affordances must not be the only lifecycle enforcement mechanism.

## Participant State

Candidate participant states:

- `none`
- `requested`
- `invited`
- `joined`
- `waitlisted`
- `declined`
- `left`
- `removed`
- `cancelled`
- `attended`
- `no_show`

Implementation planning must decide which states ship in V1 and which remain deferred. At minimum, V1 needs enough participant state to represent discovery, join intent, organizer approval if required, active participation, leaving, removal, and cancellation.

Participant state must account for:

- Capacity.
- Organizer approval mode.
- Event lifecycle.
- Profile readiness.
- Blocked or restricted users.
- Visibility and location reveal rules.
- Notification contracts.

## Organizer Permissions

The organizer is responsible for keeping the event viable and safe.

Proposed V1 organizer capabilities:

- Create and edit draft events.
- Publish eligible events.
- Update event details within approved lifecycle rules.
- Approve, decline, remove, or waitlist participants when approval mode requires it.
- Manage capacity within approved constraints.
- Cancel an event with safe participant communication.
- View organizer-appropriate participant summaries.

Organizer capabilities requiring approval before implementation:

- Editing exact location after participants have joined.
- Removing participants after exact location reveal.
- Changing sport, skill expectations, or participation mode after publishing.
- Multi-organizer delegation.
- Organizer verification or trust signals.
- Organizer access to participant profile details beyond approved event summaries.

Organizer permissions must be enforced outside the UI. The eventual implementation plan must document where permission checks live.

## Event Contracts

Consumers should receive context-specific event contracts rather than the full event model.

Required V1 planning contracts:

| Contract | Purpose | Minimum conceptual content | Must exclude until approved |
| --- | --- | --- | --- |
| Event Card | Discovery and feed preview. | Sport, time, approximate location, capacity/status, skill expectations, organizer summary, primary action. | Exact address, access notes, private participant details, full participant list. |
| Event Detail | Decision and coordination surface. | Description, schedule, organizer, participation state, approved participant preview, location precision appropriate to viewer. | Exact location before approved reveal, private profile fields, moderation internals. |
| Participant Summary | Organizer and participant context. | Approved Profile summary fields, participation state, role, safe trust cues. | Full Player Identity, private availability, exact home area, system-only account data. |
| Organizer Dashboard | Organizer management view. | Requests, capacity, participant states, lifecycle controls, update/cancel tools, approved safety controls. | Hidden safety adjudication details or unrestricted profile data. |
| Notification Summary | Safe event change messaging. | Event identity, update type, time-sensitive action, safe location language. | Exact location unless the recipient's event state permits it. |

Each contract must reference Profile contracts from `PROFILE-001` and `PROFILE-002` before implementation.

## Data Model Questions

The following are candidate entities, not approved schema:

- `events`
- `event_participants`
- `event_updates`
- `event_locations`
- `event_visibility_rules`
- `event_reports`
- `event_audit_log`

Required database decisions before the first migration:

- Event ownership and organizer relationship.
- Sport relationship and supported sport validation.
- Location representation and precision levels.
- Lifecycle state storage and derived-state strategy.
- Participant state values and allowed transitions.
- Capacity, waitlist, and approval-mode representation.
- Visibility model and discoverability filters.
- Cancellation and archival fields.
- Created, updated, and audit metadata.
- Whether reports, moderation notes, or safety records ship in the first schema.

This plan does not approve SQL table names, columns, indexes, constraints, RLS policies, generated types, seed data, or migrations.

## Service and API Boundaries

Implementation planning must follow `docs/architecture/API_BOUNDARIES.md`.

Proposed boundary principles:

- SwiftUI views render state and collect user intent.
- View models coordinate screen state and call repositories or services.
- Repositories or services own Supabase calls, decoding, persistence behavior, and error mapping.
- Event lifecycle, participant-state, visibility, and organizer-permission rules must not live only in view code.
- Shared event contracts must be documented before they are consumed by future web or backend code.

Open API boundary decisions:

- Which Events operations can be direct Supabase client calls from iOS?
- Which operations require server authority, transactional behavior, secrets, fan-out, or audit logging?
- Are Edge Functions required for join approval, cancellation, notifications, reporting, or exact location reveal?
- What error model should Events use for blocked, full, cancelled, unauthorized, or stale-state operations?
- How should generated Supabase types be consumed by iOS and future web?

## UI Surfaces

Candidate V1 iOS surfaces:

- Event discovery card or list entry.
- Event detail screen.
- Create/edit event flow.
- Organizer management surface.
- Participant request or join state controls.
- Event update and cancellation UI.
- Safe empty states and unavailable-state messaging.

UI planning requirements:

- Existing SwiftUI patterns and feature organization must be inspected before implementation.
- Event UI must use approved design-system direction where applicable.
- Text must avoid promising exact location or participant access before visibility rules allow it.
- Cancellation, full event, blocked/restricted, and no-longer-available states must be designed before implementation.
- Event surfaces must degrade gracefully when optional Profile fields are missing.

## Safety, Visibility, and Location

Safety and visibility rules must override convenience.

V1 implementation planning must define:

- Discovery visibility.
- Pre-join detail visibility.
- Pending participant visibility.
- Joined participant visibility.
- Organizer visibility.
- Cancelled and archived event visibility.
- Approximate location representation.
- Exact location reveal timing.
- Location redaction in notifications and previews.
- Participant list visibility.
- Blocked-user behavior.
- Minimum reporting or escalation surface.

Exact location includes any address, court, access note, parking note, or instruction that materially helps someone find participants. Exact location reveal requires explicit approval before implementation.

## Database, RLS, and Security Approval Gates

Before the first Events migration, an approved schema and security plan must define:

- Tables and relationships.
- Enum or lookup strategy for lifecycle, participant state, visibility, sport, and location precision.
- RLS read, insert, update, and delete policies for every table.
- Organizer, participant, pending participant, blocked user, and admin/service role access.
- Location precision enforcement.
- Participant summary access.
- Reporting or moderation access if included in V1.
- Audit expectations for sensitive operations.
- Migration naming, validation, rollback/forward-fix strategy, and generated type handling.

Required approval gates before implementation:

- Product approval of this proposed plan.
- Database approval for schema, migrations, and source-of-truth workflow.
- Security/RLS approval for event and participant access.
- API/service-boundary approval if Edge Functions or new shared service contracts are required.
- Profile-contract approval for any event consumer fields not already approved by Profile planning.
- Safety approval for exact location reveal, blocked-user behavior, and reporting scope.

## Testing and Validation

Future implementation tickets should include targeted validation for the touched layer.

Expected test areas:

- Lifecycle transition rules.
- Participant state transitions.
- Organizer permission checks.
- Event contract shaping.
- Location precision and redaction.
- Capacity and waitlist behavior if shipped.
- Cancellation and stale-state handling.
- Profile readiness and contract fallback behavior.
- Repository/service error mapping.
- RLS behavior for owner, participant, pending participant, unrelated user, blocked user, and service role.

Documentation-only changes should run `git diff --check`. App builds or tests are not required until implementation begins.

## Rollout

Proposed rollout principles:

- Build behind explicit product and backend approval gates.
- Start in `scout-dev`.
- Do not create staging or production Events data until environment strategy approves it.
- Prefer additive schema changes once migrations are approved.
- Keep V1 limited to lightweight community games.
- Require rollback or forward-fix notes for migration PRs.
- Avoid seeding public-looking events until data policy and moderation expectations are clear.

## Definition of Done for Plan Approval

This proposed plan is ready for approval when:

- V1 scope and non-goals are accepted.
- Lifecycle and participant states are approved or explicitly deferred.
- Organizer permission boundaries are accepted.
- Event contracts are approved for V1 consumers.
- Database, RLS, location, and safety approval gates are identified.
- Open questions have owners or deferral decisions.
- The plan can be broken into small implementation tickets after approval.

## Open Decisions Before Implementation

- Which participant states are required in V1?
- Is joining immediate, approval-based, or configurable by organizer?
- Are waitlists part of V1?
- Which lifecycle states are persisted versus derived?
- When exactly does precise location reveal?
- Can exact location be revoked or changed after reveal?
- What blocked-user behavior is required before public discovery?
- What minimum reporting path must exist before launch?
- Are Edge Functions required for any V1 operation?
- What event notifications are required for V1?
- Which Profile readiness level is required for creating and joining events?
- Which Profile summary fields are safe for event participant lists?
- What RLS policy shape is required for discovery, joining, organizing, and cancellation?
