# Supabase Seed Data

This directory is reserved for approved local and development seed data.

## Current Boundary

`INFRA-35` creates the seed home only. It does not create product seed data.

Future seed files must be deterministic, resettable, and limited to local/dev validation unless a later approved plan explicitly expands the scope. Do not commit production-like private data or secrets.

## Seed Conventions

Future seed files must:

- Be authorized by the schema/domain story that owns the data.
- Use clearly fake local/dev data.
- Avoid real names, phone numbers, email addresses, exact home addresses, private messages, access tokens, or production-like media URLs.
- Be deterministic and safe to reset repeatedly.
- Keep each domain's seed data close to the migration or schema plan that owns it.
- Document whether seed loading is required for RLS validation, generated type validation, or app smoke checks.

Future seed files must not:

- Create product schema by themselves.
- Include production data or customer-like private data.
- Encode assumptions that should live in migrations, constraints, or approved domain contracts.
- Require dashboard-only setup to work.
