# Implementation Tech Plan: Profile UI Update

## Status

Proposed

## Owner

TODO

## Product Domain

PROFILE

## Source of Truth

This plan proposes how future iOS work should display and edit the v1 identity fields from `implementation/proposed/PROFILE-002-v1-identity-field-set.md`.

Authoritative inputs:

- `tech-plans/approved/DESIGN-001-design-system.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `docs/design/DESIGN_SYSTEM.md`
- `docs/architecture/API_BOUNDARIES.md`

This document remains `Proposed` until the product owner explicitly approves it. SOCIAL-29 creates this plan for review only; it does not change SwiftUI code, app models, repositories, media upload, schema, generated types, Xcode settings, or Supabase artifacts.

This plan is numbered `PROFILE-006` so `PROFILE-004` can remain the profile contracts plan and `PROFILE-005` can remain the profile media storage plan.

## Problem Statement

Scout needs a reviewed iOS plan before changing onboarding, profile editing, or profile display surfaces for the v1 identity field set. The current app already has onboarding and profile-builder flows, but PROFILE-002 changes the planning vocabulary around identity, sports, availability, privacy, readiness, and media. Future implementation should update those surfaces incrementally, reuse existing ScoutDesign components, and avoid a broad redesign.

## Goals

- Identify likely affected iOS areas.
- Map PROFILE-002 fields to onboarding, profile editing, and display surfaces.
- Reference DESIGN-001 design authority and component reuse rules.
- Document loading, empty, error, validation, accessibility, and screenshot requirements for future UI tickets.
- Keep future UI implementation small and reviewable.

## Non-goals

- Changing SwiftUI code.
- Adding fields to app models or repositories.
- Implementing media upload.
- Changing schema or generated types.
- Redesigning onboarding, profile, swipe, or navigation.
- Creating new design tokens or components.

## Current iOS Areas to Inspect Before Implementation

Future implementation tickets should inspect these areas before editing:

- `Scout/AuthGate/Views/Onboarding/OnboardingView.swift`
- `Scout/AuthGate/ViewModels/OnboardingViewModel.swift`
- `Scout/Profile/Views/ProfileBuilderView.swift`
- `Scout/Profile/ViewModels/ProfileBuilderViewModel.swift`
- `Scout/Data/Profiles/ProfileRepository.swift`
- `Scout/Data/Profiles/ProfileDTO.swift`
- `Scout/Data/Profiles/ProfileProviding.swift`
- `Scout/Domain/Profile.swift`
- `Scout/Swipe/Views/SwipeCardIdentitySection.swift`
- `Scout/Swipe/Views/SwipeDeckScreen.swift`
- `Scout/Design/Components`
- `Scout/Design/Theme`
- `Scout/Design/Typography`

This plan does not authorize moving files or changing app architecture.

## Design Authority

DESIGN-001 is the UI authority for this plan.

Future UI tickets must:

- Reuse existing ScoutDesign components when they fit.
- Inspect `Scout/Design/` before adding UI primitives.
- Avoid new typography, spacing, color, radius, shadow, or motion scales without approved design work.
- Preserve native iOS navigation, gestures, controls, accessibility behavior, and interaction expectations.
- Document loading, empty, error, and accessibility states.
- Include screenshots for UI implementation PRs.
- Avoid broad visual redesign while updating profile field coverage.

## Field-to-Surface Map

| PROFILE-002 Field | Onboarding Surface | Profile Editing Surface | Display / Contract Surface | Validation and State Notes |
| --- | --- | --- | --- | --- |
| `display_name` | Required in onboarding basics. | Editable in profile identity section. | Discovery, Event, Chat, Search, Notifications. | Required, trimmed, 2-40 visible characters. Inline validation should explain recovery. |
| `username` | Deferred from required onboarding. | Optional future field if approved. | Public Profile, Search, future web. | Keep hidden or optional until handle strategy is approved. |
| `profile_photo` | Optional prompt or nudge. | Editable media slot. | Discovery, Event, Chat summaries when allowed. | Strongly recommended, not a hard v1 gate. Upload UI waits for media storage approval. |
| `action_photo` | Not required in onboarding. | Optional enrichment slot. | Rich profile, Feed, Public Profile. | Fully Complete enrichment. Upload UI waits for media storage approval. |
| `bio` | Not required for first onboarding pass unless approved. | Editable text area. | Discovery/Public Profile/Event contexts when visible. | Needs max length and content validation before implementation. |
| `sports` | Required sport selection. | Editable sports list. | Discovery, Events, Search, Recommendations. | At least one supported sport for Discovery Ready. |
| `primary_sport` | Derived from first selected sport when only one exists. | Editable/default sport control when multiple sports exist. | Discovery, Events, Recommendations. | Must be one of selected sports. |
| `skill_level_by_sport` | Required for primary sport when readiness requires Discovery. | Editable per selected sport. | Discovery, Events, Search. | Pickleball labels remain open before final UI labels. |
| `preferred_days` | Optional. | Editable availability section. | Recommendations, Events, Notifications. | Do not block onboarding or Events v1 unless later approved. |
| `preferred_times` | Optional. | Editable availability section. | Recommendations, Events, Notifications. | Use coarse windows; exact options require approval. |
| `play_intent` | Optional prompt if low friction. | Editable preference/availability field. | Discovery and Event summaries if set. | Approved option labels required before UI implementation. |
| `home_area` | Required only when location-based Discovery/Events are active. | Editable coarse area field. | Discovery, Events, Maps, Recommendations, Search. | Must avoid exact home address. Precision language must be explicit. |
| `travel_radius` | Optional. | Editable recommendation preference. | Recommendations and Events. | Default remains TBD. |
| `preferred_play_style` | Optional. | Editable preference field. | Recommendations, Discovery, Events. | Option labels require approval. |
| `profile_visibility` | Default setting may be introduced after privacy copy approval. | Editable privacy setting. | All consumers. | User-facing visibility options remain deferred. |
| `discoverable` | Consent/enablement point after Discovery Ready. | Editable privacy toggle. | Discovery, Recommendations, Search. | Default false until readiness and onboarding explicitly enable or confirm. |
| `location_precision` | Explained alongside location permission or home area. | Editable privacy/location setting. | Discovery, Events, Maps, Recommendations. | Must communicate coarse versus more precise sharing. |
| `profile_completion_state` | Used for progress and prompts. | Read-only progress/requirements. | Onboarding, Discovery, Events, Chat. | Derived; user cannot directly edit. |
| `account_status` | Not directly edited. | Not directly edited. | All surfaces as eligibility filter. | Safety/restriction messaging requires Trust/Auth planning. |
| `created_at` | Not shown by default. | Not editable. | System/analytics/trust only. | No user-facing UI unless later approved. |
| `last_active_at` | Not shown. | Not editable. | Future recommendations/trust only. | User-visible use is deferred. |

## Proposed Screen Plan

### Onboarding

Future onboarding work should keep first-run setup focused on Basic Identity and Discovery Ready fields only:

- Name/display name.
- Sport selection.
- Primary sport handling.
- Primary sport skill once labels are approved.
- Coarse location/home area only when location-based Discovery or Events are active.
- Discoverability consent or confirmation after readiness requirements are met.
- Optional profile photo nudge without blocking completion.

Onboarding should avoid requiring bio, action photo, full availability, travel radius, username, or preferred play style unless a later approved plan changes readiness.

### Profile Builder / Editing

Future profile editing work should support progressive completion:

- Identity fields.
- Media slots for profile photo and action photo only after media storage is approved.
- Sports and primary sport.
- Per-sport skill.
- Availability and play intent enrichment.
- Privacy settings and discoverability.
- Read-only completion/readiness guidance.

Profile editing should preserve the existing step-based or section-based structure unless a later design plan approves a navigation change.

### Display Surfaces

Future display work should consume profile contracts, not full profile state:

- Swipe/Discovery should use Swipe Summary or Search Summary.
- Events should use Event Summary.
- Chat should use Chat Summary.
- Notifications should use Notification Summary.
- Public/rich profile surfaces should wait for the Public Profile contract.

## UI States Required for Future Tickets

Every future UI implementation ticket generated from this plan must document:

- Loading state for profile fetch/save.
- Empty state for missing optional fields.
- Inline validation for required fields and invalid values.
- Error state for save, upload, permission, and network failures.
- Disabled state for blocked readiness actions.
- Success or saved state.
- Accessibility labels, hints, Dynamic Type behavior, and VoiceOver order.
- Screenshot requirements for light/dark mode if both are supported.
- Screenshot requirements for compact and regular width where the surface materially changes.

## Open Decisions Requiring Approval

- Final pickleball skill labels and visual control.
- Final visibility option labels and privacy copy.
- Whether discoverability is an explicit onboarding step or a profile setting confirmed after readiness.
- Whether home area is entered manually, derived from location permission, or both.
- Travel radius default and UI control.
- Whether profile photo appears in onboarding before storage is implemented.
- Whether profile editing remains step-based or moves to grouped settings sections.
- Whether Public Profile preview is part of v1.

## Suggested Jira Stories

Do not create these until this plan is approved.

- `Profile: Approve profile UI update plan`
- `Profile: Update onboarding identity fields`
- `Profile: Add primary sport skill UI`
- `Profile: Add profile privacy and discoverability UI`
- `Profile: Add profile readiness guidance`
- `Profile: Add profile media slots after storage approval`
- `Profile: Update profile display previews`
- `Profile: Add UI screenshots and accessibility validation`

## Testing Strategy

This proposed plan requires documentation review only.

Future implementation should validate:

- Form validation and recovery.
- Loading, empty, error, disabled, and success states.
- Accessibility and Dynamic Type.
- Screenshot coverage for changed screens.
- Navigation and dismissal behavior.
- Contract-based display rather than raw profile state.
- No new design primitives unless explicitly approved.

## Rollout Plan

1. Approve or revise PROFILE-002 field decisions.
2. Approve profile contracts and schema/RLS plans needed by UI.
3. Review and approve this UI plan.
4. Create small iOS implementation tickets by screen or field group.
5. Add media UI only after storage and upload behavior are approved.
6. Validate changed screens with screenshots and accessibility notes.

## Definition of Done

- Affected iOS areas are identified.
- PROFILE-002 fields are mapped to UI surfaces and validation states.
- DESIGN-001 authority and component reuse rules are referenced.
- Loading, empty, error, accessibility, and screenshot requirements are documented.
- No production UI, model, repository, schema, upload, Xcode, or Supabase change is made by this plan.
