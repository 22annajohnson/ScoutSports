# Implementation Tech Plan: MATCH-001 Match Lifecycle

## Status

Proposed

## Product Domain

MATCH / DISCOVERY

## Jira Project

SOCIAL

## Source of Truth

References:

- `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md`
- `implementation/proposed/SWIPE-004-discovery-candidate-queue.md`
- `implementation/proposed/CHAT-001-match-chat.md`
- `implementation/proposed/EVENT-002-community-games-v1.md`
- `implementation/proposed/EVENT-003-community-games-v1.md` for superseded Community Games context only; EVENT-002 is the current event authority for Match handoff planning.
- `tech-plans/approved/PROFILE-001-player-profile-system.md`

## Problem Statement

Discovery needs a real Match lifecycle after mutual interest. Match creation must be persisted, idempotent, privacy-safe, and able to hand off to Chat and Events without those domains creating matches themselves.

## Goals

- Persist matches from authoritative mutual-interest decisions.
- Guarantee idempotent match creation.
- Add MatchRepository and domain contracts.
- Update Profile/Discovery summaries where appropriate.
- Provide handoff contracts to Chat and Events.

## Non-goals

- Swipe candidate queue generation.
- Chat UI or message schema.
- Event creation.
- Ratings/reputation.
- Recommendation ranking.

## Architecture

```text
Discovery Decision
  -> MatchService / MatchRepository
  -> matches table
  -> Match contract
  -> Chat handoff / Event handoff
```

Discovery owns decisions. Match owns persisted mutual connection state. Chat consumes Match context. Events may consume Match participants for coordination suggestions.

## Implementation Sequencing

1. Add Match domain models and repository protocol.
2. Add Supabase schema/RLS for matches.
3. Implement idempotent match creation path.
4. Wire Discovery decision result to MatchRepository.
5. Add Chat/Event handoff contracts.
6. Add tests.

## Repository Ownership

MatchRepository owns match reads, creation, duplicate handling, and domain errors. It does not own candidate queues, profile edits, chat messages, or event participation.

## Domain Ownership

- Discovery owns decision input.
- Match owns mutual connection state.
- Profile owns participant summaries.
- Chat consumes match context.
- Events consume match context only for optional coordination handoff.

## Backend Ownership

Supabase owns match persistence, unique constraints, RLS, and idempotency guarantees. If transactional decision-plus-match creation cannot be safe client-side, an RPC/Edge Function must own the operation.

## iOS Responsibilities

- Call repository/service boundary after authoritative decision result.
- Render match confirmation from Match contract.
- Offer open-chat or plan-game actions only after match persistence succeeds.
- Handle duplicate/idempotent retries gracefully.

## Validation Strategy

- Unique constraint/idempotency tests.
- RLS tests for participants and unrelated users.
- Repository tests for create, existing match, blocked/restricted, deleted user.
- UI state tests for match confirmation/handoff actions.

## Rollout Strategy

1. Land schema/RLS.
2. Add repository and domain tests.
3. Wire Discovery decision path.
4. Enable match confirmation and handoffs.
5. Monitor duplicate-match failures and privacy denials.

## Risks

- Duplicate matches if idempotency is weak.
- Chat creating matches instead of consuming match context.
- Blocked/restricted users matching if filters drift.
- Event handoff implying game creation before user intent.

## Definition of Done

- Mutual interest creates or returns exactly one Match.
- Match state is persisted and RLS-protected.
- MatchRepository is the only iOS boundary for match creation.
- Chat/Event receive handoff contracts, not ownership.
- Tests cover duplicate and unauthorized cases.

## Jira Breakdown

- Epic: `SOCIAL-103` - MATCH-001: Match Lifecycle

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `SOCIAL-104` | Match: Add Match domain models and repository protocol | 🤖 AI Implementation | 1 | MATCH-001, SWIPE-001 |
| 2 | `SOCIAL-105` | Match: Create matches schema and RLS | 🤖 AI Implementation | 2 | DB-001, PROFILE-004, `SOCIAL-104` |
| 3 | `SOCIAL-106` | Match: Implement idempotent MatchRepository | 🤖 AI Implementation | 2 | `SOCIAL-104`, `SOCIAL-105` |
| 4 | `SOCIAL-107` | Match: Wire Discovery mutual interest to MatchRepository | 🤖 AI Implementation | 2 | `SOCIAL-106`, SWIPE-004 |
| 5 | `SOCIAL-108` | Match: Add Chat and Event handoff contracts | 🤖 AI Implementation | 1 | `SOCIAL-106`, CHAT-001, EVENT-002 |
