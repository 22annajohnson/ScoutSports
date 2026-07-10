# Supabase

This directory is Scout's repo-owned home for approved Supabase backend assets.

DB-001 activates the repository structure without creating product schema. Future schema work should use these locations only when the relevant Jira story and approved implementation plan authorize the change.

## Directories

- `migrations/`: future Supabase SQL migrations.
- `seed/`: future local/dev seed files.
- `types/`: future generated Supabase type outputs.
- `config/`: local configuration placeholders and setup notes.

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
