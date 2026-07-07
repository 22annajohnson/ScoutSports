# Implementation Tech Plan: Supabase Database Foundation

## Status

Proposed

## Owner

TODO

## Product Domain

INFRA

## Related Foundation Documents

- `tech-plans/approved/ARCH-001-app-architecture.md`
- `docs/database/DATABASE.md`
- `docs/database/SUPABASE.md`
- `docs/database/MIGRATIONS.md`
- `docs/database/RLS.md`
- `docs/database/GENERATED_TYPES.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`

## Problem Statement

Scout uses Supabase for authentication, data, and storage, but the repository does not yet define an approved operating model for schema ownership, migrations, local development, RLS, generated types, storage buckets, Edge Functions, seed data, secrets, or GitHub integration.

Before Scout creates its first repo-owned migration, the team needs a database foundation plan that makes Supabase changes reviewable, reversible, and safe for AI-assisted development.

## Goals

- Define the Supabase project strategy for v1.
- Establish repository migrations as the source of truth.
- Define local development and migration workflows.
- Define migration naming, approval, and traceability rules.
- Define RLS, generated type, storage, Edge Function, seed data, and secrets planning expectations.
- Document what must be approved before the first migration is created.

## Non-goals

- Creating Supabase tables.
- Writing SQL migrations.
- Changing existing iOS Supabase code.
- Creating storage buckets.
- Writing Edge Functions.
- Choosing the final profile schema.
- Defining production deployment automation.

## Current Approved State

- `scout-dev` is the active Supabase project for current development planning.
- Staging and production Supabase projects are expected later, but are not configured by this plan.
- `backend/supabase/` is documentation and planning only for now.
- No repository-owned migration workflow is approved until this plan is approved.
- Dashboard edits may be used only for inspection/debugging unless a future approved emergency process says otherwise.

## INFRA-2 Operating Model Review

Jira story: `INFRA-2` (`Infra: Approve Supabase operating model`).

This review captures the operating model decisions needed before any database implementation begins. The plan remains `Proposed` until the product owner explicitly approves moving it forward.

### Approved for Planning

- `scout-dev` is the current Supabase project for development planning, inspection, and future approved development migrations.
- Staging and production Supabase projects are deferred until a later approved plan defines environment ownership, auth/deployment expectations, promotion flow, and any required ADRs.
- Repository migrations are the future source of truth once the first migration workflow is approved.
- Supabase dashboard edits are limited to inspection, debugging, and temporary exploration. They are not durable schema changes unless converted into an approved repository migration.
- No Supabase folders, migrations, generated types, storage buckets, Edge Functions, CI jobs, schema changes, RLS policies, or production code are authorized by this plan while it remains proposed.

### Revised or Clarified

- `backend/supabase/` remains a reserved documentation and planning area until an approved implementation ticket activates specific subdirectories.
- The live Supabase database is an execution target for approved changes, not the canonical source of schema truth.
- Generated type strategy, local Supabase workflow, seed data, and CI validation remain planning topics until their follow-up INFRA stories are approved.

### Deferred Decisions

- Exact staging and production project creation timing.
- Whether Supabase branching is used.
- Whether every database PR must use the Supabase CLI local stack.
- Which generated types are checked in for iOS, future web, or both.
- Which CI jobs validate migrations, generated types, seed data, and RLS checks.
- Any emergency process for manual dashboard changes.

## Supabase Project Strategy

### v1 Project

`scout-dev` is the only active project considered by this plan.

Expected use:

- Validate database planning assumptions.
- Inspect current auth/data/storage behavior.
- Support future approved development migrations.
- Avoid production-like guarantees until staging/prod strategy is approved.

### Future Projects

Future environments should be introduced intentionally:

- `scout-staging`: pre-production validation and release testing.
- `scout-prod`: production data and production auth/storage.

Adding staging or production requires an approved implementation plan or ADR if it changes CI, deployment, auth, database ownership, or environment strategy.

## Source of Truth

Repo-owned migrations are the authoritative database history once the first migration is approved.

Rules:

- Migrations committed in the repo define canonical schema changes.
- Supabase dashboard edits are for inspection/debugging only.
- Any manual dashboard experiment must either be discarded or converted into an approved migration before becoming durable.
- The live database should be considered an execution target, not the source of truth.
- Schema documentation should summarize intent, but migrations define actual applied changes.

## Local Development Workflow

Proposed workflow:

1. Pull latest `develop`.
2. Review the approved implementation tech plan and Jira ticket.
3. Confirm Supabase CLI is installed and the local environment is configured.
4. Start local Supabase with the approved project configuration.
5. Create a migration from the approved Jira ticket.
6. Apply migrations to the local database.
7. Load seed data if the schema plan requires it.
8. Regenerate types if required.
9. Run local validation, RLS checks, and affected app tests.
10. Reset the local database and reapply migrations when the change depends on ordering or seed behavior.
11. Open PR with migration, docs, generated type updates, and validation notes.

Proposed command shape:

```text
supabase start
supabase migration new <jira-key>_<short_description>
supabase db reset
supabase gen types <target> > <approved-generated-type-path>
supabase stop
```

These commands are planning guidance only. Exact flags, project linking, generated type targets, and output paths must be approved before the first migration.

Future database PRs should include validation notes for:

- Local Supabase start/reset status.
- Migration apply/reset result.
- Seed data loaded or intentionally skipped.
- Generated types updated or intentionally unchanged.
- RLS positive and negative checks performed.
- App or repository tests run.
- Any manual dashboard inspection performed.

Open questions:

- Whether Scout will require Supabase CLI local stack for every database PR.
- Whether local seed data should be required for all schema changes.
- Whether generated types should be checked in for iOS, web, or both.
- Whether `supabase db reset` is required for every database PR or only schema/seed ordering changes.
- Which local RLS checks become required before CI coverage exists.

## Migration Naming Conventions

Migration names should be traceable and reviewable.

Proposed format:

```text
YYYYMMDDHHMMSS_<jira-key>_<short_description>.sql
```

Examples:

```text
20260707153000_INFRA-101_create_profile_tables.sql
20260707154500_SOCIAL-204_add_profile_visibility_fields.sql
```

Rules:

- Use UTC timestamps if generated by tooling.
- Include exactly one Jira key.
- Use the Jira key for the implementation story that authorizes the migration, not only the parent epic.
- Use lowercase snake case.
- Keep descriptions short and outcome-oriented.
- One migration should represent one coherent schema change.
- Do not combine unrelated tables, RLS policies, storage metadata, and seed changes in one migration unless the coupling is explicitly approved.
- Do not rename a migration after it has been reviewed or applied anywhere outside a local throwaway database.

## Jira and Tech Plan References

Every migration PR must reference:

- Jira ticket.
- Approved implementation tech plan.
- Affected repo area: `Supabase`.
- Related ADR, if applicable.
- Local validation performed.
- RLS policy impact.
- Generated type impact.
- Rollback or forward-fix strategy.

Migration SQL should include a short header comment:

```sql
-- Jira: INFRA-101
-- Tech Plan: implementation/approved/INFRA-001-database-foundation.md
-- Purpose: Create approved v1 profile foundation tables.
-- Affected Area: Supabase
-- RLS Impact: Adds policies for user-owned profile rows.
-- Generated Types: Updated after local migration reset.
-- Rollback: Forward-fix with a follow-up migration unless review identifies a safe local-only reset.
```

Required migration header fields:

- `Jira`: authorizing implementation story key.
- `Tech Plan`: approved implementation plan path.
- `Purpose`: one-sentence outcome.
- `Affected Area`: `Supabase`.
- `RLS Impact`: `None`, `Adds policies`, `Changes policies`, or `Requires follow-up`, with a short note.
- `Generated Types`: `Updated`, `Not changed`, or `Deferred`, with a short note.
- `Rollback`: expected forward-fix or rollback approach.

Future migration PRs should confirm that the filename, migration header, PR description, and Jira story all reference the same implementation story and approved plan.

## RLS Philosophy

RLS is a first-class product and security boundary.

Principles:

- Every user-owned or user-visible table must have RLS considered before implementation.
- Privacy rules override convenience.
- Policies should be written around ownership, visibility, relationship context, and blocked/hidden states.
- Service role access should be explicit and limited.
- Public reads should be rare and justified.
- RLS policy changes require tests or manual verification notes.
- No table should be considered complete without documented read/insert/update/delete behavior.

## Generated Type Strategy

Generated types should help iOS, future web, and AI agents avoid schema drift.

Proposed principles:

- Generate types after migrations are applied to the expected target.
- Do not generate or commit type files until the owning platform strategy is approved.
- Check generated types into the repo only after the owning platform output path and review pattern are approved.
- Avoid hand-editing generated files.
- Type generation commands should be documented before first use.
- Schema-changing PRs must state whether generated types were updated, not changed, or deferred.
- Local generation may be used for validation when approved, even if generated files are not committed.

Proposed command shape:

```text
supabase gen types typescript --local > <approved-web-type-path>
supabase gen types swift --local > <approved-ios-type-path>
supabase gen types typescript --project-id <project-ref> > <approved-web-type-path>
```

Schema-changing PRs should include:

- Target platform: iOS, web, Edge Functions, or not applicable.
- Generation target: local database, `scout-dev`, or another approved project.
- Command used, if generation ran.
- Output path, if files were committed.
- Reason for deferral, if files were not committed.

Open decision:

- Whether v1 commits generated types for iOS only, web only, both, or neither until monorepo migration is complete.
- Which generated type commands and output paths Scout standardizes.
- Whether CI validates generated type freshness after the first schema migration.

See `docs/database/GENERATED_TYPES.md` for proposed generated type options, tradeoffs, PR notes, and approval boundaries.

## Storage Bucket Planning

Storage buckets require explicit planning before creation.

Expected future buckets:

- Profile photos.
- Action photos.
- Event media, future.
- Chat attachments, future.

Each bucket plan must define:

- Bucket name.
- Product use case and owning domain.
- Public/private access.
- Path convention.
- Owner and access rules.
- Signed URL behavior.
- Image transformation/resizing expectations.
- Retention and deletion behavior.
- Abuse/moderation considerations.

No storage bucket is approved by this plan.

See `docs/database/STORAGE.md` for the proposed storage bucket planning template.

## Edge Function Planning

Edge Functions should be introduced only when client-side or database-only behavior is insufficient.

Potential future uses:

- Server-owned recommendation scoring.
- Notification fanout.
- Media processing.
- Trust and safety workflows.
- Webhook handling.

Each Edge Function plan must define:

- Owning domain.
- Inputs and outputs.
- Auth requirements.
- Secrets used.
- Observability expectations.
- Retry/idempotency behavior.
- Local testing strategy.
- Deployment path.

No Edge Function is approved by this plan.

## Seed Data Strategy

Seed data should support local development and review without creating production assumptions.

Seed data should be:

- Non-sensitive.
- Deterministic where possible.
- Small enough to understand.
- Explicit about fake users, fake locations, and fake events.
- Safe to reset.

Seed data must not:

- Include real user data.
- Include production secrets.
- Imply approved production schema before migration approval.

## Environment Variables and Secrets

Secrets must never be committed.

Required documentation before implementation:

- Expected local `.env` variables.
- Required Supabase project refs.
- Public anon key usage.
- Service role key handling.
- Database URL or connection string handling, if required.
- Supabase access token handling, if required for CI.
- CI secret names.
- Rotation expectations.
- Which apps consume each value.

Any change to auth strategy, secret ownership, or CI secret propagation requires approval and may require an ADR.

See `docs/database/SECRETS_AND_GITHUB.md` for proposed secret categories, GitHub integration expectations, and ADR triggers.

## GitHub and Supabase Integration Expectations

Expected future integration:

- PRs validate migration formatting and local application where feasible.
- CI checks generated types when the strategy is approved.
- Deployment to staging/prod is gated after environment strategy is approved.
- Supabase project changes are reviewed through GitHub PRs rather than dashboard-only edits.

Open decisions:

- Which CI jobs run for database PRs.
- Whether migration application is automatic or manual.
- How staging/prod promotion is handled.
- Whether Supabase branching is used.

## Approval Required Before First Migration

Before the first migration is created, Scout must approve:

- Supabase source-of-truth workflow.
- Migration directory and naming convention.
- Local validation workflow.
- RLS documentation template.
- Generated type strategy.
- Environment variable and secret naming convention.
- Initial implementation tech plan for the specific schema change.
- Any required ADRs for database architecture, auth strategy, backend ownership, shared packages, or CI strategy.

Approval must be visible in the relevant Jira story and implementation plan before a PR creates the first migration or activates Supabase implementation directories.

## Risks

- Dashboard edits can drift from repo history if not controlled.
- Generated types can become stale if not part of validation.
- RLS gaps can expose private data across Profile, Discovery, Events, Chat, and Notifications.
- Premature storage or Edge Function decisions can create long-term coupling.
- Local development without seed data can make AI-agent validation shallow.

## Testing Strategy

This proposed plan requires documentation review only.

Future implementation plans should define:

- Local migration apply/reset validation.
- RLS policy tests or manual verification scripts.
- Generated type checks.
- Storage access checks.
- Edge Function tests if functions are introduced.

## Rollout Plan

1. Review and approve this proposed plan.
2. Update database docs to match approved decisions.
3. Create Jira tickets for database foundation implementation readiness.
4. Draft the first schema-specific implementation plan.
5. Create the first migration only after approval.

## Definition of Done

- Proposed plan is reviewed.
- Approval decisions are captured.
- Follow-up Jira tickets are created only after approval.
- No schema, migration, storage bucket, Edge Function, or production code change is introduced by this plan.

## Suggested Jira Epics and Stories

Do not create these until this plan is approved.

Epic:

- `INFRA: Supabase Database Foundation`

Stories:

- `Infra: Document Supabase source-of-truth workflow`
- `Infra: Define migration directory and naming convention`
- `Infra: Create RLS documentation template`
- `Infra: Define generated type workflow`
- `Infra: Document local Supabase development workflow`
- `Infra: Define storage bucket planning template`
- `Infra: Define Edge Function planning template`
- `Infra: Document Supabase secrets and environment variables`
