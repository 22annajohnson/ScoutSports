# Supabase Operating Model

## Purpose

This document describes how Scout plans to manage Supabase as the backend platform. It is planning guidance only until the relevant implementation tech plans are approved.

Related documents:

- `docs/database/DATABASE.md`: database planning overview and domain ownership.
- `docs/database/MIGRATIONS.md`: proposed migration workflow.
- `docs/database/RLS.md`: RLS planning expectations.
- `docs/database/SECRETS_AND_GITHUB.md`: proposed secrets and GitHub integration guidance.
- `docs/database/EDGE_FUNCTIONS.md`: proposed Edge Function planning template.
- `docs/database/STORAGE.md`: proposed storage bucket planning template.
- `docs/database/GENERATED_TYPES.md`: proposed generated type workflow.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed Supabase foundation plan.
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`: proposed v1 profile field set.
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`: future/proposed profile schema and RLS plan.

## Current Project Strategy

- `Scout Sports V1.3` on Supabase `main` is the current temporary development database.
- Supabase branching is not available on the current Supabase plan, so Scout will not use database branches for v1 development.
- The current project has no production users; applying approved development migrations to `Scout Sports V1.3/main` is acceptable until a separate production project exists.
- A separate production Supabase project is expected later before real users are onboarded.
- Staging and production projects are expected later.
- Introducing staging/prod requires explicit approval and may require an ADR if it changes CI, auth, deployment, or database ownership.

Agents should not block current implementation work waiting for a `scout-dev` project or Supabase branching. When older docs or plans say `scout-dev`, read that as the current approved development target: `Scout Sports V1.3/main`, unless a newer approved plan creates a separate development or production project.

## Source of Truth

Once migrations are approved, repository migrations are the authoritative source of truth.

Dashboard edits are allowed for:

- Inspection.
- Debugging.
- Temporary exploration.

Dashboard edits are not allowed as durable schema changes unless converted into an approved migration.

The live Supabase database is an execution target for approved changes, not the canonical source of schema truth.

## Repository Areas

Expected future Supabase assets:

- `backend/supabase/migrations/`
- `backend/supabase/functions/`
- `backend/supabase/seed/`
- `backend/supabase/types/`
- `docs/database/`

These folders are active only for approved Supabase implementation stories. Do
not add new classes of Supabase assets outside the authorizing story scope.

Do not create migrations, storage buckets, Edge Functions, remote links, secrets,
or new generated type outputs until the relevant implementation tech plan and
Jira story approve that work. Planning documents may reference expected future
paths, but those paths are not implementation approval.

## Local Development

The local development command surface is active through the root `Makefile`.
Use `SUPABASE_WORKDIR=backend`; Supabase project files live under
`backend/supabase/`.

Current local workflow coverage:

- Supabase CLI start/stop usage.
- Local database reset behavior.
- Migration apply validation.
- Seed data loading when required by the schema plan.
- Generated type commands after schema changes.
- RLS positive and negative checks.
- Required environment variables.
- Validation notes in the PR description.

This document does not approve installing Supabase CLI in CI, linking a remote
project, creating new migrations, creating seed data, or committing additional
generated type outputs.

See `docs/database/GENERATED_TYPES.md` for proposed generated type options, command shapes, and schema PR requirements.

## Environment and Secrets

Secrets must never be committed.

Future plans should document:

- Supabase project refs.
- Anon key usage.
- Service role key handling.
- Local `.env` expectations.
- CI secret names.
- Rotation and revocation expectations.

See `docs/database/SECRETS_AND_GITHUB.md` for proposed local environment categories, CI secret categories, GitHub integration expectations, and ADR triggers.

## GitHub Integration

Expected future behavior:

- Database changes flow through pull requests.
- PRs reference Jira tickets and approved implementation plans.
- CI validates migrations and generated types when the strategy is approved.
- Staging/prod promotion is introduced only after environment strategy approval.

## Approval Boundary

This document does not approve:

- Schema changes.
- Migrations.
- Storage buckets.
- Edge Functions.
- CI jobs.
- Secrets changes.
- Auth strategy changes.

Before Scout creates the first migration or activates Supabase implementation directories, approval must be captured for:

- The migration directory and naming convention.
- Local validation and reset workflow.
- RLS documentation and verification expectations.
- Generated type ownership and check-in rules.
- Environment variable and secret naming conventions.
- The schema-specific implementation plan and Jira story that authorize the migration.
- Any required ADRs for database architecture, auth strategy, backend ownership, shared packages, or CI strategy.
