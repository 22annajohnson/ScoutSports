# Supabase Environment Guidance

This document lists Scout Supabase environment variable names without values.

Do not commit real secrets, tokens, service role keys, direct database URLs, or project-specific private values.

| Variable | Required For | Secret? | Owner |
| --- | --- | --- | --- |
| `SUPABASE_PROJECT_REF` | Remote project linking or remote type generation. | No | Backend/database owner. |
| `SUPABASE_URL` | Client/API configuration. | No | App/environment owner. |
| `SUPABASE_ANON_KEY` | Client authenticated flows. | No, but environment-specific | App/environment owner. |
| `SUPABASE_SERVICE_ROLE_KEY` | Server-side or CI-only privileged operations. | Yes | Owner-controlled only. |
| `SUPABASE_DB_URL` | Direct database tooling. | Yes | Backend/database owner. |
| `SUPABASE_ACCESS_TOKEN` | Supabase CLI automation. | Yes | Owner/CI admin. |

Local `.env` files may use these names when an approved workflow requires them. `.env` files with values must remain untracked.
