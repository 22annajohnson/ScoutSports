# Future Validation Placeholders

Scout's v1 CI foundation intentionally validates the current iOS app, documentation, and GitHub configuration only. Supabase and web validation are deferred placeholders until the owning implementation plans approve concrete repository structure, commands, secrets, and required status checks.

## Supabase Pull Request Validation

Status: active local PR validation.

Approval gates:

- `Scout/implementation/proposed/INFRA-004-supabase-development-pipeline.md`
  defines the proposed end-to-end Supabase pipeline.
- `INFRA-62` activates PR-safe local Supabase validation only. Remote
  deployment, staging/prod credentials, preview branches, and Edge Function
  deployment remain deferred until their own approved stories.

Current checks:

- local Supabase CLI prerequisite check
- local Supabase stack start/stop
- migration reset and seed validation
- pgTAP database tests when present
- Swift generated type freshness

Current boundary:

- No Supabase validation check is required in branch protection until the owner
  explicitly configures it.
- The workflow must not deploy to remote Supabase projects.
- The workflow must not create preview branches.
- The workflow must not require production secrets.
- The workflow must not deploy Edge Functions.
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
