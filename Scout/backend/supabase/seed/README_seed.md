# Supabase Seed Data

This directory is reserved for approved local and development seed data.

## Current Boundary

`INFRA-59` activates the root Supabase seed entrypoint at
`backend/supabase/seed.sql`. The file is intentionally data-free so local
`supabase db reset` validation can prove the configured seed path loads without
introducing product data.

Future seed files must be deterministic, resettable, and limited to local/dev validation unless a later approved plan explicitly expands the scope. Do not commit production-like private data or secrets.

## Validation

Use the repository Makefile from the repo root:

```text
make supabase-validate-reset-seed
```

The target runs `supabase db reset --workdir backend`. Supabase applies all
repo-owned migrations and then loads the configured seed entrypoint from
`backend/supabase/seed.sql`.

For future domain seed files:

- Keep `backend/supabase/seed.sql` as the configured root entrypoint.
- Add deterministic local/dev fixture SQL only when the owning schema story
  authorizes it.
- Document the validation purpose in this directory or the owning domain plan.
- Confirm whether the seed is required for RLS validation, generated type
  validation, repository tests, or app smoke checks.

## Seed Conventions

Future seed files must:

- Be authorized by the schema/domain story that owns the data.
- Use clearly fake local/dev data.
- Avoid real names, phone numbers, email addresses, exact home addresses, private messages, access tokens, or production-like media URLs.
- Be deterministic and safe to reset repeatedly.
- Keep each domain's seed data close to the migration or schema plan that owns it.
- Document whether seed loading is required for RLS validation, generated type validation, or app smoke checks.
- Be reachable from the configured root seed entrypoint when it must load during
  `supabase db reset`.

Future seed files must not:

- Create product schema by themselves.
- Include production data or customer-like private data.
- Encode assumptions that should live in migrations, constraints, or approved domain contracts.
- Require dashboard-only setup to work.
