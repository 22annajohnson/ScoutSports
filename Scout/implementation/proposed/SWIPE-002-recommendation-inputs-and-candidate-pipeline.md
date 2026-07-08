# Implementation Tech Plan: Recommendation Inputs and Candidate Pipeline

## Status

Proposed

## Owner

TODO

## Product Domain

SWIPE / DISCOVERY

## Jira Project

SOCIAL

## Work Type

Implementation-readiness plan. This document authorizes Jira planning only while status is `Proposed`.

## Source of Truth

This plan builds on the approved Discovery & Recommendation domain plan. It does not redefine Discovery philosophy, recommendation ownership, Player Identity, Event coordination, profile contracts, schema, or the final recommendation algorithm.

Authoritative inputs:

- `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-004-profile-repository-and-data-flow.md`
- `tech-plans/approved/EVENT-001-games-and-events.md`
- `tech-plans/approved/DESIGN-001-design-system.md`
- `docs/architecture/API_BOUNDARIES.md`
- `roadmap/SWIPE.md`
- `roadmap/DEPENDENCIES.md`

This plan must not be implemented until `PROFILE-002`, the required profile contract/repository work, and this plan are approved.

## Problem Statement

Scout needs a first implementation slice for Discovery that defines how candidates enter the recommendation pipeline, which data may be consumed, which rules are hard filters, which signals are soft preferences, and how the app should handle queue refresh and empty states.

This plan intentionally does not define or implement the ranking algorithm. The goal is to create stable contracts and boundaries so future agents can implement candidate loading, queue behavior, and presentation without duplicating recommendation logic or bypassing privacy/exclusion rules.

## Goals

- Define the v1 recommendation pipeline shape.
- Define candidate generation boundaries.
- Define hard filters and soft preference signals.
- Identify Profile, Event, future Social, and future Reputation inputs.
- Define candidate queue generation and refresh behavior.
- Define candidate exhaustion and empty state behavior.
- Define recommendation contracts used by iOS and future consumers.
- Define repository/service boundaries that keep ranking logic centralized.
- Define testing and rollout strategy for a non-algorithmic first slice.

## Non-goals

- Implementing the recommendation algorithm.
- Optimizing ranking.
- Creating machine learning models.
- Persisting swipe decisions or matches unless separately approved.
- Creating Supabase schema, migrations, RLS policies, generated types, or Edge Functions.
- Building production Candidate Card UI.
- Changing existing swipe gesture behavior.
- Implementing analytics tracking.
- Implementing Events, Chat, Feed, or Notifications consumers.

## Recommendation Philosophy

The first pipeline should optimize for safe, meaningful real-world compatibility rather than endless swiping. Candidate generation should be:

- Privacy-preserving.
- Deterministic enough to test.
- Small enough for v1.
- Extensible for future scoring, events, reputation, and social signals.
- Clear about what is hard exclusion versus soft preference.

The pipeline must never show a candidate just because the UI needs another card. Privacy, blocking, account status, eligibility, and exclusion rules always win.

## Conceptual Pipeline

```text
Current player context
  -> Candidate source pool
  -> Hard filters
  -> Soft preference annotation
  -> Queue assembly
  -> Candidate contracts
  -> Swipe deck / discovery surfaces
  -> Decision recording (future approved plan)
  -> Match/event coordination (future approved plan)
```

V1 should produce a candidate queue contract. It should not expose internal ranking scores or future model state to the UI.

## Candidate Generation

Candidate generation identifies possible player profiles before ranking.

Candidate sources:

- Active player profiles that are Discovery Ready.
- Profiles matching the current player's selected sport context.
- Profiles allowed by privacy/discoverability settings.
- Profiles not excluded by block/hidden/account-status rules.

Candidate generation must not:

- Read full Player Identity state directly in the swipe UI.
- Expose private profile fields to Discovery.
- Include inactive, suspended, deleted, restricted, hidden, blocked, or non-discoverable users.
- Depend on event data unless an approved event recommendation slice exists.

## Hard Filters

Hard filters remove candidates before queue assembly.

Initial hard filters:

| Filter | Source | Rule |
| --- | --- | --- |
| Self exclusion | Auth/Profile | Current player cannot see themselves. |
| Account status | Profile/System | Inactive, restricted, suspended, deleted, or otherwise ineligible accounts are excluded. |
| Discoverability | Profile/Privacy | Candidate must be discoverable for the current context. |
| Visibility | Profile/Privacy | Candidate visibility must allow Discovery display. |
| Blocking/hidden | Future Profile/Safety | Blocked or hidden relationships are excluded when model exists. |
| Sport compatibility | Profile/Sports | Candidate must share the active sport or approved discovery sport context. |
| Readiness | Profile/System | Candidate must meet Discovery Ready rules. |
| Prior decisions | Discovery | Candidate already accepted/rejected/skipped within approved exclusion window is excluded. |
| Match/exclusion state | Discovery | Existing match or explicit exclusion prevents duplicate presentation unless approved rule allows resurfacing. |
| Location precision | Profile/Privacy | Location-dependent filters must respect approved coarse precision only. |

If a hard filter cannot be enforced because a prerequisite data model is not approved, the implementation story must either defer that filter explicitly or stop for approval.

## Soft Preference Signals

Soft signals annotate candidates for future ranking. They must not be treated as hard filters unless explicitly approved.

Initial soft signals:

- Shared primary sport.
- Similar skill range.
- Compatible play intent.
- Availability overlap, if available.
- Coarse location/home-area compatibility, if approved.
- Travel radius compatibility, if approved.
- Preferred play style, if approved.
- Profile completeness.
- Freshness/recency, only after privacy approval.

Soft signals should be represented as input metadata for future ranking. The UI should not display private signal internals unless a contract explicitly exposes a safe label.

## Recommendation Inputs

### Profile Data Consumed

Discovery should consume approved Profile contracts, not raw profile tables.

Candidate input fields may include, when approved:

- Profile ID.
- Display name.
- Primary sport.
- Primary sport skill.
- Sports list or active discovery sport context.
- Discoverable flag/effect.
- Profile visibility effect.
- Account status effect.
- Coarse home area only when location-based Discovery is active and approved.
- Play intent.
- Availability summary.
- Travel radius.
- Profile photo as optional enrichment through approved contract.

Discovery must not consume:

- Full editable profile.
- Raw privacy settings when a filtered effect is sufficient.
- Exact home location.
- Private availability details not approved for Discovery.
- System-only fields except safe eligibility effects.

### Event Data Consumed

V1 player discovery should not depend on event data.

Future event-aware recommendations may consume:

- Event sport context.
- Event location/venue area.
- Event schedule window.
- Organizer/participant compatibility signals.
- Attendance/no-show history only after reputation/trust approval.

Events remain the owner of Event data. Discovery should consume Event contracts, not raw Event models.

### Future Social Signals

Future social signals may include:

- Mutual connections.
- Prior successful play.
- Team overlap.
- Friend-of-friend context.
- Shared clubs or venues.

These are deferred until the owning domains exist and contracts are approved.

### Future Reputation Signals

Future reputation signals may include:

- Attendance reliability.
- Organizer reliability.
- Sportsmanship.
- Verified player or organization status.
- Completed games.

Reputation is not part of v1 ranking. It must not be invented inside Discovery without an approved Reputation/Trust plan.

## Queue Generation

V1 queue generation should produce a bounded ordered list of candidate contracts.

Queue requirements:

- Use hard filters before queue assembly.
- Apply soft signal annotation without exposing internal ranking.
- Avoid duplicate candidates within the active queue.
- Preserve queue identity long enough for UI paging/swiping.
- Allow refresh when the user exhausts or manually refreshes the deck.
- Handle empty queue as a first-class state.

Queue output contract:

- Queue ID or request context identifier if needed.
- Ordered candidate list.
- Generated timestamp.
- Refresh eligibility.
- Empty-state reason category when no candidates exist.
- Debug metadata only in non-production/internal contexts if approved.

## Refresh Strategy

Refresh should be simple in v1:

- Initial load when Discovery screen appears.
- Manual refresh when empty or stale.
- Refresh after meaningful profile changes that affect eligibility.
- Refresh after decision recording only when future decision persistence is approved.

Refresh should not:

- Continuously poll.
- Create infinite swiping loops.
- Reintroduce excluded candidates without an approved resurfacing rule.
- Fetch excessive data to compensate for weak filtering.

## Candidate Exhaustion Behavior

Candidate exhaustion occurs when the pipeline has no eligible candidates for the current context.

Exhaustion categories:

- No profiles for sport/context.
- Profile not Discovery Ready.
- Privacy/discoverability disabled.
- Filters too restrictive.
- All candidates already seen/decided.
- Network/server unavailable.
- Unknown error.

The UI should receive a safe category and recovery suggestions, not internal query details.

## Empty State Behavior

Empty states should educate and guide the player toward real-world connection, not punish them.

Recommended recovery actions:

- Complete profile readiness requirements.
- Add or adjust sports.
- Enable discoverability.
- Broaden availability/preferences if user-controlled and approved.
- Try again later.
- Explore events when available.

The empty state should avoid exposing that specific users were filtered out due to privacy, blocking, or safety rules.

## Recommendation Contracts

### Candidate Card Contract

Consumed by the swipe deck or future discovery card surfaces.

Includes:

- Candidate profile ID.
- Safe display name.
- Approved photo reference or placeholder state.
- Active/shared sport.
- Skill label or bucket.
- Safe compatibility highlights.
- Optional play intent.
- Optional coarse area/availability label only when approved.

Excludes:

- Raw ranking score.
- Exact location.
- Full availability.
- Private preferences.
- Raw privacy/system fields.

### Discovery Queue Contract

Includes:

- Candidate Card list.
- Queue metadata.
- Refresh metadata.
- Empty/exhaustion state.

Excludes:

- Raw candidate pool.
- Internal scoring/ranking internals.
- Raw Profile/Event rows.

### Recommendation Summary Contract

Future contract for Feed or non-card surfaces.

Status: deferred until Feed/Recommendation consumer plan is approved.

### Match Notification Contract

Future contract for Notifications and Chat.

Status: deferred until decision/match persistence and Notifications domain plans are approved.

## Privacy Considerations

Discovery must:

- Respect Profile privacy and discoverability.
- Respect blocks, hidden users, restrictions, and account status.
- Use coarse location only when approved.
- Avoid exposing why a specific user is not shown.
- Avoid exposing internal scores or inferred sensitive traits.
- Avoid using `last_active_at` or reliability signals until approved.
- Treat recommendation scoring as server-owned unless an ADR approves otherwise.

## Repository and Service Boundaries

Conceptual boundaries:

- Profile owns profile contracts and readiness inputs.
- Discovery owns candidate eligibility, queue assembly, decisions, exclusions, and match creation once approved.
- Events owns event context and coordination data.
- UI owns presentation and gestures, not eligibility/ranking logic.

Recommended iOS boundary for first slice:

- `DiscoveryRepository` or existing Swipe data boundary fetches a `DiscoveryQueue`.
- ViewModels consume `DiscoveryQueue` and `CandidateCard` domain contracts.
- Hard-filter and queue rules should live in a centralized repository/service layer, not in SwiftUI views.
- If server-owned scoring is not yet available, any client-side v1 placeholder must be explicitly named as temporary and must not become a parallel ranking algorithm.

Any move to Edge Functions, RPCs, shared backend services, or ML services requires an approved plan and likely an ADR.

## Testing Strategy

Future implementation should validate:

- Hard filters exclude self, inactive users, non-discoverable profiles, unsupported sports, and previously decided candidates.
- Soft signals are annotated but do not hard-exclude unless approved.
- Candidate queue does not duplicate candidates.
- Empty/exhaustion categories are correct and safe.
- Candidate Card contract does not include private fields.
- ViewModels handle loading, loaded, empty, refresh, network error, and retry states.
- Recommendation logic is centralized and not duplicated in UI.

Testing may start with deterministic fixtures/mocks before Supabase integration is approved.

## Rollout Strategy

1. Approve Profile readiness/contracts required for Discovery.
2. Approve this SWIPE-002 plan.
3. Implement Candidate Card and Discovery Queue domain contracts.
4. Implement deterministic mock candidate pipeline for UI/ViewModel integration.
5. Implement repository boundary and hard-filter fixtures.
6. Connect to Profile repository/contracts only after Profile repository work is approved.
7. Add Supabase/backend-backed candidate generation only after schema/RLS and service ownership are approved.
8. Defer ranking optimization, decision persistence, match creation, and learning to later plans.

## Risks

| Risk | Mitigation |
| --- | --- |
| Agents implement ranking while building pipeline. | Keep ranking algorithm explicitly out of scope; use deterministic ordering or placeholders only when approved. |
| UI duplicates filter logic. | Centralize eligibility/queue behavior in repository/service layer. |
| Profile privacy is bypassed. | Consume Profile contracts and filtered eligibility effects only. |
| Empty deck feels broken. | Provide safe exhaustion categories and recovery actions. |
| Client placeholder becomes permanent algorithm. | Mark temporary behavior clearly and require ADR/plan for scoring ownership changes. |
| Event/reputation/social data is pulled in too early. | Keep future signals documented but deferred until owning domains/contracts exist. |
| Too many candidates are fetched to the client. | Keep bounded queue and server-owned scoring direction. |

## Jira Backlog

Create one Epic:

- `SOCIAL: Recommendation Inputs and Candidate Pipeline`

### Stories

| Order | Story | Work Type | Points | Dependencies | Repository Area |
| --- | --- | --- | ---: | --- | --- |
| 1 | Define Candidate Card and Discovery Queue domain contracts | 🤖 AI Implementation | 0.75 | SWIPE-002 approval, PROFILE-002 approval | iOS |
| 2 | Add deterministic mock candidate pipeline | 🤖 AI Implementation | 0.75 | Story 1 | iOS |
| 3 | Define hard-filter fixtures and validation cases | 🤖 AI Implementation | 0.75 | Story 1, Profile contract approval | iOS, Docs |
| 4 | Add DiscoveryRepository protocol and mock queue repository | 🤖 AI Implementation | 0.75 | Stories 1-2 | iOS |
| 5 | Implement candidate exhaustion and empty-state model | 🤖 AI Implementation | 0.5 | Stories 1-4 | iOS |
| 6 | Wire candidate pipeline into Swipe ViewModel boundary | 🤖 AI Implementation | 1 | Stories 1-5 | iOS |
| 7 | Review privacy and recommendation ownership boundaries | 🤝 Shared | 0.5 | Stories 1-6 | Docs, iOS |

Do not create implementation work from these stories until this plan is approved.

## Definition of Done

- Recommendation pipeline is defined without implementing a ranking algorithm.
- Candidate generation, hard filters, soft signals, queue behavior, refresh, exhaustion, and empty-state behavior are documented.
- Profile, Event, future Social, and future Reputation inputs are clearly separated by current versus future scope.
- Recommendation contracts are narrow and privacy-aware.
- Repository/service boundaries keep eligibility and ranking out of SwiftUI.
- Jira epic and stories are created with Scout story points and work-type labels.
- No production code, schema, migration, generated type, storage, Xcode, or app behavior changes are made by this planning PR.
