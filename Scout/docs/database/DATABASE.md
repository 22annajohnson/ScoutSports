# Scout Database

## Purpose

This document defines the planning foundation for Scout's Supabase-backed data model. It should guide technical plans and Jira ticket creation, but it is not a live schema reference yet.

Schema, Row Level Security, storage, auth, and migration changes require explicit approval through a technical plan.

## Current State

Scout uses Supabase for authentication, data, and storage. The iOS app currently contains Supabase-facing code under:

- `Scout/Data/Auth`
- `Scout/Data/Profiles`
- `Scout/Data/Storage`
- `Scout/Data/Supabase`

The canonical database schema should be documented here or in `backend/supabase/` as it becomes available.

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

## Migrations

Future migration workflow should define:

- Where SQL migrations live.
- How migrations are named.
- How local validation works.
- How generated types are updated.
- How rollback or forward-fix decisions are made.
- How seed data is handled.

No migration workflow is approved by this document alone.

## Open Database Questions

- What is the canonical v1 profile schema?
- Should sport skill levels be enum-backed, table-backed, or app-defined?
- How precise should user location storage be?
- What visibility rules apply to profiles before and after matching?
- What storage bucket layout should profile media use?
- How will Supabase types be generated for iOS and future web?
