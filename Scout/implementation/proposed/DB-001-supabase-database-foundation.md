# Implementation Tech Plan: DB-001 Supabase Database Foundation

## Status

Proposed

## Owner

TODO

## Product Domain

INFRA / DATABASE

## Jira Project

INFRA

## Source of Truth

This plan implements the database operating foundation described by existing planning docs. It does not define product schemas.

References:

- `implementation/proposed/INFRA-001-database-foundation.md`
- `docs/database/DATABASE.md`
- `docs/database/SUPABASE.md`
- `docs/database/MIGRATIONS.md`
- `docs/database/RLS.md`
- `tech-plans/approved/ARCH-001-app-architecture.md`

## Problem Statement

Scout needs a reproducible Supabase workflow before production schemas are added. Dashboard edits, ad hoc SQL, and unmanaged generated types would make future agents unsafe. DB-001 creates the repo-owned backend workflow for migrations, local validation, generated types, seed data, environment handling, and deployment promotion.

## Goals

- Establish repo-owned Supabase migration workflow.
- Add local Supabase development and validation commands.
- Define generated type workflow for iOS/backend consumers.
- Define RLS implementation and testing expectations.
- Define seed data boundaries for dev/test only.
- Define environment and secrets strategy for `scout-dev` now, staging/prod later.
- Prepare domain ownership boundaries without creating domain schemas.

## Non-goals

- Profile schema.
- Discovery, Match, Event, Feed, or Chat tables.
- Production seed data.
- Edge Functions.
- Permanent analytics or crash vendor choices.

## Architecture

```text
Supabase project: scout-dev
  <- repo migrations
  <- repo seeds
  -> generated types
  -> iOS repositories
  -> future web/backend services
```

The repository is the source of truth. Supabase Dashboard is for inspection and emergency debugging only. Schema changes must be represented by migrations committed to the repo and linked to Jira plus an approved implementation plan.

## Implementation Sequencing

1. Add `backend/supabase` operational structure without product schema.
2. Add local Supabase workflow docs/scripts or Makefile targets.
3. Add migration naming and validation conventions.
4. Add generated type command and output ownership.
5. Add seed data conventions and environment templates.
6. Add CI placeholder/validation hook for future migrations.

## Repository Ownership

- `backend/supabase/`: Supabase migrations, seed files, generated type workflow, local config, Edge Functions later.
- `docs/database/`: explanatory docs and policy.
- `.github/`: validation hooks only when approved by CI plans.
- iOS app must consume generated or mapped types through repositories, not direct table assumptions.

## Domain Ownership

Future table ownership:

- Profile owns player identity and readiness.
- Discovery owns swipe decisions, exclusions, queues, and matches if approved.
- Events owns events and participants.
- Chat owns conversations and messages.
- Feed owns feed-specific records only.
- Notifications owns notification records and delivery state.

Domains consume each other through approved contracts and must not mutate another domain's source tables directly.

## Backend Ownership

Supabase owns persistence, RLS, storage policies, and database constraints. Privileged logic belongs in Edge Functions or server-owned boundaries only after approval. Client repositories may call Supabase directly only for operations that RLS can safely enforce.

## iOS Responsibilities

- Use repositories, not direct generated database types in SwiftUI.
- Treat generated types as data-layer inputs.
- Surface validation and RLS errors through domain errors.
- Never depend on dashboard-only schema.

## Migration Strategy

- Migration names include Jira key and short purpose.
- One product concern per migration where possible.
- Additive changes preferred.
- Destructive changes require explicit rollback/forward-fix notes.
- Every migration references approved plan and affected domain.

## Generated Type Workflow

- Generated types are refreshed after migrations.
- Generated outputs are committed only if stable and intentionally consumed.
- iOS domain models remain separate from generated Supabase types.
- Type generation command must be documented and runnable locally.

## RLS Strategy

- RLS is enabled for all user data tables.
- Every table needs read/insert/update/delete policy notes.
- Service role behavior must be explicit.
- RLS tests cover owner, participant, unrelated user, blocked/hidden user where applicable, and service role.

## Seed Data Strategy

- Seeds are for local/dev validation only.
- No production-looking private data.
- Seeds must be deterministic and resettable.
- Domain-specific seeds are added with the domain schema plan that owns them.

## Environment Strategy

- `scout-dev` is active now.
- Staging/prod are future environments.
- Secrets live outside git.
- `.env.example` may document required variable names only.
- Client-safe keys and service-role secrets must be separated.

## Validation Strategy

- Local migration apply/reset validation.
- SQL lint/format where practical.
- RLS test matrix for domain migrations.
- Generated type refresh check.
- CI placeholder for migration validation until backend CI is approved.

## Rollout Strategy

1. Land foundation without product tables.
2. Validate local workflow against `scout-dev`.
3. Use DB-001 workflow for Profile schema first.
4. Promote later environments only after staging/prod strategy approval.

## Risks

- Dashboard edits drifting from repo migrations.
- Generated types leaking into SwiftUI.
- RLS policies added after app code instead of before.
- Seed data becoming product assumptions.
- Service-role usage hiding privacy bugs.

## Definition of Done

- Supabase repo structure and workflow exist.
- Migration naming and validation are documented and usable.
- Generated type workflow is documented.
- Seed/environment/RLS expectations are enforceable for future schema PRs.
- No product schema is created by DB-001.

## Jira Breakdown

- Epic: `INFRA-34` - DB-001: Supabase Database Foundation

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `INFRA-35` | DB: Add Supabase repository structure without product schema | 🤖 AI Implementation | 1 | DB-001 |
| 2 | `INFRA-36` | DB: Add local Supabase migration workflow | 🤖 AI Implementation | 1 | `INFRA-35` |
| 3 | `INFRA-37` | DB: Add generated Supabase type workflow | 🤖 AI Implementation | 1 | `INFRA-35`, `INFRA-36` |
| 4 | `INFRA-38` | DB: Add RLS seed and environment conventions | 🤖 AI Implementation | 1 | `INFRA-36` |
| 5 | `INFRA-39` | DB: Add migration validation and deployment checklist | 🤖 AI Implementation | 1 | `INFRA-36`, `INFRA-37`, `INFRA-38` |
