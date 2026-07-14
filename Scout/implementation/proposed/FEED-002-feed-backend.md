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

The Feed must stop relying on mock/static content and become Scout's ongoing social discovery surface. Scout needs a backend-backed FeedRepository that can support an endless feed experience similar to Instagram or Facebook while composing approved contracts from Events, Profile, and Discovery without owning their state or duplicating ranking logic.

The first implementation should not attempt a sophisticated ranking algorithm, but it must establish the contracts and loading behavior needed for a continuously scrollable feed that can grow as new feed sources are introduced.

## Goals

- Define Feed contracts and repository boundary.
- Replace mock feed with real repository data.
- Consume Event summaries, Profile summaries, and Discovery recommendation summaries.
- Keep Feed from owning source domain state.
- Add loading, empty, pull-to-refresh, continuous loading, and error behavior.
- Establish a feed contract that supports endless scrolling without exposing source-domain internals to the UI.

## Non-goals

- Feed ranking algorithm.
- Social posting.
- Comments/likes.
- Notification delivery.
- Event/Profile mutation.
- Segmented feed controls or manually requested batches in the feed contract.
- Infinite content guarantees when no eligible feed items exist.

## Architecture

```text
Feed ViewModel
  -> FeedRepository
  -> FeedSnapshot / FeedStream
  -> FeedItem contracts
  -> EventSummary / ProfileSummary / RecommendationSummary providers
```

Feed owns feed composition/presentation contracts. Events, Profile, and Discovery own their underlying data.

## Continuous Feed Model

The Feed should behave as a continuously scrollable surface. The user should be able to open the Feed, see relevant items, keep scrolling without seeing artificial breaks or manual loading controls, and pull to refresh for newer content.

V1 should define:

- `FeedSnapshot`: the current ordered feed item collection plus loading/error state.
- `FeedStream`: the repository-facing concept for observing or requesting the current feed collection.
- `refresh`: a read method that reloads from the top of the feed.
- `empty`: a state for when no eligible items are currently available.
- `loadingMore`: a continuous loading state that lets the UI show ongoing feed loading without exposing artificial batch boundaries.

The UI should not expose numbered sections or manual "load more" controls. It should consume a continuous ordered item collection and state from `FeedRepository`.

## Feed Item Ordering

V1 ordering may be simple and deterministic, such as source timestamp plus stable tie-breaking, until a future approved ranking plan exists. The important v1 requirement is that ordering is repository-owned and stable as the feed updates, so users do not see duplicated or jumping content while scrolling.

Feed consumers must not implement their own ranking or source merging logic in SwiftUI views.

## Implementation Sequencing

1. Define feed item contracts.
2. Add FeedRepository protocol and mock.
3. Add backend/source adapter for Event summaries.
4. Add Discovery/Profile recommendation adapters.
5. Replace mock feed in ViewModel.
6. Add tests.

## Repository Ownership

FeedRepository owns refresh, continuous feed loading, feed item composition, source merging, stable ordering, empty state, and error mapping. It does not mutate Event, Profile, or Discovery state.

## Backend Ownership

Initial backend may be repository-composed from existing Supabase reads/contracts. If personalized ranking or fanout is needed later, use an approved backend/RPC/Edge plan.

## iOS Responsibilities

- Render feed items from contracts.
- Support initial loading, continuous loading, empty, error, retry, and refresh states.
- Route actions to owning domains.
- Avoid duplicating Event/Profile/Discovery business rules.

## Validation Strategy

- Feed contract tests.
- Repository tests for mixed sources, refresh, continuous loading, stable ordering, empty/error.
- ViewModel tests proving mock feed is removed.
- UI screenshots for initial loading, continuous loading, empty, and error states.

## Rollout Strategy

1. Introduce repository behind existing Feed UI.
2. Replace static mocks with source adapters.
3. Enable internal/dev with deterministic feed ordering.
4. Add source expansion after Events/Discovery mature.

## Risks

- Feed becoming a second ranking system.
- Feed mutating source domain state.
- Mixed-source ordering becoming inconsistent.
- Duplicate feed items appearing during feed updates.
- Feed scroll behavior feeling finite if empty and loading states are unclear.
- Empty feed feeling broken without clear states.

## Definition of Done

- Feed uses FeedRepository.
- Mock production content is removed.
- Feed items consume source-domain contracts.
- Loading, continuous loading, empty, error, and refresh states are tested.

## Jira Breakdown

- Epic: `SOCIAL-109` - FEED-002: Feed Backend

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `SOCIAL-110` | Feed: Define continuous FeedItem contracts and source types | 🤖 AI Implementation | 1 | FEED-002 |
| 2 | `SOCIAL-111` | Feed: Add FeedRepository protocol and mock repository | 🤖 AI Implementation | 1 | `SOCIAL-110` |
| 3 | `SOCIAL-112` | Feed: Implement Event Profile and Discovery source adapters | 🤖 AI Implementation | 2 | `SOCIAL-110`, `SOCIAL-111`, source-domain contracts |
| 4 | `SOCIAL-113` | Feed: Replace mock feed in Feed ViewModel | 🤖 AI Implementation | 2 | `SOCIAL-112` |
| 5 | `SOCIAL-114` | Feed: Add continuous feed refresh and state regression tests | 🤖 AI Implementation | 1 | `SOCIAL-113` |
