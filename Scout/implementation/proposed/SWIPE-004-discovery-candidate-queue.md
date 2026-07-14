# Implementation Tech Plan: SWIPE-004 Discovery Candidate Queue

## Status

Proposed

## Product Domain

SWIPE / DISCOVERY

## Jira Project

SOCIAL

## Source of Truth

References:

- `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md`
- `implementation/proposed/SWIPE-002-recommendation-inputs-and-candidate-pipeline.md`
- `implementation/proposed/SWIPE-003-candidate-deck-and-recommendation-pipeline.md`
- `implementation/proposed/PROFILE-004-profile-database-schema.md`
- `implementation/proposed/PROFILE-005-public-profile-and-owner-profile.md`

## Problem Statement

The Swipe deck cannot rely on mock candidates for production. Scout needs a real Discovery candidate queue backed by Profile data, privacy filters, exclusions, pagination, refresh, and repository-owned queue state. This plan replaces mock candidates without introducing ranking algorithms.

## Goals

- Generate candidates from approved Profile contracts.
- Apply hard filters, privacy filters, blocked/hidden exclusions, and prior-decision exclusions.
- Add pagination and refresh behavior.
- Implement a backend/data-source boundary for candidate reads.
- Keep ranking algorithm work out of scope.

## Non-goals

- Ranking/scoring/ML.
- Match lifecycle implementation.
- Swipe decision persistence except exclusion input if already approved.
- Event-aware recommendations.
- Feed recommendations.

## Architecture

```text
Swipe ViewModel
  -> DiscoveryRepository
  -> CandidateQueueDataSource
  -> Profile contracts / Supabase query or RPC
  -> CandidateCard contracts
```

The backend/data source owns candidate eligibility. iOS owns presentation state, pagination requests, refresh intent, and retry handling.

## Implementation Sequencing

1. Add candidate queue request/response contracts.
2. Add Supabase-backed candidate data source or approved RPC boundary.
3. Apply hard filters and exclusions.
4. Add pagination/refresh/exhaustion behavior to repository.
5. Replace mock candidate source in Swipe ViewModel.
6. Add regression tests.

## Repository Ownership

DiscoveryRepository owns queue lifecycle, refresh, pagination, and error mapping. It does not own Profile fields or Match creation.

## Domain Ownership

Discovery owns queue and exclusions. Profile owns candidate profile data. Match owns matches. Events may later provide context, but V1 candidate queue is player-only.

## Backend Ownership

Supabase/RLS must prevent ineligible private profiles from being returned. If direct reads cannot enforce enough privacy, this plan should use an RPC/Edge boundary approved by architecture/security.

## iOS Responsibilities

- Request candidate pages.
- Render loading/refreshing/empty/exhausted/error states.
- Never recompute eligibility or ranking in UI.
- Preserve queue identity across swipe gestures.

## Filtering and Exclusions

Hard filters:

- Current user exclusion.
- Discovery-ready profiles only.
- Discoverable/visible profiles only.
- Shared sport context.
- Account status eligible.
- Blocked/hidden users excluded when data exists.
- Previously shown/decided candidates excluded within approved window.

Soft preference inputs may be passed through as metadata only.

## Pagination and Refresh

- Queue returns bounded pages.
- Refresh should not duplicate visible candidates.
- Exhaustion returns a user-safe reason.
- Network failure preserves existing queue where possible.

## Validation Strategy

- Unit tests for request/response contracts.
- Repository tests for pagination, refresh, empty, exhausted, and error states.
- Backend/RLS tests for privacy filters.
- Swipe ViewModel tests proving mock source is removed.

## Rollout Strategy

1. Build behind mock-compatible repository protocol.
2. Enable Supabase-backed queue for internal/dev users.
3. Monitor empty queue and privacy failure cases.
4. Expand after Profile schema/RLS validation.

## Risks

- Client-side filtering could leak private candidates if backend is too broad.
- Pagination can resurface duplicates.
- Queue refresh can conflict with gesture state.
- Teams may accidentally treat simple ordering as ranking.

## Definition of Done

- Swipe deck no longer depends on hardcoded/mock production candidates.
- Candidate queue is repository-backed.
- Hard filters and exclusions are enforced by backend or documented defense-in-depth.
- Pagination, refresh, empty, exhausted, and error states are covered.
- No ranking algorithm is implemented.

## Jira Breakdown

- Epic: `SOCIAL-97` - SWIPE-004: Discovery Candidate Queue

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `SOCIAL-98` | Discovery Queue: Define request response contracts | 🤖 AI Implementation | 1 | SWIPE-004 |
| 2 | `SOCIAL-99` | Discovery Queue: Implement Supabase candidate data source | 🤖 AI Implementation | 2 | `SOCIAL-98`, DB-001, PROFILE-004 |
| 3 | `SOCIAL-100` | Discovery Queue: Apply filters exclusions and duplicate prevention | 🤖 AI Implementation | 2 | `SOCIAL-98`, `SOCIAL-99`, SWIPE-002 |
| 4 | `SOCIAL-101` | Discovery Queue: Replace mock candidates in Swipe ViewModel | 🤖 AI Implementation | 2 | `SOCIAL-99`, `SOCIAL-100` |
| 5 | `SOCIAL-102` | Discovery Queue: Add queue regression tests | 🤖 AI Implementation | 1 | `SOCIAL-100`, `SOCIAL-101` |
