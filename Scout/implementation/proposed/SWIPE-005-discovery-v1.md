# Implementation Tech Plan: SWIPE-005 Discovery V1

## Status

Proposed

## Owner

TODO

## Product Domain

SWIPE / DISCOVERY

## Source of Truth

This plan translates the Discovery and Recommendation domain guidance in `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md` into a proposed v1 implementation-readiness plan.

Authoritative inputs:

- `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `tech-plans/approved/EVENT-001-games-and-events.md`
- `implementation/proposed/PROFILE-004-profile-contracts.md`
- `docs/architecture/API_BOUNDARIES.md`

This document remains `Proposed` until the product owner explicitly approves it. SOCIAL-21 creates this plan for review only; it does not implement ranking, schemas, migrations, services, APIs, Supabase functions, or UI.

This plan is numbered `SWIPE-005` so `SWIPE-002` can remain the recommendation inputs and eligibility plan, `SWIPE-003` can remain the candidate deck pipeline plan, and `SWIPE-004` can remain the discovery candidate queue plan. SWIPE-005 is an umbrella implementation-readiness plan for Discovery V1, not a competing SWIPE-002 authority.

## Problem Statement

SWIPE-001 defines Discovery as the domain authority for candidate eligibility, ranking, decisions, matches, exclusions, and learning. It does not approve a production implementation path.

Without a focused Discovery V1 plan, future stories may implement candidate cards, queue behavior, decisions, exclusions, and matches directly from conceptual guidance, causing duplicated ranking logic, inconsistent match creation, weak privacy boundaries, or premature schema decisions.

## Goals

- Define the narrow v1 Discovery implementation scope.
- Identify the v1 recommendation inputs needed to produce a candidate queue.
- Define the contracts consumed by the swipe deck and adjacent features.
- Specify candidate queue behavior, decision semantics, match authority, and exclusions at an implementation-planning level.
- Keep recommendation scoring server-owned unless an ADR explicitly approves another ownership model.
- Identify approvals required before production work begins.

## Non-goals

- Implementing the swipe UI.
- Implementing recommendation ranking.
- Creating or changing database schema.
- Creating migrations, RLS policies, SQL views, RPCs, Edge Functions, or generated types.
- Creating implementation tickets from this proposed plan.
- Choosing analytics event names or data pipeline architecture.
- Approving ML, collaborative filtering, or advanced learning.

## V1 Scope

Discovery V1 should provide the first safe path from an eligible viewer to a small set of compatible candidate cards.

In scope for implementation planning:

- Candidate eligibility inputs.
- Candidate card contract.
- Discovery queue contract.
- Decision result contract.
- Match result contract.
- Exclusion handling.
- Empty deck behavior.
- Basic UI surfaces needed to render and act on cards.
- Repository/service boundaries for a future implementation.
- Test and rollout expectations.

Out of v1:

- Advanced ranking, collaborative filtering, ML, or personalization models.
- Public web discovery.
- Team matching.
- Feed-native recommendation ranking.
- Event recommendation ranking beyond consuming approved Event context.
- Undo, rewind, paid boosts, or gamified swipe mechanics.

## Recommendation Inputs

Discovery V1 should start with deterministic, explainable inputs.

| Input Category | Source Domain | V1 Use | Boundary |
| --- | --- | --- | --- |
| Viewer identity | Profile / Auth | Identify the requesting user and suppress self-recommendations. | Auth and Profile remain source of truth. |
| Candidate identity summary | Profile | Render safe card identity and profile context. | Use approved Profile contracts; do not read full profile state from UI. |
| Sports compatibility | Profile | Match viewer and candidate sports and skill context. | Profile owns sports fields and visibility. |
| Availability | Profile / Events | Prefer plausible overlap where approved. | Raw availability exposure requires Profile contract approval. |
| Location and travel radius | Profile / Events | Filter for practical local relevance. | Use privacy-safe precision only. |
| Preferences | Profile / Discovery | Apply explicit discovery preferences when approved. | Preferences are not broadly public fields. |
| Event context | Events | Support future event-adjacent recommendations. | Events owns event identity, visibility, lifecycle, and participant state. |
| Account and lifecycle state | Auth / Profile / Trust & Safety | Exclude inactive, restricted, deleted, suspended, hidden, or non-discoverable accounts. | Safety and privacy override ranking. |
| Prior decisions | Discovery | Avoid repeating candidates after pass, interest, match, hide, or block. | Discovery owns decision state. |
| Blocks, reports, and hides | Trust & Safety / Discovery | Prevent unsafe or unwanted presentation. | Exclusions override presentation. |

Future implementation stories must document the exact field names and persistence source after Profile and database plans are approved.

## Contracts

Consumers should receive narrow contracts rather than internal recommendation state.

### Candidate Card

Primary consumer: Swipe Deck.

Required conceptual fields:

- Candidate identifier.
- Safe profile display summary.
- Sport and skill context.
- Compatibility reason or recommendation summary.
- Privacy-safe location or play-area context when approved.
- Availability summary when approved.
- Allowed actions.
- Exclusion-safe state needed by the UI.

Candidate Card must not expose internal scoring weights, raw ranking inputs, hidden safety fields, exact private location, raw availability, or full profile state.

### Discovery Queue

Primary consumer: Swipe Deck.

Required conceptual fields:

- Viewer identifier context.
- Ordered candidate card list.
- Queue cursor or refresh token if required.
- Empty-state reason category.
- Refresh policy.
- Safe debug or explainability metadata only if approved.

Discovery Queue ordering is authoritative for presentation. The client may render and paginate the queue, but it must not recalculate ranking.

### Decision Result

Primary consumers: Swipe Deck, future Recommendations, Feed.

Required conceptual fields:

- Candidate identifier.
- Decision type.
- Result status.
- Whether the decision produced or updated a match.
- Next recommended UI action.

Decision Result must be idempotent. Retrying the same decision should not create duplicate decisions, duplicate matches, or contradictory user-visible state.

### Match Result

Primary consumers: Swipe Deck, Chat, Notifications, Feed.

Required conceptual fields:

- Match identifier.
- Matched participants.
- Match creation status.
- Safe next actions such as open chat or coordinate play.
- Notification eligibility.

Match creation must have one authoritative owner. Chat and Notifications consume match state; they do not create Discovery matches.

### Exclusion Result

Primary consumers: Discovery, Swipe Deck, future Feed and Recommendations.

Required conceptual fields:

- Candidate identifier.
- Safe exclusion reason category when the UI needs one.
- Whether the exclusion is temporary or durable.
- Whether recovery or broadened filters may be offered.

User-facing copy must not reveal private, safety-sensitive, moderation, block, or report details.

## Candidate Queue Behavior

Discovery V1 should treat the queue as a server-owned or repository-owned ordered result, not as UI state.

Queue rules:

- Apply privacy, account status, block, report, hidden, and visibility exclusions before presentation.
- Exclude the viewer.
- Exclude candidates already decided on unless an approved future plan defines resurfacing.
- Exclude existing matches unless the surface explicitly requests matched users.
- Return a stable page or batch of candidates for the active session where practical.
- Provide an empty-state category instead of forcing the UI to infer why no candidates exist.
- Allow refresh without losing authoritative decision state.

Empty-state categories should distinguish:

- No eligible candidates nearby.
- Filters or preferences too narrow.
- Profile not discovery-ready.
- Safety or privacy restrictions.
- Temporary backend or network failure.

## Decisions

V1 decision types:

- Interest.
- Pass.
- Hide or dismiss if approved for v1.

Decision requirements:

- Decisions are recorded once per viewer/candidate/action context.
- Replayed requests are idempotent.
- Decisions update queue eligibility through Discovery-owned logic.
- The UI may optimistically animate but must reconcile with the authoritative result.
- Future undo or rewind requires a separate approved plan.

## Exclusions

V1 exclusion categories:

- Self.
- Blocked in either direction.
- Reported or safety-restricted.
- Hidden or dismissed.
- Already decided.
- Already matched.
- Not discoverable.
- Private or visibility-incompatible.
- Incomplete or not discovery-ready.
- Outside approved location, sport, skill, availability, or preference filters.

Exclusions must be centralized in the Discovery implementation boundary. Swipe Deck, Feed, Events, Chat, Profiles, and Notifications must not create separate exclusion systems.

## Match Creation

Discovery V1 may create a match only when mutual interest is detected through the authoritative decision path.

Match creation requirements:

- One canonical match record or contract exists for a matched pair.
- Duplicate mutual-interest retries do not create duplicate matches.
- Block, report, restricted account, deleted account, or incompatible visibility state suppresses match creation.
- Chat and notification side effects occur only after authoritative match state exists.
- Match creation ownership, persistence, and transactional guarantees require database/security approval before implementation.

## UI Surfaces

V1 UI planning should be limited to surfaces needed by Discovery.

Expected surfaces:

- Swipe deck candidate card.
- Empty deck state.
- Decision feedback.
- Match confirmation.
- Basic error or retry state.

UI boundaries:

- Views render Candidate Card and Discovery Queue contracts.
- View models coordinate presentation and user intent.
- Repositories or services own calls to the approved Discovery boundary.
- UI code must not compute ranking, eligibility, exclusions, or match creation.

## Service and API Boundaries

Recommendation scoring should be treated as server-owned unless an ADR approves client-side ownership.

Future implementation must choose an approved boundary before production work:

| Option | When It Fits | Required Approval |
| --- | --- | --- |
| App-layer repository with Supabase reads | Earliest iOS-only deterministic filtering where RLS and documented query rules are sufficient. | Database/RLS review and API boundary review. |
| SQL view or RPC | Eligibility, queue, or match creation needs database-enforced filtering or idempotency. | Migration, RLS, generated types, and security approval. |
| Edge Function | Match creation, ranking, fan-out, secrets, or transactional orchestration requires server authority. | Edge Function architecture and secrets/security approval. |
| Future backend service | Cross-platform recommendation service becomes necessary. | ADR for service ownership and API contract. |

Required boundary rules:

- Candidate queues and decisions must be exposed through documented contracts.
- Profile data must come from Profile contracts.
- Event context must come from Event contracts.
- Safety and privacy filters must run before presentation.
- Real secrets, service-role access, and privileged operations must not be exposed to clients.

## Testing Strategy

This proposed plan requires documentation review only.

Future implementation should include:

- Unit tests for deterministic eligibility and exclusion rules.
- Idempotency tests for decisions and match creation.
- Contract tests for Candidate Card, Discovery Queue, Decision Result, Match Result, and Exclusion Result.
- Repository/service tests for empty-state categories and retry behavior.
- Privacy and safety tests for blocked, reported, hidden, private, restricted, deleted, and suspended users.
- UI tests for card rendering, decision feedback, empty deck, error, and match confirmation states.
- Integration tests for Profile and Event contract consumption once approved.

## Rollout Plan

1. Review and approve or revise this proposed plan.
2. Approve required Profile contract and database/RLS plans.
3. Decide the Discovery implementation boundary and create any required ADR.
4. Approve schema, migration, RLS, RPC, Edge Function, or service plans if needed.
5. Create focused implementation stories for contracts, queue behavior, decisions, exclusions, match creation, and UI surfaces.
6. Implement behind a feature flag or limited internal rollout if the chosen boundary supports it.
7. Validate with deterministic tests before expanding recommendation inputs or consumers.

## Required Approvals Before Implementation

- Database and RLS approval for any new Discovery, decision, match, exclusion, or queue persistence.
- Security approval for server-owned scoring, match creation, privileged reads, service-role access, or Edge Functions.
- API boundary approval if contracts are shared across iOS, web, Edge Functions, RPCs, or future services.
- ADR if recommendation scoring ownership moves away from server-owned behavior or introduces a new architectural layer.
- Product approval for any user-facing privacy, match, or exclusion behavior.

## Open Decisions

- Which Discovery V1 boundary is approved: repository-only, SQL view, RPC, Edge Function, or service?
- What exact Profile contracts are available for Candidate Card and eligibility?
- What persistence model stores decisions, matches, hides, and exclusions?
- Does V1 include hide/dismiss separately from pass?
- Does V1 support only player-to-player matching, or any event-adjacent recommendation context?
- What empty-state categories are user-facing versus internal?
- What feature flag or rollout mechanism should gate Discovery V1?

## Suggested Jira Stories

Do not create these until this plan is approved.

- `Discovery: Approve V1 implementation boundary`
- `Discovery: Define Candidate Card contract`
- `Discovery: Define Discovery Queue contract`
- `Discovery: Define decision persistence and idempotency`
- `Discovery: Define match creation authority`
- `Discovery: Define exclusion and empty-state behavior`
- `Discovery: Implement V1 repository or service boundary`
- `Discovery: Build V1 swipe deck integration`
- `Discovery: Add V1 contract, privacy, and idempotency tests`

## Definition of Done

- Proposed plan is reviewed against SWIPE-001.
- V1 scope, non-goals, contracts, queue behavior, decisions, exclusions, match creation, UI surfaces, service/API boundaries, testing, rollout, and approvals are explicit.
- Recommendation scoring remains server-owned unless an ADR approves otherwise.
- Required ADR, database, RLS, security, API, and product approvals are identified.
- No production code, schema, migration, API, generated type, Supabase artifact, or UI is created by this plan.
