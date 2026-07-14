# Supabase Secrets and GitHub Integration

## Purpose

This document defines Scout's proposed Supabase secret categories and GitHub integration expectations. It is planning guidance only until the relevant implementation tech plans are approved.

Related documents:

- `docs/database/SUPABASE.md`: Supabase operating model.
- `docs/database/MIGRATIONS.md`: proposed migration workflow.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation plan.
- `tech-plans/approved/ARCH-001-app-architecture.md`: architecture authority and ADR requirements.

## Secret Handling Rules

- Never commit secret values.
- Prefer local `.env` files for developer-only values.
- Keep public anon keys separate from service role keys.
- Treat service role keys as server/CI-only secrets.
- Document secret categories and owners before configuring CI.
- Rotate secrets through owner action, not through implementation PRs.

## Proposed Local Environment Categories

Future local setup documentation should define values by category, not by committing real values:

| Category | Purpose | Notes |
| --- | --- | --- |
| Supabase project ref | Identifies the target project, currently `Scout Sports V1.3/main` until a separate production project exists. | Required only when a workflow links to a remote project. |
| Supabase URL | Client/API base URL. | Public client configuration, but still environment-specific. |
| Supabase anon key | Client-safe key for authenticated user flows. | Public in app configuration, but should be environment-specific. |
| Supabase service role key | Admin/server-side access. | Never use in client apps or commit to the repo. |
| Database URL | Direct database access for tooling. | CI or local-only; avoid app usage. |
| Access token | Supabase CLI automation token. | CI/owner-controlled only. |

## Proposed CI Secret Categories

Exact GitHub secret names are not approved yet. Future CI/database integration plans should define names for:

- Supabase access token.
- Development project ref.
- Staging project ref, later.
- Production project ref, later.
- Database URL or connection string, if required.
- Service role key, only if a server-side or CI workflow explicitly needs it.

CI secrets should be scoped to the minimum environment and workflow that needs them.

## GitHub Integration Expectations

Future GitHub/Supabase integration should remain proposed until approved:

- PRs may validate migration formatting and local application after the migration workflow is approved.
- CI may validate generated type freshness after generated type ownership is approved.
- Staging/prod deployment should wait for environment strategy approval.
- Supabase project changes should be reviewed through PRs rather than dashboard-only edits.
- Required checks and branch protection changes require owner approval and may belong to a CI/CD plan.

## Protected Environment Expectations

Production deployment must remain unavailable until the owner creates and approves a protected GitHub environment for it.

That environment should require:

- Manual owner approval before any production database deployment job can access production secrets.
- Environment-scoped Supabase access token and production project ref secrets.
- No service role key exposure unless a future approved workflow proves it is required.
- A required staging/integration success signal before production deployment.
- Audit-friendly deployment notes that identify the approver, migration identifiers, target, and verification steps.

Development or staging deployment secrets must not be reused for production. PR-only validation should continue to avoid remote production credentials.

## ADR Triggers

Create or update an ADR before implementation when a change affects:

- Auth strategy.
- CI strategy or required checks.
- Environment ownership.
- Production deployment or promotion flow.
- Service role usage outside owner-controlled tooling.
- Backend ownership between Supabase, Edge Functions, or another service.

## Approval Boundary

This document does not approve creating or rotating secrets, creating CI jobs, changing GitHub repository settings, applying migrations automatically, changing auth strategy, or configuring Supabase project links.
