# Supabase Local Config

This directory is reserved for local Supabase configuration placeholders and setup notes.

## Current Boundary

`INFRA-58` activates the local Supabase CLI configuration at
`backend/supabase/config.toml`. It does not link this repository to a remote
Supabase project, add secrets, create migrations, or create product schema.

Future config work may document variable names, local setup, and project-linking
expectations after the relevant Jira story approves that workflow. Do not commit
secret values.

Run `make supabase-doctor` from the repository root to check local CLI prerequisites before starting migration work.

## Environment Variable Names

Use documentation or example files with variable names only. Do not commit real values.

| Variable | Purpose | Secret? | Notes |
| --- | --- | --- | --- |
| `SUPABASE_PROJECT_REF` | Identifies the target project, currently `Scout Sports V1.3/main` until a separate production project exists. | No | Required only when an approved workflow links to a remote project. |
| `SUPABASE_URL` | Supabase API URL for a specific environment. | No | Environment-specific client configuration. |
| `SUPABASE_ANON_KEY` | Client-safe anon key for authenticated user flows. | No, but environment-specific | Keep separate from service role usage. |
| `SUPABASE_SERVICE_ROLE_KEY` | Admin/server-side Supabase access. | Yes | Never use in client apps or commit. |
| `SUPABASE_DB_URL` | Direct database connection for local/CI tooling. | Yes | Tooling only; not app configuration. |
| `SUPABASE_ACCESS_TOKEN` | Supabase CLI automation token. | Yes | Owner/CI controlled only. |
