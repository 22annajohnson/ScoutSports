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

Future workflow should define:

- How to apply migrations locally.
- How to reset local state.
- How to run RLS checks.
- How to regenerate types.
- How to validate seed data.

## Rollback Philosophy

Prefer additive, forward-compatible migrations.

For production later, rollbacks should be planned carefully and may use forward-fix migrations when data safety requires it.

## Approval Boundary

This document does not create or approve any migration.

It also does not approve creating Supabase directories, generated type files, storage buckets, Edge Functions, or CI jobs.
