# Implementation Tech Plan: PROFILE-005 Public Profile and Owner Profile

## Status

Proposed

## Product Domain

PROFILE / PLAYER IDENTITY

## Jira Project

SOCIAL

## Source of Truth

References:

- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-004-profile-contracts.md`
- `implementation/proposed/PROFILE-004-profile-database-schema.md` as the schema/RLS dependency for repository-backed profile surfaces.
- `tech-plans/approved/DESIGN-001-design-system.md`

## Problem Statement

Scout needs the first production profile experience backed by the Profile repository: an owner-editable profile, a public profile, navigation entry points, and stable loading/empty/error states. This is the user-facing layer that makes Player Identity real in the app.

## Goals

- Implement owner profile view.
- Implement public profile view.
- Implement edit profile flow for V1 fields.
- Consume ProfileRepository and approved contracts.
- Add navigation entry points from current app surfaces.
- Support profile readiness, incomplete, loading, saving, error, and empty states.

## Non-goals

- Schema creation.
- Media upload/storage beyond existing approved fields.
- Discovery, Event, Feed, or Chat feature behavior.
- New design tokens.

## Architecture

```text
Profile screens
  -> Profile ViewModels
  -> ProfileRepository
  -> Profile domain contracts
  -> Supabase-backed repository
```

Owner Profile uses the full editable owner contract. Public Profile uses public-safe fields only. Editing sends update commands through the repository; views do not mutate generated types.

## Implementation Sequencing

1. Add owner/public profile ViewModels.
2. Build owner profile screen with readiness/completion state.
3. Build edit profile form for approved V1 fields.
4. Build public profile screen.
5. Add navigation entry points and tests.

## Repository Ownership

ProfileRepository owns reads, update commands, validation errors, and mapping. Screens own presentation and user intent only.

## Domain Ownership

Profile owns Player Identity. Downstream domains link to public/profile summaries but do not edit Profile data.

## Backend Ownership

Supabase/RLS owns persistence and access control. Profile UI must assume unauthorized/private fields can be denied by backend.

## iOS Responsibilities

- Use ScoutDesign reusable components where available.
- Show loading, saving, saved, incomplete, validation error, and retry states.
- Avoid displaying private owner-only fields in Public Profile.
- Include screenshots in UI PRs.

## Validation Strategy

- ViewModel unit tests for load/edit/save/error paths.
- Contract tests proving public view excludes private fields.
- Manual QA for owner/public navigation.
- Swift build/tests.
- Screenshots for main states.

## Rollout Strategy

1. Land behind existing navigation entry or guarded route.
2. Enable owner profile first.
3. Enable public profile links from safe surfaces.
4. Expand downstream profile entry points after validation.

## Risks

- Public profile accidentally exposing owner/private fields.
- Edit flow bypassing repository validation.
- Navigation links to incomplete profiles creating confusing states.
- Duplicating UI instead of using ScoutDesign.

## Definition of Done

- Owner profile can load and display current user's profile.
- Owner can edit approved V1 fields through ProfileRepository.
- Public profile displays only public-safe contract fields.
- Loading, empty/incomplete, error, saving, and success states are covered.
- Tests and screenshots are included for UI PRs.

## Jira Breakdown

- Epic: `SOCIAL-92` - PROFILE-005: Public Profile and Owner Profile

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `SOCIAL-93` | Profile: Add owner and public profile ViewModels | 🤖 AI Implementation | 1 | PROFILE-004 contracts, PROFILE-004 schema/RLS |
| 2 | `SOCIAL-94` | Profile: Build owner profile screen | 🤖 AI Implementation | 2 | `SOCIAL-93`, DESIGN-001 |
| 3 | `SOCIAL-95` | Profile: Build V1 edit profile flow | 🤖 AI Implementation | 2 | `SOCIAL-93`, PROFILE-002, DESIGN-001 |
| 4 | `SOCIAL-96` | Profile: Build public profile screen and navigation | 🤖 AI Implementation | 2 | `SOCIAL-93`, `SOCIAL-94`, DESIGN-001 |
