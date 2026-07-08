# Future Validation Placeholders

Scout's v1 CI foundation intentionally validates the current iOS app, documentation, and GitHub configuration only. Supabase and web validation are deferred placeholders until the owning implementation plans approve concrete repository structure, commands, secrets, and required status checks.

## Future Supabase Migration Validation

Status: deferred placeholder.

Approval gates:

- `Scout/implementation/proposed/INFRA-001-database-foundation.md` must be approved or superseded by an approved database foundation plan.
- A schema-specific implementation story must approve the migration directory, local Supabase workflow, generated type strategy, seed data expectations, and RLS validation approach.
- Any CI secret names or Supabase project linking must be owner-approved before being referenced by workflows.

Possible future checks:

- migration filename and header validation
- local migration apply/reset
- RLS positive and negative checks
- generated type drift checks
- seed data validation
- Edge Function tests, only if Edge Functions are introduced by an approved plan

Current boundary:

- No Supabase migration workflow exists.
- No Supabase validation check is required in branch protection.
- No `backend/supabase/` implementation directories, migrations, generated types, storage buckets, or Edge Functions are created by the CI foundation.
- Real Supabase secrets must not be exposed to ordinary pull request workflows.

## Future Web Validation

Status: deferred placeholder.

Approval gates:

- The web app must be migrated into this repository or an approved web implementation plan must define the repository location.
- The plan must approve package manager commands, lockfile policy, lint/typecheck/test/build expectations, cache behavior, and any required environment variables.

Possible future checks:

- dependency install
- typecheck
- lint
- unit tests
- production build

Current boundary:

- No web validation workflow exists.
- No web validation check is required in branch protection.
- No `apps/web/` implementation directory or web package manager setup is created by the CI foundation.

## Required Check Policy

Do not add `Supabase Migration Validation`, `Web Validation`, or related required checks to branch protection until the corresponding workflow exists and the owning implementation plan is approved. Future placeholder names should remain documentation only until then.
