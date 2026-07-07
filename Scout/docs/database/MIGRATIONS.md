# Migration Workflow

## Purpose

This document defines the proposed migration workflow for Scout Supabase changes. It is not active until approved through `implementation/proposed/INFRA-001-database-foundation.md`.

Related documents:

- `docs/database/DATABASE.md`: database planning overview and domain ownership.
- `docs/database/SUPABASE.md`: Supabase operating model.
- `docs/database/RLS.md`: RLS planning expectations.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation plan.
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`: proposed v1 profile field set.
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`: future/proposed profile schema and RLS plan.

## Source of Truth

Approved migrations in the repository should be the source of truth for database structure.

The Supabase dashboard should not be used as the durable source of schema changes.

## Proposed Directory

Future migrations should live under:

```text
backend/supabase/migrations/
```

This directory should be created by an approved implementation ticket before the first migration is written.

Do not create the Supabase folder structure, migration files, generated types, storage buckets, or Edge Functions until the relevant implementation tech plan is approved.

## Naming Convention

Proposed format:

```text
YYYYMMDDHHMMSS_<jira-key>_<short_description>.sql
```

Example:

```text
20260707153000_SOCIAL-101_create_profiles.sql
```

## Migration Header

Each migration should include:

```sql
-- Jira: SOCIAL-101
-- Tech Plan: implementation/approved/PROFILE-003-profile-schema-and-rls.md
-- Purpose: Create approved profile tables and relationships.
```

## Review Requirements

Each migration PR should document:

- Jira ticket.
- Approved implementation plan.
- Affected repo area: `Supabase`.
- RLS impact.
- Generated type impact.
- Seed data impact.
- Validation performed.
- Rollback or forward-fix approach.

## Local Validation

Future workflow should validate database changes against a local Supabase stack before PR review when the approved story requires a migration, seed change, generated type update, or RLS change.

Proposed local workflow:

1. Pull latest `develop`.
2. Review the approved implementation plan and Jira story.
3. Confirm the Supabase CLI is available.
4. Start the local Supabase stack.
5. Create or apply the approved migration.
6. Reset the local database when validating migration ordering, seed data, or RLS behavior.
7. Load seed data if the approved schema plan requires it.
8. Regenerate generated types if the approved type strategy requires it.
9. Run required RLS checks and affected app or repository tests.
10. Stop the local Supabase stack when validation is complete.

Proposed command shape:

```text
supabase start
supabase migration new <jira-key>_<short_description>
supabase db reset
supabase gen types <target> > <approved-generated-type-path>
supabase stop
```

These commands are examples until Scout approves exact CLI usage, project linking, generated type targets, and output paths.

Future database PRs should document:

- Whether local Supabase started successfully.
- Which migrations were applied or reset.
- Whether seed data was loaded or intentionally skipped.
- Whether generated types were updated or intentionally unchanged.
- Which RLS positive and negative checks were performed.
- Which app or repository tests were run.
- Any manual dashboard inspection performed.

Open questions:

- Whether every database PR requires `supabase db reset`.
- Whether local seed data is required for all schema changes or only selected domains.
- Which generated type targets are required for iOS and future web.
- Which RLS checks are required before automated database tests exist.

## Rollback Philosophy

Prefer additive, forward-compatible migrations.

For production later, rollbacks should be planned carefully and may use forward-fix migrations when data safety requires it.

## Approval Boundary

This document does not create or approve any migration.

It also does not approve creating Supabase directories, generated type files, storage buckets, Edge Functions, or CI jobs.
