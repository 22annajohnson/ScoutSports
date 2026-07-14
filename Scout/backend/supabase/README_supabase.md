# Supabase

This directory is Scout's repo-owned home for approved Supabase backend assets.

DB-001 activates the repository structure without creating product schema. Future schema work should use these locations only when the relevant Jira story and approved implementation plan authorize the change.

## Directories

- `migrations/`: future Supabase SQL migrations.
- `seed/`: future local/dev seed files.
- `types/`: future generated Supabase type outputs.
- `config.toml`: active local Supabase CLI configuration.
- `config/`: environment and setup notes.

## Local Workflow

Use the root `Makefile` for local Supabase workflow commands:

```text
make supabase-doctor
make supabase-start
make supabase-migration-new SUPABASE_MIGRATION_NAME=<jira-key>_<short_description>
make supabase-migration-up
make supabase-db-reset
make supabase-test-db
make supabase-gen-types-swift
make supabase-stop
```

These commands use `backend` as the Supabase CLI workdir by default. The CLI
then reads and writes Supabase assets under `backend/supabase/`.

Do not run Supabase CLI commands with `SUPABASE_WORKDIR=backend/supabase`;
that creates an incorrect nested `backend/supabase/supabase/` project.

## Current Boundary

This structure does not introduce:

- Product tables or schema.
- SQL migrations.
- Row Level Security policies.
- Storage buckets.
- Edge Functions.
- Generated type files.
- Remote project linking.

Do not introduce schema, auth, storage, migration, generated type, or Edge Function changes without an approved technical plan and authorizing Jira story.
