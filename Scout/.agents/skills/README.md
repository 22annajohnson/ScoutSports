# Scout Agent Skills

## Purpose

This directory contains repo-local agent skills for Scout. `Scout/.agents/skills/` is the intended path because Codex discovers skills from this workspace location and makes them available to future agents working in the repository.

These files are agent guidance only. They are not production code, app configuration, Supabase configuration, migrations, schemas, secrets, or runtime dependencies.

## Included Skills

| Skill | Required? | Purpose |
| --- | --- | --- |
| `supabase` | Required for Supabase work | Core Supabase workflow guidance for database, auth, RLS, storage, Edge Functions, CLI, MCP, and security-sensitive tasks. |
| `supabase-postgres-best-practices` | Reference-only | Curated Postgres guidance for schema design, RLS/security, privileges, and index planning. |

Future agents should read these skills when a task touches Supabase, Postgres schema design, migrations, RLS, storage policy planning, generated types, or Edge Function planning.

## Source And Attribution

The skills were installed from the upstream Supabase agent-skills repository:

- Source: https://github.com/supabase/agent-skills
- Supabase AI skills docs: https://supabase.com/docs/guides/getting-started/ai-skills
- License: MIT, compatible with Scout repo vendoring.

The upstream repository identifies the project as MIT licensed. A copy of the upstream license notice is included at `Scout/.agents/skills/LICENSE.supabase-agent-skills.md`.

## Version And Hashes

`Scout/skills-lock.json` records the installed source and hashes captured at install time:

| Skill | Upstream source | Version in skill metadata | Captured hash |
| --- | --- | --- | --- |
| `supabase` | `supabase/agent-skills` | `0.1.2` | `d414d598b9428b3e851c4ce61898649906b19e55aa7415bb42a286bd9ca2ab32` |
| `supabase-postgres-best-practices` | `supabase/agent-skills` | `1.1.1` | `0d2c4857a7d6fdcd3fbc46e458fa4c497f029cab89a01548b3defce203003932` |

This PR vendors a curated subset rather than the full upstream bundle. The lockfile remains useful for source traceability, but the local reference set is intentionally smaller than the upstream install.

## Curated Scope

Required:

- `supabase/SKILL.md`
- `supabase-postgres-best-practices/SKILL.md`

Reference-only, kept because Scout is entering database planning:

- Postgres schema design references.
- RLS and privilege references.
- Index-planning references likely to affect migration reviews.
- Supabase skill feedback reference linked by the upstream skill.

Intentionally excluded for now:

- Advanced full-text search and JSONB optimization.
- Connection pooling and connection-limit tuning.
- Data access pattern references such as pagination, batch inserts, and upsert.
- Locking and advisory-lock references.
- Monitoring and vacuum references.
- Upstream changelog files and contribution templates.

Those excluded references can be restored later from upstream if Scout begins work that needs them.

## Update Process

1. Reinstall from upstream in a throwaway branch with `npx skills add supabase/agent-skills`.
2. Review the upstream diff and license before committing.
3. Keep the bundle curated unless there is a clear near-term Scout need for additional references.
4. Update `skills-lock.json` when reinstalling or changing installed skill versions.
5. Update this README with any added or removed reference categories.
6. Keep the PR docs/config-only. Do not include schema, migrations, Supabase folders, app code, or secrets.

## Removal Process

If Scout no longer wants vendored agent skills, remove `Scout/.agents/skills/` and `Scout/skills-lock.json` in a dedicated docs/tooling PR. Future agents can still install the skills locally from upstream when needed.
