# Implementation Tech Plan: FEED-002 Feed Backend

## Status

Proposed

## Product Domain

FEED / SOCIAL

## Jira Project

SOCIAL

## Source of Truth

References:

- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `tech-plans/approved/EVENT-001-games-and-events.md`
- `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md`
- `implementation/proposed/SWIPE-004-discovery-candidate-queue.md`
- `implementation/proposed/EVENT-002-community-games-v1.md`

## Problem Statement

The Feed must stop relying on mock/static content. Scout needs a backend-backed FeedRepository that composes approved contracts from Events, Profile, and Discovery without owning their state or duplicating ranking logic.

## Goals

- Define Feed contracts and repository boundary.
- Replace mock feed with real repository data.
- Consume Event summaries, Profile summaries, and Discovery recommendation summaries.
- Keep Feed from owning source domain state.
- Add loading, empty, pagination, refresh, and error behavior.

## Non-goals

- Feed ranking algorithm.
- Social posting.
- Comments/likes.
- Notification delivery.
- Event/Profile mutation.

## Architecture

```text
Feed ViewModel
  -> FeedRepository
  -> FeedItem contracts
  -> EventSummary / ProfileSummary / RecommendationSummary providers
```

Feed owns feed composition/presentation contracts. Events, Profile, and Discovery own their underlying data.

## Implementation Sequencing

1. Define feed item contracts.
2. Add FeedRepository protocol and mock.
3. Add backend/source adapter for Event summaries.
4. Add Discovery/Profile recommendation adapters.
5. Replace mock feed in ViewModel.
6. Add tests.

## Repository Ownership

FeedRepository owns pagination, refresh, feed item composition, and error mapping. It does not mutate Event, Profile, or Discovery state.

## Backend Ownership

Initial backend may be repository-composed from existing Supabase reads/contracts. If personalized ranking or fanout is needed later, use an approved backend/RPC/Edge plan.

## iOS Responsibilities

- Render feed items from contracts.
- Support loading/empty/error/refresh states.
- Route actions to owning domains.
- Avoid duplicating Event/Profile/Discovery business rules.

## Validation Strategy

- Feed contract tests.
- Repository tests for mixed sources, pagination, refresh, empty/error.
- ViewModel tests proving mock feed is removed.
- UI screenshots for feed states.

## Rollout Strategy

1. Introduce repository behind existing Feed UI.
2. Replace static mocks with source adapters.
3. Enable internal/dev.
4. Add source expansion after Events/Discovery mature.

## Risks

- Feed becoming a second ranking system.
- Feed mutating source domain state.
- Mixed-source pagination becoming inconsistent.
- Empty feed feeling broken without clear states.

## Definition of Done

- Feed uses FeedRepository.
- Mock production content is removed.
- Feed items consume source-domain contracts.
- Loading, empty, error, pagination, refresh states are tested.

## Jira Breakdown

- Epic: `SOCIAL-109` - FEED-002: Feed Backend

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `SOCIAL-110` | Feed: Define FeedItem contracts and source types | 🤖 AI Implementation | 1 | FEED-002 |
| 2 | `SOCIAL-111` | Feed: Add FeedRepository protocol and mock repository | 🤖 AI Implementation | 1 | `SOCIAL-110` |
| 3 | `SOCIAL-112` | Feed: Implement Event Profile and Discovery source adapters | 🤖 AI Implementation | 2 | `SOCIAL-110`, `SOCIAL-111`, source-domain contracts |
| 4 | `SOCIAL-113` | Feed: Replace mock feed in Feed ViewModel | 🤖 AI Implementation | 2 | `SOCIAL-112` |
| 5 | `SOCIAL-114` | Feed: Add pagination refresh and state regression tests | 🤖 AI Implementation | 1 | `SOCIAL-113` |
