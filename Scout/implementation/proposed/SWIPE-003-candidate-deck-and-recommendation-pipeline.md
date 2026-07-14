# Implementation Tech Plan: Candidate Deck and Recommendation Pipeline

## Status

Proposed

## Owner

TODO

## Product Domain

SWIPE / DISCOVERY

## Jira Project

SOCIAL

## Source of Truth

This plan implements the first production-ready Discovery pipeline slice. It builds on, but does not redefine:

- `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md`
- `implementation/proposed/SWIPE-002-recommendation-inputs-and-candidate-pipeline.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-004-profile-contracts.md`
- `tech-plans/approved/EVENT-001-games-and-events.md`
- `docs/architecture/API_BOUNDARIES.md`
- `docs/database/RLS.md`

Implementation must wait until this plan and its prerequisite Profile contracts are approved.

## Problem Statement

Scout needs the Swipe deck to receive a stable queue of eligible player candidates without embedding recommendation logic in SwiftUI views. Today, implementation agents need a concrete plan for retrieving candidates, applying hard filters, shaping candidate contracts, handling queue lifecycle, refreshing safely, and preparing for Supabase-backed recommendation work.

This is not the recommendation algorithm. It is the production pipeline and repository boundary that lets Discovery load, present, refresh, and exhaust candidate players safely.

## Goals

- Define the iOS candidate deck data flow.
- Define the Discovery repository contract and responsibilities.
- Define the candidate queue lifecycle.
- Define hard filters, soft preference inputs, and privacy filtering.
- Define how Discovery consumes Profile repository/contracts.
- Define future-safe seams for Events, blocking, RLS, and recommendation services.
- Produce implementation stories small enough for AI agents to execute independently.

## Non-goals

- Ranking algorithm implementation.
- ML, scoring weights, collaborative filtering, or optimization.
- Match creation.
- Swipe decision persistence beyond local queue state unless separately approved.
- Supabase schema migrations.
- Event recommendations.
- Production analytics instrumentation.
- Redesigning the Swipe UI.

## Architecture

```text
Swipe View
  -> Swipe ViewModel
  -> DiscoveryRepository protocol
  -> CandidatePipeline service
  -> ProfileRepository / Profile contracts
  -> Supabase-backed data source, future
```

SwiftUI views should render deck state and send user intent. ViewModels own screen state and call the repository. The repository owns candidate retrieval, queue refresh, contract shaping, and error mapping. Filtering and queue assembly live below the ViewModel so they can be tested without UI.

## Repository Responsibilities

`DiscoveryRepository` should:

- Load a candidate queue for the current authenticated player.
- Refresh a queue when user intent or expiration requires it.
- Return `CandidateCard` contracts, not raw Profile records.
- Apply local deterministic hard filters for the first implementation slice.
- Defer server-owned filters to Supabase/service contracts when schema exists.
- Classify loading, empty, exhausted, unauthorized, and retryable-error states.
- Provide a mock implementation for previews/tests.

`DiscoveryRepository` should not:

- Own Profile data.
- Recompute Profile completion.
- Store final recommendation scores.
- Create matches.
- Own blocked-user state beyond consuming approved exclusion effects.
- Expose generated Supabase types to SwiftUI.

## Candidate Pipeline Architecture

The pipeline has five stages:

1. Current player context: authenticated user, active sport, discovery readiness, privacy effects.
2. Candidate source: Profile contracts eligible for Discovery.
3. Hard filters: remove ineligible candidates before presentation.
4. Soft signal annotation: attach safe preference hints for future ranking.
5. Queue assembly: return bounded `DiscoveryQueue` and `CandidateCard` contracts.

The first implementation may use deterministic mock/profile-source data while preserving the same repository protocol that future Supabase-backed work will use.

## Candidate Queue Lifecycle

Queue states:

- `idle`: no request started.
- `loading`: initial queue request is active.
- `ready`: one or more candidates are available.
- `empty`: no eligible candidates are available.
- `exhausted`: queue was available but the user has reached the end.
- `refreshing`: existing deck remains visible while refresh occurs.
- `failed`: queue load failed with a user-recoverable or blocking error.

Queue rules:

- A candidate appears once per active queue.
- Queue identity must survive card gestures for the current session.
- Refresh should not duplicate already-presented candidates unless an approved resurfacing rule exists.
- Empty and exhausted states must include user-safe reasons.
- UI must not fabricate candidates to avoid an empty deck.

## Refresh Behavior and Triggers

Refresh triggers:

- First entry to Swipe after authentication.
- Manual pull or retry action.
- Active sport/context change.
- Profile readiness change.
- Queue exhaustion.
- App foreground after an expiration interval, future.

Refresh should preserve user trust:

- Keep current deck stable while a background refresh runs.
- Avoid reordering visible cards mid-gesture.
- Treat refresh failures as non-destructive when an existing queue is still usable.

## Hard Filters

Initial hard filters:

| Filter | Owner | Required Behavior |
| --- | --- | --- |
| Self exclusion | Auth/Profile | Current user must never appear. |
| Account eligibility | Profile/System | Restricted, deleted, inactive, or non-discoverable profiles are excluded. |
| Discovery readiness | Profile/System | Candidate must satisfy approved Discovery Ready contract. |
| Sport compatibility | Profile/Sports | Candidate must match active discovery sport. |
| Visibility | Profile/Privacy | Candidate visibility must allow discovery display. |
| Blocking/hidden | Profile/Safety, future | Blocked/hidden relationships are excluded once available. |
| Prior presentation | Discovery | Already-presented candidates are excluded within the active queue. |
| Prior decision | Discovery, future | Prior decisions are excluded once decision persistence exists. |

If a filter depends on a not-yet-approved schema, the implementation must expose it as a typed placeholder or mocked exclusion path, not silently ignore it.

## Soft Preference Inputs

Soft inputs annotate candidates but do not exclude them:

- Skill compatibility.
- Availability overlap.
- Play intent.
- Coarse location compatibility.
- Travel radius compatibility.
- Profile completeness.
- Shared future event/social context.

Soft signals must not be exposed as raw scores. User-facing explanations require approved recommendation contracts.

## Candidate Contracts

### `CandidateCard`

Contains only display-safe fields:

- Candidate ID.
- Display name.
- Profile photo reference, optional.
- Primary sport and compatible skill summary.
- Short bio or safe profile summary, optional.
- Availability summary, optional.
- Coarse location/home-area summary, optional.
- Safe recommendation context labels.
- Allowed actions for the current queue state.

### `DiscoveryQueue`

Contains:

- Queue ID or local request ID.
- Ordered `CandidateCard` list.
- Queue state.
- Empty/exhausted reason, optional.
- Refresh eligibility.
- Retry guidance.

Generated Supabase types must map into these domain contracts before they reach ViewModels.

## Interaction with Profile Repository

Discovery consumes Profile through approved contracts and repository protocols:

- Discovery must not query full editable profile models.
- Discovery must not mutate Profile data.
- Profile readiness, visibility, account status, and sport compatibility should be consumed as contract effects.
- Missing optional Profile fields should degrade candidate cards gracefully.

This plan depends on Profile repository/contract work becoming approved before Supabase-backed candidate loading begins.

## Interaction with Future Events

Events are not required for the first candidate deck. Future event-aware recommendations may provide:

- Event sport context.
- Event location area.
- Organizer or participant compatibility.
- Recently completed game signals.

Events remain the owner of Event data. Discovery should consume Event summaries only through approved Event contracts.

## Privacy, Blocking, and RLS

Privacy rules override convenience:

- Exact user location must never be used in Candidate Cards.
- Private availability details must not leak into queue explanations.
- Blocked or hidden relationships must be enforced before presentation once the source data exists.
- Server-side filtering must be added when Supabase schema/RLS can enforce it.
- Client-side filtering is acceptable only as defense-in-depth or for mock/local phases.

RLS planning:

- Candidate queries must only return profiles discoverable to the current user.
- RLS policies should enforce account, visibility, and blocking exclusions where possible.
- Service role behavior must not bypass privacy without a documented service boundary.

## Validation Strategy

- Unit-test hard filters with deterministic fixtures.
- Unit-test queue lifecycle transitions.
- Unit-test empty and exhausted states.
- Unit-test mapping from Profile contracts to Candidate contracts.
- Add mock repository tests for Swipe ViewModel state.
- Use Swift build/tests for implementation PRs.
- Include screenshots for UI state changes when the deck consumes the repository.

## Rollout Plan

1. Introduce domain contracts and repository protocol behind existing UI.
2. Add mock/deterministic candidate source and ViewModel integration.
3. Swap Swipe deck loading to repository-backed queue state.
4. Add Supabase-backed source after Profile schema/RLS approval.
5. Add decision persistence and match creation in later approved plans.

## Risks

- Profile contract/schema delays can block Supabase-backed Discovery.
- Client-only filtering could create privacy risk if mistaken for final enforcement.
- Mock pipeline behavior could be misread as ranking logic.
- Queue refresh can create confusing duplicate cards if identity rules are weak.
- Future Event/social signals could tempt feature-local ranking unless repository boundaries stay firm.

## Definition of Done

- Discovery repository protocol exists and is used by Swipe ViewModels.
- Candidate and queue contracts exist as domain models.
- Deterministic candidate pipeline is testable without UI.
- Hard filters and empty/exhausted behavior are implemented for approved inputs.
- Generated or backend DTOs do not reach SwiftUI.
- Privacy and blocking placeholders are explicit until server enforcement exists.
- Jira stories are complete, reviewed, and merged.

## Jira Breakdown

- Epic: `SOCIAL-56` - SWIPE-003: Candidate Deck and Recommendation Pipeline
- `SOCIAL-57` - Discovery: Create candidate and queue domain contracts
- `SOCIAL-58` - Discovery: Add DiscoveryRepository protocol and mock implementation
- `SOCIAL-59` - Discovery: Implement deterministic candidate pipeline service
- `SOCIAL-60` - Discovery: Add queue refresh, empty, and exhausted state handling
- `SOCIAL-61` - Discovery: Wire candidate queue into Swipe ViewModel
- `SOCIAL-62` - Discovery: Document Supabase candidate query and RLS requirements
- `SOCIAL-63` - Discovery: Add candidate pipeline regression tests
