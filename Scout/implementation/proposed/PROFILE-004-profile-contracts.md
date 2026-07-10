# Implementation Tech Plan: Profile Contracts

## Status

Proposed

## Owner

TODO

## Product Domain

PROFILE

## Source of Truth

This plan translates the Profile contract guidance in `tech-plans/approved/PROFILE-001-player-profile-system.md` into a proposed v1 implementation-readiness plan.

Authoritative inputs:

- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`
- `docs/architecture/API_BOUNDARIES.md`
- `docs/database/RLS.md`

This document remains `Proposed` until the product owner explicitly approves it. SOCIAL-27 creates this plan for review only; it does not implement contract queries, models, SQL views, RPCs, Edge Functions, APIs, database schema, generated types, or iOS code.

## Problem Statement

Scout's Discovery, Events, Chat, Feed, Search, and Notification surfaces need profile data, but they should not consume the full Player Identity model. Each surface needs a small, context-appropriate contract that exposes only the fields needed for that experience and applies privacy, visibility, readiness, account status, and relationship filters consistently.

Without explicit profile contracts, future implementation work could couple consumers directly to raw profile tables, duplicate filtering rules, or leak private fields into inappropriate contexts.

## Goals

- Define the v1 profile contracts required by PROFILE-001.
- Identify minimum fields for each consumer context.
- Make privacy and visibility boundaries explicit.
- Preserve PROFILE-001's rule that consumers receive contracts, not full profile state.
- Identify whether contracts are app-layer projections, SQL views, RPCs, Edge Functions, or future services as an open implementation decision.

## Non-goals

- Implementing contract queries.
- Creating Swift models or repository methods.
- Creating SQL views, RPCs, Edge Functions, or APIs.
- Changing database schema.
- Changing RLS policies.
- Adding generated types.
- Changing Discovery, Events, Chat, Feed, Search, Notifications, or Profile UI code.

## Contract Principles

- Profile owns Player Identity and contract definitions.
- Consumers request the narrowest contract that satisfies their use case.
- Privacy, visibility, account status, blocked relationships, hidden/private state, deleted/restricted/suspended accounts, and location precision override feature convenience.
- Missing optional fields should degrade gracefully rather than forcing consumers to reach for raw tables.
- System-only fields should never appear in user-facing contracts unless an approved plan explicitly exposes a safe derived value.
- Contract changes require a tech-plan update before multiple consumers depend on them.

## Proposed V1 Contracts

| Contract | Primary Consumers | Minimum Fields | Optional/Enrichment Fields | Privacy and Visibility Boundary | Readiness / Eligibility |
| --- | --- | --- | --- | --- | --- |
| Swipe Summary | Discovery, Recommendations | `profile_id`, `display_name`, `primary_sport`, primary sport skill, `profile_visibility`, `discoverable`, `account_status` | `profile_photo`, `play_intent`, `travel_radius`, coarse `home_area` when approved | Requires `discoverable = true`, compatible visibility, active account, block/hidden checks, and approved location precision. Must not expose private availability or system-only state. | Discovery Ready. |
| Event Summary | Events, Maps, Notifications | `profile_id`, `display_name`, event-relevant sport, event-relevant skill, `account_status` eligibility | `profile_photo`, `play_intent`, coarse event-area compatibility, approved trust signals later | Event context may expose only participant/organizer-appropriate fields. Must not expose exact home area, raw availability, private preferences, or unrelated profile fields. | Event Creator Ready or Event Join Ready depending on context. |
| Chat Summary | Chat, Notifications | `profile_id`, `display_name`, `profile_visibility`, `account_status` | `profile_photo`, minimal sports context when tied to a match or event | Chat should identify participants without exposing availability, location, private preferences, or full public profile data. Blocked/restricted/deleted accounts must be filtered or represented by approved safety states. | Chat Ready. |
| Public Profile | Feed, Search, future Web, richer Discovery contexts | `profile_id`, `display_name`, approved sports context, `profile_visibility`, `account_status` | `profile_photo`, `action_photo`, `bio`, `play_intent`, coarse location context, approved social/reputation signals later | Must vary by visibility context such as pre-match, post-match, event participant, friend, or public web. Public web exposure requires separate approval. | At least Discovery Ready for discovery-style use; exact public eligibility remains open. |
| Full Editable Profile | Profile UI, owner-only settings/editing | Full owner-editable identity, sports, availability, preferences, privacy settings, safe derived readiness state | Owner-visible media metadata, optional enrichment fields, future reputation read-only values | Owner-only except authorized admin/support contexts. Should expose effects of system state safely without allowing direct edits to system-owned fields. | Authenticated owner with active or recoverable account state. |
| Search Summary | Search, Discovery result lists, future web search | `profile_id`, `display_name`, primary sport, primary sport skill, `profile_visibility`, `discoverable`, `account_status` | `profile_photo`, `play_intent`, coarse `home_area` if approved | Must respect discoverability, location precision, blocked/hidden/private state, and account status. Should avoid raw availability and non-search profile details. | Discovery Ready or explicit search eligibility. |
| Notification Summary | Notifications, push/in-app copy | `profile_id`, safe display label, safe actor/action context | `profile_photo` only for in-app surfaces if approved | Must avoid leaking sensitive profile details outside the app. Push content should use the smallest safe identity reference and respect privacy/account status. | Context-specific; active account and notification permission rules apply. |

## Consumer Minimums

### Discovery

Discovery should use Swipe Summary or Search Summary depending on context.

Required contract behavior:

- Include only Discovery Ready users.
- Exclude non-discoverable, hidden, blocked, private, restricted, deleted, or suspended profiles.
- Apply approved location precision before exposing `home_area`.
- Treat profile photo, play intent, and travel radius as enrichment, not hard requirements.

### Events

Events should use Event Summary for organizers, participants, and event-adjacent notifications.

Required contract behavior:

- Distinguish Event Creator Ready from Event Join Ready.
- Include event-relevant sport and skill only.
- Keep organizer trust gates such as required photo, verification, reputation, or completed availability deferred until an Events/Trust plan approves them.
- Avoid exposing raw availability or exact home location.

### Chat

Chat should use Chat Summary for participants and notifications.

Required contract behavior:

- Include enough identity to recognize the participant.
- Include sports context only when tied to a match or event.
- Avoid availability, location, full bio, preferences, and system-only state.
- Respect blocked, restricted, deleted, and hidden account behavior.

### Feed and Public Profile

Feed should use Public Profile or a narrower future Feed Summary if richer feed-specific behavior emerges.

Required contract behavior:

- Respect visibility context before exposing rich identity fields.
- Treat action photo, bio, and social/reputation signals as optional enrichment.
- Require a later approval before exposing a public web profile.

### Notifications

Notifications should use Notification Summary.

Required contract behavior:

- Prefer safe short identity references.
- Avoid sensitive fields in push notification copy.
- Apply privacy and account-status checks before creating notification payloads.

## Contract Surface Decision

The implementation mechanism remains open. Future implementation plans must choose one or more of:

| Option | When It Fits | Tradeoff |
| --- | --- | --- |
| App-layer projections | Early iOS-only implementation where repositories fetch approved rows and map to narrow structs. | Fastest path, but privacy filtering must still be backed by RLS and documented query rules. |
| SQL views | Shared database-level contract for multiple clients. | Centralizes shape but requires migration approval and generated type strategy. |
| RPC functions | Contract needs server-side filtering or computed eligibility. | Stronger boundary, but adds database function surface and testing complexity. |
| Edge Functions | Contract needs secrets, fan-out, external services, or server authority. | Not appropriate for simple reads; requires separate Edge Function approval. |
| Future service layer | Cross-platform or complex contract orchestration. | Deferred until backend ownership strategy exists. |

Current planning recommendation: start with app-layer projections backed by documented RLS and repository boundaries unless PROFILE-003 approval selects SQL views or RPCs for shared contract enforcement.

## Privacy Filter Checklist

Every contract implementation story must define how it handles:

- Owner versus non-owner reads.
- Anonymous access.
- `profile_visibility`.
- `discoverable`.
- `location_precision`.
- Blocked users in both directions.
- Hidden/private profiles.
- Restricted, deleted, or suspended accounts.
- Optional missing fields.
- Service-role access, if any.
- Push notification privacy.

## Open Decisions Requiring Approval

- Are v1 contracts implemented first as app-layer projections, SQL views, RPCs, Edge Functions, or a mix?
- Does Public Profile exist in v1 beyond authenticated in-app contexts?
- Does Feed need its own narrower Feed Summary contract?
- What exact user-facing visibility options map to each contract?
- Which account status values suppress each contract?
- Are profile photos allowed in push notification payloads or only in-app notifications?
- Do Search Summary and Swipe Summary remain separate contracts in v1 or share one shape?
- Which contract owns future reputation/trust signals once those domains exist?

## Suggested Jira Stories

Do not create these until this plan is approved.

- `Profile: Approve profile contract surfaces`
- `Profile: Define Swipe/Search summary contract`
- `Profile: Define Event summary contract`
- `Profile: Define Chat summary contract`
- `Profile: Define Public Profile contract`
- `Profile: Define Full Editable Profile contract`
- `Profile: Define Notification summary contract`
- `Profile: Add contract privacy validation cases`

## Testing Strategy

This proposed plan requires documentation review only.

Future implementation should validate:

- Contract field inclusion and exclusion.
- Owner versus non-owner behavior.
- Visibility and discoverability filtering.
- Blocked, hidden, restricted, deleted, and suspended account filtering.
- Missing optional field fallbacks.
- Push notification privacy behavior.
- RLS positive and negative cases for every contract-backed query.

## Rollout Plan

1. Approve or revise PROFILE-002.
2. Approve or revise PROFILE-003 table/RLS boundaries.
3. Review and approve this profile contracts plan.
4. Create focused implementation stories for each approved contract surface.
5. Implement the narrowest contract surfaces needed by the first consuming feature.
6. Add contract validation before broadening consumers.

## Definition of Done

- V1 contracts are reviewed against PROFILE-001.
- Each consumer has a minimum profile contract.
- Privacy and visibility boundaries are explicit.
- Open implementation-surface decisions are approved or deferred.
- No production code, schema, migration, API, generated type, or Supabase artifact is created by this plan.
