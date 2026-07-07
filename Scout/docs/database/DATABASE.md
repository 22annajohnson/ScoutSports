# Scout Database

## Purpose

This document defines the planning foundation for Scout's Supabase-backed data model. It should guide technical plans and Jira ticket creation, but it is not a live schema reference yet.

Schema, Row Level Security, storage, auth, and migration changes require explicit approval through a technical plan.

Related planning documents:

- `docs/database/SUPABASE.md`: Supabase operating model.
- `docs/database/MIGRATIONS.md`: proposed migration workflow.
- `docs/database/RLS.md`: RLS planning expectations and table policy template.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation implementation plan.
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`: proposed v1 Player Identity field set.
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`: future/proposed profile schema and RLS implementation plan.

## Current State

Scout uses Supabase for authentication, data, and storage. The iOS app currently contains Supabase-facing code under:

- `Scout/Data/Auth`
- `Scout/Data/Profiles`
- `Scout/Data/Storage`
- `Scout/Data/Supabase`

The canonical database schema should be documented here or in `backend/supabase/` as it becomes available.

Current planning assumptions:

- `scout-dev` is the active Supabase development project.
- Staging and production projects will be introduced later through approved planning.
- Migrations in the repository should become the authoritative schema history after approval.
- Supabase dashboard edits are for inspection/debugging only, not durable schema changes.
- No schema, migration, RLS, storage, or Edge Function change is approved by this document alone.

## Domain Ownership

Scout's data model should follow domain ownership boundaries. Domains own their own state and expose approved contracts to other domains.

Expected future ownership:

- Profile owns player identity, profile fields, profile readiness, profile privacy, and profile media metadata.
- Discovery owns swipe decisions, recommendation decisions, exclusions, and matches.
- Events owns events, organizer state, event participants, event lifecycle, and participation state.
- Chat owns conversations, conversation membership, and messages.
- Notifications owns notification records, delivery state, and notification preferences after approval.
- Infrastructure owns migration workflow, RLS standards, generated type workflow, environment strategy, and shared Supabase operating conventions.

Domains should not directly mutate another domain's data. Cross-domain features should consume approved contracts such as Profile Summary, Candidate Card, Event Card, Chat Summary, or Notification Summary. If a feature needs data that an existing contract does not provide, it should propose a contract change through an approved implementation tech plan rather than reaching into another domain's underlying tables.

## Core Entity Candidates

The following entities are expected product concepts, not approved schema:

- `users`: authenticated accounts and identity linkage.
- `profiles`: public player profile data.
- `sports`: supported sports such as pickleball.
- `player_sports`: user-specific sport participation and skill data.
- `availability`: user availability windows or preferences.
- `locations`: coarse location, preferred play areas, or venue references.
- `media`: profile photos and other user-owned assets.
- `swipes`: discovery decisions.
- `matches`: mutual interest and relationship state.
- `messages`: future communication between matched users or event participants.
- `events`: games, open play, clinics, or organized activities.
- `event_participants`: RSVP and attendance state.
- `notifications`: in-app or push notification records.

Each entity requires a future schema decision before implementation.

## Data Modeling Principles

- Use stable IDs and foreign keys for relationships.
- Avoid treating display strings as sources of truth when IDs exist.
- Model user-visible state separately from audit or event history where useful.
- Keep privacy and visibility rules explicit.
- Prefer additive migrations for production data.
- Document nullable fields and defaults clearly.

## Relationships to Define

Future plans should document:

- User to profile.
- Profile to sports and skill levels.
- Profile to media.
- User to swipe decisions.
- Swipe decisions to matches.
- Event to organizer.
- Event to participants.
- Event to venue or location.
- Message to match or event context.

## Row Level Security

RLS policies must be documented before implementation. Each table should define:

- Who can read rows.
- Who can insert rows.
- Who can update rows.
- Who can delete rows.
- Whether admin or service role access is required.
- How blocked, deleted, private, or hidden users affect access.

See `docs/database/RLS.md` for the proposed RLS planning checklist.

## Storage

Storage documentation should define:

- Buckets.
- Path conventions.
- Ownership rules.
- Public versus private access.
- Signed URL usage.
- Image resizing or transformation expectations.
- Deletion and cleanup behavior.

Profile media is the first expected storage domain requiring detailed documentation.

Storage bucket creation requires an approved implementation plan. Expected future buckets include profile photos, action photos, event media, and chat attachments.

## Migrations

Future migration workflow should define:

- Where SQL migrations live.
- How migrations are named.
- How local validation works.
- How generated types are updated.
- How rollback or forward-fix decisions are made.
- How seed data is handled.

No migration workflow is approved by this document alone.

See `docs/database/MIGRATIONS.md` for the proposed migration workflow.

## Supabase Operating Model

See `docs/database/SUPABASE.md` for the proposed Supabase project, source-of-truth, local development, secrets, and GitHub integration model.

## Generated Types

Future schema plans should define how Supabase types are generated and consumed by:

- Current iOS code.
- Future web code.
- Future backend or Edge Function code.

Generated files should not be hand-edited. Schema-changing PRs should state whether generated types changed or why not.

## Edge Functions

Edge Functions are not approved yet. Future plans should define ownership, auth, secrets, inputs/outputs, idempotency, observability, and deployment expectations before creating functions.

## Open Database Questions

- What is the canonical v1 profile schema?
- Should sport skill levels be enum-backed, table-backed, or app-defined?
- How precise should user location storage be?
- What visibility rules apply to profiles before and after matching?
- What storage bucket layout should profile media use?
- How will Supabase types be generated for iOS and future web?
