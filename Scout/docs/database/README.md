# Database Documentation

This directory contains Scout database and Supabase documentation.

Use this area to document entities, relationships, storage paths, Row Level Security policies, data lifecycle rules, and migration guidance.

## Documents

- `DATABASE.md`: database planning foundation and entity candidates.
- `SUPABASE.md`: proposed Supabase operating model.
- `MIGRATIONS.md`: proposed migration workflow.
- `RLS.md`: proposed Row Level Security planning guidance.
- `EDGE_FUNCTIONS.md`: proposed Edge Function planning template.
- `STORAGE.md`: proposed storage bucket planning template.
- `GENERATED_TYPES.md`: proposed generated type workflow.

These documents are planning references. Schema, migration, RLS, storage, auth, and Edge Function changes require approved implementation tech plans before implementation.

## Related Plans

- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation.
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`: proposed v1 profile field set.
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`: proposed profile schema and RLS plan.

Read these documents in order when preparing database work: database overview, Supabase operating model, migration workflow, RLS expectations, storage planning, Edge Function planning, generated type workflow, approved/proposed implementation plan, then Jira ticket.
