# Implementation Tech Plan: V1 Identity Field Set

## Status

Proposed

## Owner

TODO

## Product Domain

PROFILE

## Source of Truth

This plan narrows `tech-plans/approved/PROFILE-001-player-profile-system.md` into a proposed minimum viable v1 identity model. It does not redefine Player Identity.

This document remains `Proposed` until the product owner explicitly approves it. The SOCIAL-22/SOCIAL-24 decision review below captures implementation-readiness recommendations for review; approval happens through the normal Jira and PR review flow.

PROFILE-001 remains the canonical domain authority for:

- Player Identity philosophy.
- Conceptual domains.
- Ownership boundaries.
- Profile contracts.
- Privacy posture.
- Lifecycle and completion principles.

Related database planning documents:

- `docs/database/DATABASE.md`
- `docs/database/SUPABASE.md`
- `docs/database/MIGRATIONS.md`
- `docs/database/RLS.md`
- `implementation/proposed/INFRA-001-database-foundation.md`
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`

## Problem Statement

Scout needs a small, practical v1 profile field set that can unlock Discovery, Events, and Chat planning without turning the first database implementation into a broad profile platform. The field set must be useful for real-world play, privacy-aware, extensible, and clear enough to generate later database, API, UI, and storage implementation plans.

## Goals

- Define a proposed v1 identity field set.
- Identify readiness requirements for Discovery, Events, and Chat.
- Define conceptual field metadata without choosing SQL schema.
- Preserve PROFILE-001 domain boundaries and profile contracts.
- Identify product decisions requiring approval, revision, or deferral before schema or UI implementation.
- Suggest Jira work without creating tickets yet.

## Non-goals

- Creating Supabase tables.
- Writing migrations.
- Changing iOS models, views, repositories, or storage code.
- Defining final SQL types, indexes, RLS, or storage buckets.
- Implementing profile completion scoring.
- Adding new onboarding requirements.
- Implementing media upload.

## Proposed V1 Field Set

Conceptual data types are not SQL decisions.

| Field | Domain | Description | Conceptual Type | Required | Editable | Validation | Default | Visibility | Downstream Consumers | Why It Exists | Readiness |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `display_name` | Identity | Human-readable name shown in profile summaries. | Short text | Yes | Yes | 2-40 visible characters; trim whitespace; no empty value. | From auth metadata if available, otherwise empty until set. | Discovery/Event/Chat summaries subject to privacy. | Discovery, Events, Chat, Feed, Search, Notifications | Helps players recognize each other and makes coordination human. | Discovery Ready, Event Ready, Chat Ready |
| `username` | Identity | Stable Scout handle for identity and future sharing. | Short unique text | Proposed optional for v1 | Yes | 3-24 characters; lowercase letters, numbers, underscore; uniqueness later. | None | Public where profile is visible. | Search, Public Profile, Chat, Notifications, future web | Supports durable identity beyond display name. | Fully Complete |
| `profile_photo` | Identity | Primary face/profile image. | Media reference | Optional, strongly encouraged | Yes | Approved image type/size; owner-controlled; moderation later. | None | Discovery/Event/Chat summaries if present. | Discovery, Events, Chat, Feed, Search | Builds trust and recognition. | Discovery Ready recommended, Event Ready recommended, Chat Ready recommended |
| `action_photo` | Identity | Sports-context image showing play/personality. | Media reference | Optional | Yes | Approved image type/size; owner-controlled; moderation later. | None | Public profile and rich cards if present. | Discovery, Feed, Public Profile | Adds sports context without making Scout feel like a dating app. | Fully Complete |
| `bio` | Identity | Short personal sports-oriented description. | Text | Optional | Yes | Max length TBD; no abusive content; trim whitespace. | Empty | Public profile/discovery when allowed. | Discovery, Events, Public Profile, Feed | Helps users explain play style, goals, and personality. | Fully Complete |
| `sports` | Sports | Sports the player participates in. | List of sport references | Yes | Yes | At least one for Discovery; values must be supported sports. | Empty until selected | Visible in profile summaries. | Discovery, Events, Feed, Search, Recommendations | Core matching and event relevance input. | Discovery Ready, Event Ready |
| `primary_sport` | Sports | Main sport for onboarding and default matching. | Sport reference | Yes if more than one sport | Yes | Must be one of `sports`. | First selected sport if only one. | Visible in profile summaries. | Discovery, Events, Recommendations, Feed | Provides default context for v1 while remaining multi-sport extensible. | Discovery Ready, Event Ready |
| `skill_level_by_sport` | Sports | Player-reported skill level for each supported sport. | Map/list of sport to skill level | Yes for primary sport | Yes | Must use approved skill options; sport-specific levels need approval. | None | Visible in Discovery and Event contexts unless hidden. | Discovery, Events, Recommendations, Search | Helps compatible players find each other without overemphasizing status. | Discovery Ready, Event Ready |
| `preferred_days` | Availability | Days the player usually prefers to play. | List of weekdays | Optional for v1 | Yes | Valid weekday values; empty allowed. | Empty | Used for recommendations; displayed only where helpful. | Discovery, Events, Recommendations, Notifications | Improves match/event relevance without blocking onboarding. | Fully Complete; Event Ready recommended |
| `preferred_times` | Availability | Time windows the player usually prefers. | List of time windows | Optional for v1 | Yes | Valid coarse windows; exact times deferred. | Empty | Used for recommendations; displayed only where helpful. | Discovery, Events, Recommendations, Notifications | Helps coordination and future scheduling. | Fully Complete; Event Ready recommended |
| `play_intent` | Availability | Competitive, casual, or flexible intent. | Enum-like value | Optional | Yes | Must be approved option. | Flexible/unspecified | Visible in Discovery/Event summaries if set. | Discovery, Events, Recommendations | Helps reduce mismatch and anxiety around play expectations. | Discovery Ready recommended, Event Ready recommended |
| `home_area` | Availability | Coarse location or play area. | Coarse location descriptor | Required for location-based discovery/events if enabled | Yes | Must avoid exact home address; precision rules TBD. | None | Coarse only before higher-trust contexts. | Discovery, Events, Maps, Recommendations, Search | Supports local matching while protecting privacy. | Discovery Ready, Event Ready |
| `travel_radius` | Availability | Approximate distance the player is willing to travel. | Distance range | Optional | Yes | Approved range values; no exact tracking. | Product default TBD | Used for recommendations; usually not directly public. | Discovery, Events, Maps, Recommendations | Helps recommend realistic players and games. | Discovery Ready recommended, Event Ready recommended |
| `preferred_play_style` | Preferences | Lightweight preference for casual/open/competitive play. | Enum/list | Optional | Yes | Approved options only. | Unspecified | Used for personalization; displayed selectively. | Discovery, Events, Recommendations | Improves relevance without adding heavy setup. | Fully Complete |
| `profile_visibility` | Privacy | Controls who can view profile summaries. | Visibility setting | Yes | Yes | Approved visibility options only. | Default protects user while allowing core product use. | System-enforced. | All consumers | Makes privacy explicit before broad profile consumption. | Discovery Ready, Event Ready, Chat Ready |
| `discoverable` | Privacy | Whether the user can appear in discovery. | Boolean | Yes | Yes | Must respect account status and blocking rules. | False until Discovery Ready or user opts in, pending approval. | System-enforced. | Discovery, Recommendations, Search | Prevents accidental exposure before readiness. | Discovery Ready |
| `location_precision` | Privacy | Controls coarse versus more precise location sharing. | Precision setting | Yes if location features enabled | Yes | Approved precision levels only. | Coarse | System-enforced. | Discovery, Events, Maps, Recommendations | Protects users while supporting real-world coordination. | Discovery Ready, Event Ready |
| `profile_completion_state` | System | Current profile readiness/completion level. | Lifecycle/completion state | Yes | No direct edit | Derived from approved fields. | Account Created | Owner/system; summaries may use readiness indirectly. | Onboarding, Discovery, Events, Chat, Notifications | Enables progressive onboarding and feature readiness. | All readiness checks |
| `account_status` | System | Whether account is active, restricted, disabled, or deleted. | Status value | Yes | No | Owned by auth/trust systems. | Active after account creation. | System-only except safety messaging. | All consumers, Trust & Safety | Prevents inactive/restricted users from appearing incorrectly. | All readiness checks |
| `created_at` | System | Account/profile creation timestamp. | Timestamp | Yes | No | System-generated. | Creation time | System/owner; rarely public. | Trust & Safety, Analytics, Recommendations | Supports lifecycle and auditing. | None |
| `last_active_at` | System | Recent activity signal. | Timestamp | Optional/system-managed | No | System-generated; privacy review before display. | None | System-only in v1 unless approved. | Recommendations, Events, Trust & Safety | Helps avoid stale recommendations later. | Future |

## Minimum Profile Requirements

Readiness states are planning contracts for downstream consumers. They do not define database schema, generated types, onboarding enforcement, or implementation logic.

| Readiness State | Required Fields | Recommended Fields | Downstream Consumers | Dependencies and Notes |
| --- | --- | --- | --- | --- |
| Account Created | `account_status`, `created_at`, `profile_completion_state` | None | Onboarding, AuthGate, Trust & Safety, Analytics | Created after authentication. Does not make a user discoverable or eligible for social surfaces. |
| Basic Identity | Account Created fields, `display_name` | `profile_photo` | Onboarding, Profile editing, Chat fallback summaries, Notifications | Supports human recognition before sports readiness. `profile_photo` remains optional per SOCIAL-24. |
| Discovery Ready | Basic Identity fields, `sports`, `primary_sport`, `skill_level_by_sport` for primary sport, `profile_visibility`, `discoverable = true`, `account_status = active`, plus `home_area` and `location_precision` when location-based Discovery is active | `profile_photo`, `play_intent`, `travel_radius` | Discovery, Recommendations, Search, Feed, Public Profile summaries | `discoverable` must remain consent- and readiness-dependent. Location must be coarse until schema/privacy planning defines precision. |
| Event Creator Ready | Discovery Ready fields, event-relevant sport/skill context, `account_status = active` | `profile_photo`, `play_intent`, availability fields, future verification/reputation signals | Events, Feed, Notifications, Chat, Trust & Safety | Photo, verification, reputation, and completed availability are deferred trust gates, not v1 readiness blockers unless a later Events/Trust plan changes them. |
| Event Join Ready | `display_name`, `sports`, event-relevant sport/skill when event rules require it, `profile_visibility`, `account_status = active` | `profile_photo`, `home_area` or event-area compatibility, `play_intent` | Events, Chat, Notifications, Organizer participant summaries | Event-specific eligibility may add sport/skill constraints, but profile readiness should not expose private fields outside approved event contracts. |
| Chat Ready | `display_name`, `profile_visibility`, `account_status = active` | `profile_photo`, sports context when tied to a match or event | Chat, Notifications, Match summaries, Event participant summaries | Chat must use the approved Chat Summary contract and avoid exposing private profile fields. |
| Fully Complete | Discovery Ready and Event Ready fields, `bio`, `action_photo`, `preferred_days`, `preferred_times`, `travel_radius`, `preferred_play_style` | `username`, richer media, future trust/reputation signals | Discovery, Events, Feed, Recommendations, Public Profile, Search | Enrichment state only. It should improve quality and trust without becoming a hidden v1 gate. |

### Discovery

Minimum proposed Discovery Ready profile:

- `display_name`
- `sports`
- `primary_sport`
- `skill_level_by_sport` for primary sport
- `home_area` if location-based discovery is active
- `profile_visibility`
- `discoverable = true`
- `location_precision`
- `account_status = active`

Strongly recommended but not required:

- `profile_photo`
- `play_intent`
- `travel_radius`

### Creating an Event

Minimum proposed Event Creator Ready profile:

- Discovery Ready requirements.
- No restricted account status.

Recommended but not required for v1 readiness:

- `profile_photo`
- `play_intent`
- Availability fields.

Deferred trust gates:

- Required photo.
- Verified email or phone.
- Minimum reputation.
- Completed availability.

### Joining an Event

Minimum proposed Event Join Ready profile:

- `display_name`
- `sports`
- sport/skill relevant to the event if required by event rules
- `profile_visibility`
- `account_status = active`

Recommended:

- `profile_photo`
- `home_area` or event-area compatibility
- `play_intent`

### Chat

Minimum proposed Chat Ready profile:

- `display_name`
- `profile_visibility`
- `account_status = active`

Recommended:

- `profile_photo`
- Sports context when chat is tied to a match/event.

Chat should use the approved Chat Summary contract and avoid exposing private profile fields.

## Profile Completion Levels

Completion levels are lifecycle labels derived from the readiness rules above. They should degrade gracefully when optional fields are missing.

### Account Created

User has authenticated and system fields exist.

Required fields:

- `account_status`
- `created_at`
- `profile_completion_state`

Downstream consumers:

- Onboarding
- AuthGate
- Trust & Safety
- Analytics

### Basic Identity

User can recognize and edit their identity.

Required fields:

- `display_name`

Recommended fields:

- `profile_photo`

Downstream consumers:

- Onboarding
- Profile editing
- Chat fallback summaries
- Notifications

### Discovery Ready

User can appear in discovery and recommendations.

Required fields:

- Basic Identity.
- `sports`
- `primary_sport`
- `skill_level_by_sport` for primary sport.
- `profile_visibility`
- `discoverable = true`
- `account_status = active`
- `home_area` if location-based discovery is active.
- `location_precision` if location-based discovery is active.

Recommended fields:

- `profile_photo`
- `play_intent`
- `travel_radius`

Downstream consumers:

- Discovery
- Recommendations
- Search
- Feed
- Public Profile summaries

### Event Ready

User can create or join lightweight community games, subject to organizer/event rules.

Required fields:

- Discovery Ready.
- Event-relevant sport/skill context.

Recommended fields:

- `profile_photo`
- `play_intent`
- `preferred_days`
- `preferred_times`

Downstream consumers:

- Events
- Feed
- Notifications
- Chat
- Trust & Safety

### Chat Ready

User can participate in chat contexts without exposing private profile data.

Required fields:

- `display_name`
- `profile_visibility`
- `account_status = active`

Recommended fields:

- `profile_photo`
- Sports context when chat is tied to a match or event.

Downstream consumers:

- Chat
- Notifications
- Match summaries
- Event participant summaries

### Fully Complete

User has enriched profile data that improves compatibility and trust.

Required fields:

- Discovery Ready/Event Ready fields.
- `bio`
- `action_photo`
- `preferred_days`
- `preferred_times`
- `travel_radius`
- `preferred_play_style`

Recommended fields:

- `username`

Downstream consumers:

- Discovery
- Events
- Feed
- Recommendations
- Public Profile
- Search

## Visibility Guidance

Proposed visibility classes:

- Owner-only: full editable profile, system state.
- System-only: account status, derived completion, internal timestamps.
- Discovery-visible: display name, sports, primary sport, skill, profile photo if set, play intent if set, coarse home area if approved.
- Event-visible: display name, profile photo if set, relevant sports/skill, organizer/participant context, coarse location compatibility.
- Chat-visible: display name, profile photo if set, minimal sports context when tied to event/match.
- Public profile-visible: approved identity and sports context only.

Privacy rules from PROFILE-001 remain authoritative and should override every consumer.

## SOCIAL-24 Decision Review

SOCIAL-24 reviews the open PROFILE-002 product decisions so downstream planning can proceed without changing production code, database schema, Supabase storage, migrations, generated types, or iOS files.

| Decision | Outcome | Downstream Impact |
| --- | --- | --- |
| Is `username` required in v1 or deferred? | Deferred. Keep `username` optional in v1 planning. | Does not block profile schema or readiness planning. Blocks any v1 feature that requires durable public handles, profile URLs, or username search. |
| Is `profile_photo` required for Discovery Ready, Event creation, or only recommended? | Revised. Keep `profile_photo` optional but strongly recommended for Discovery, Event, and Chat readiness. Do not make it a hard v1 gate unless a later product decision changes trust requirements. | Allows onboarding/readiness planning to proceed without media upload as a blocker. Media storage planning can still support profile photos as an important enrichment path. |
| Can different sports have different skill levels in v1? | Approved for planning. Model skill as sport-specific conceptually, with primary sport skill required for readiness. | PROFILE-003 should preserve per-sport extensibility. Exact SQL shape and constraints remain schema-plan decisions. |
| Should availability be sport-specific in v1? | Deferred. Keep `preferred_days` and `preferred_times` profile-level and optional for v1. | Events and recommendations can reference availability as enrichment only. Sport-specific scheduling should wait for later Events/Recommendations planning. |
| How coarse should `home_area` be? | Revised. Require coarse location only when location-based Discovery or Events are active. Exact precision model is deferred. | PROFILE-003 and RLS planning must avoid exact home address storage/exposure and define privacy-safe precision before migration. |
| What is the default `travel_radius`? | Deferred. Keep `travel_radius` optional with a product default still TBD. | Does not block core readiness. Blocks final recommendation defaults and any UI copy that displays radius assumptions. |
| Does `discoverable` default to false until the user explicitly opts in? | Approved for planning. Default `discoverable` to false until the user is Discovery Ready and product onboarding explicitly enables or confirms discoverability. | Prevents accidental exposure. PROFILE-003 and UI plans should treat discoverability as both readiness- and consent-dependent. |
| What exact profile visibility options are approved? | Revised. Use the visibility classes in this plan for implementation planning, but defer final user-facing option labels and settings. | Consumer contracts and RLS planning can proceed using owner-only, system-only, discovery-visible, event-visible, chat-visible, and public-profile-visible classes. Final settings UI remains blocked. |
| Is Event creation gated by photo, verification, reputation, or completed availability? | Deferred. For v1 planning, Event creation requires active account status and Event Ready profile fields; photo, verification, reputation, and availability remain recommended or future trust gates. | Events planning may proceed with profile-readiness gates, but final organizer trust rules need a later Events/Trust decision before implementation. |
| What skill-level labels are product-approved for pickleball v1? | Deferred. Keep skill labels as approved-option placeholders until product labels are selected. | Blocks final enum/check constraint, seed data, and UI labels. Does not block documenting field ownership or readiness dependency. |
| Are `preferred_days` and `preferred_times` needed before Events v1? | Deferred. Treat both fields as optional enrichment before Events v1. | Events v1 should not depend on completed availability unless a later Events plan explicitly adds that gate. |
| Is `last_active_at` allowed to influence recommendations before being user-visible? | Deferred. Keep `last_active_at` system-managed and non-user-visible in v1 planning. | Recommendation ranking that uses activity recency requires a later privacy/product decision. Basic profile readiness is not blocked. |

### Approved Planning Baseline

The v1 planning baseline after SOCIAL-24 is:

- `display_name`, `sports`, `primary_sport`, primary sport skill, privacy/readiness fields, and active account status are the core readiness inputs.
- `home_area` and `location_precision` are required only when location-based Discovery or Events are active, and must remain coarse until a schema/privacy plan defines precision.
- `profile_photo`, `play_intent`, `travel_radius`, `preferred_days`, `preferred_times`, `preferred_play_style`, `bio`, `action_photo`, and `username` are enrichment fields unless a later approved plan makes them required.
- Profile visibility planning may use conceptual visibility classes, but final user-facing settings remain deferred.
- No schema, migration, storage, generated type, or iOS implementation work should start from this decision review alone.

### Deferred Decisions Blocking Later Work

The following decisions remain intentionally deferred and must be resolved in the relevant downstream plan before implementation:

- Pickleball v1 skill labels and whether they become enums, lookup rows, or validation constants.
- Exact `home_area` representation, allowed precision levels, and RLS exposure rules.
- Default `travel_radius` and recommendation behavior when radius is missing.
- Final profile visibility settings and user-facing copy.
- Event organizer trust gates beyond active account and Event Ready profile state.
- Whether availability becomes sport-specific after v1.
- Whether `last_active_at` can affect recommendations before users can inspect or control that signal.

## Downstream Docs and Plans to Update After Approval

- `docs/database/DATABASE.md`
- `docs/database/SUPABASE.md`
- `docs/database/RLS.md`
- `docs/architecture/API_BOUNDARIES.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`, only for clarifying references if needed
- Future `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`
- Future `implementation/proposed/PROFILE-004-profile-contracts.md`
- Future profile UI and editing implementation plan
- Future Discovery, Event, Chat, Search, and Notification implementation plans

## Suggested Jira Epics and Stories

Do not create these until this plan is approved.

Epic:

- `SOCIAL: Profile V1 Identity Field Set`

Stories:

- `Profile: Approve V1 identity field decisions`
- `Profile: Document profile readiness rules`
- `Profile: Draft profile schema and RLS implementation plan`
- `Profile: Draft profile contracts implementation plan`
- `Profile: Draft profile media storage implementation plan`
- `Profile: Draft profile UI update implementation plan`
- `Profile: Update downstream Discovery and Events planning references`

## Risks

- Too many required fields could block first value.
- Too few required fields could produce low-quality recommendations.
- Location precision decisions can affect user safety.
- Profile photo requirements can improve trust but increase onboarding friction.
- Skill-level modeling can become hard to change if v1 overfits pickleball.

## Testing Strategy

This proposed plan requires documentation review only.

Future implementation plans should test:

- Field validation.
- Profile readiness derivation.
- Privacy filtering by consumer contract.
- RLS policies.
- Missing-field fallbacks.
- Profile completion state updates.

## Rollout Plan

1. Review product decisions.
2. Approve or revise v1 field set.
3. Create Jira stories for schema/RLS, contracts, UI, media, and downstream plan updates.
4. Draft schema-specific implementation plan.
5. Create migrations only after schema/RLS plan approval.

## Definition of Done

- Proposed v1 field set is reviewed.
- Open decisions are resolved or explicitly deferred.
- No production code, schema, migration, storage bucket, or iOS file change is introduced.
- Next implementation plans can proceed without redefining Player Identity.
