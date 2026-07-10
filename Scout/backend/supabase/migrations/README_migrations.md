# Supabase Migrations

This directory is reserved for approved Supabase SQL migrations.

## Current Boundary

`INFRA-35` creates the migration home only. It does not create a migration or product schema.

Future migration files must be authorized by the implementing Jira story and approved implementation plan. Migration filenames should follow the DB-001 naming convention:

```text
YYYYMMDDHHMMSS_<jira-key>_<short_description>.sql
```

Each migration should include the required Jira, tech plan, purpose, affected area, RLS impact, generated type impact, and rollback header fields documented in `docs/database/MIGRATIONS.md`.
