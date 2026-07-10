# Implementation Tech Plan: PROFILE-004 Profile Database Schema

## Status

Proposed

## Product Domain

PROFILE / PLAYER IDENTITY

## Jira Project

SOCIAL

## Source of Truth

This plan implements the approved Player Identity model in Supabase. It depends on DB-001 and narrows prior Profile plans into production schema work.

References:

- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`
- `implementation/proposed/PROFILE-004-profile-contracts.md`
- `implementation/proposed/DB-001-supabase-database-foundation.md`
- `docs/database/RLS.md`

## Problem Statement

Profile is the source of truth for Player Identity across Discovery, Events, Feed, Chat, Notifications, and future recommendations. Scout needs a reviewed Supabase schema, generated types, and RLS policies before production repositories and screens can rely on real profile data.

## Goals

- Implement minimum V1 profile tables and relationships.
- Persist profile readiness and completion state.
- Persist visibility/discoverability fields required by downstream domains.
- Add generated type workflow for Profile tables.
- Add RLS policies for owner, public profile, and service-role behavior.
- Avoid leaking private fields to downstream domains.

## Non-goals

- Profile UI implementation.
- Media upload/storage implementation.
- Ratings, teams, achievements, clubs, or league history.
- Discovery ranking or Event participation logic.

## Architecture

```text
Supabase profile tables
  -> generated Supabase types
  -> Profile data mappers
  -> Profile domain models/contracts
  -> ProfileRepository
  -> iOS ViewModels and downstream repositories
```

Generated database types are data-layer only. SwiftUI and downstream domains consume Profile contracts, not raw rows.

## Tables and Relationships

Candidate V1 tables:

- `profiles`: one row per auth user; owns identity, readiness, visibility, system status.
- `profile_sports`: user sports, primary sport flag, skill level.
- `profile_availability`: coarse preferred days/times and play intent.
- `profile_privacy`: discoverability, visibility, location precision, hidden sports where approved.

Optional/deferred:

- `profile_blocks`
- `profile_media`
- `profile_reputation`
- `profile_badges`

The first schema should stay additive and small. Media storage can reference URL/path fields only if storage policy is approved.

## Profile Readiness

Persist enough state to compute:

- Account Created
- Basic Identity
- Discovery Ready
- Event Ready
- Fully Complete

Readiness may be stored as computed columns, views, or app-computed effects, but downstream domains must consume stable Profile contracts.

## Profile Visibility

Visibility rules:

- Owner sees full editable profile.
- Public consumers receive public profile contract only.
- Discovery receives discovery-safe summary only.
- Chat receives chat-safe summary only.
- Events receives participant/organizer summary only.

Private fields must be protected by RLS and contract mapping.

## Migration Strategy

- Use DB-001 migration naming and validation.
- Include table constraints, indexes, and foreign keys.
- Enable RLS in the same migration or follow-up story before app consumption.
- Refresh generated types after migration.

## RLS Requirements

- Owner can read/update own profile tables.
- Public reads are limited to approved public/discovery fields.
- Unauthenticated reads are disabled unless explicitly approved.
- Service role behavior is documented.
- Blocked/hidden behavior is deferred unless required by V1 schema.

## iOS Responsibilities

- Add generated types only below data layer.
- Add mapping tests from generated rows to Profile contracts.
- Do not update UI directly from generated rows.
- Surface missing/incomplete profile states through domain errors.

## Validation Strategy

- Local migration apply/reset.
- RLS tests for owner, other authenticated user, unauthenticated user, service role.
- Generated type refresh.
- Mapper tests for profile contracts.
- Seed data for local/dev only.

## Rollout Strategy

1. Land migration and RLS in `scout-dev`.
2. Generate types.
3. Add Profile repository implementation in later stories/plans.
4. Gate UI consumption until RLS validation passes.

## Risks

- Over-modeling future identity domains too early.
- RLS exposing private fields through broad selects.
- Readiness logic drifting between app and database.
- Generated types leaking into SwiftUI.

## Definition of Done

- Profile V1 schema exists in migrations.
- RLS policies protect owner/private/public access.
- Generated types are refreshed.
- Profile contract mapping path is ready for repository work.
- No Profile UI is implemented by this plan.

## Jira Breakdown

- Epic: `SOCIAL-87` - PROFILE-004: Profile Database Schema
- `SOCIAL-88` - Profile DB: Create V1 profile schema migration
- `SOCIAL-89` - Profile DB: Add profile RLS policies
- `SOCIAL-90` - Profile DB: Generate Supabase types for profile schema
- `SOCIAL-91` - Profile DB: Add profile contract mapper tests
