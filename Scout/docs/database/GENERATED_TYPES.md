# Generated Type Workflow

## Purpose

This document defines Scout's Supabase generated type workflow. DB-001 activates command and ownership guidance, but generated output files are committed only when an approved schema or platform story authorizes them.

Related documents:

- `docs/database/DATABASE.md`: database planning overview and domain ownership.
- `docs/database/SUPABASE.md`: Supabase operating model.
- `docs/database/MIGRATIONS.md`: proposed migration workflow.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation plan.
- `implementation/proposed/DB-001-supabase-database-foundation.md`: Supabase database foundation plan.

## Current Strategy

Generated Supabase types are not checked in yet.

Current decision:

- Do not generate or commit type files until the owning platform strategy is approved.
- iOS type output should be approved before any Swift-facing generated file is added.
- Future web type output should be approved when the web app is part of the repository strategy.
- Schema-changing PRs must state whether generated types were updated, not changed, or deferred.

This keeps the first schema migrations from silently creating platform contracts before Scout decides where generated files live and how they are reviewed.

## Options Considered

| Option | Tradeoff | Current Position |
| --- | --- | --- |
| Check in iOS generated types now | Reduces iOS schema drift earlier, but requires an approved Swift output path and review pattern. | Deferred until iOS generated type ownership is approved. |
| Check in future web generated types now | Prepares web contracts, but web is not yet in the active monorepo implementation path. | Deferred until web repo/app strategy is approved. |
| Check in both iOS and web generated types | Gives broad contract coverage, but creates churn and ownership questions before platform paths are approved. | Deferred. |
| Generate locally but do not commit | Useful for validation, but does not create durable client contracts. | Allowed as validation guidance when a schema story asks for it. |
| Defer all generated type work | Keeps repo clean, but increases schema drift risk if schema changes begin without a follow-up plan. | Acceptable only until the first schema-specific implementation plan decides type ownership. |

## Command Shape

Exact output paths and generation targets must be confirmed by the authorizing schema or platform story before generated files are committed.

Use the Supabase CLI `gen types` command with an explicit language, target, schema, and output path.

```text
supabase gen types --local --lang swift --schema public > backend/supabase/types/swift/Database.generated.swift
supabase gen types --local --lang typescript --schema public > backend/supabase/types/typescript/database.generated.ts
supabase gen types --project-id <project-ref> --lang typescript --schema public > backend/supabase/types/typescript/database.generated.ts
```

The local target is preferred for migration PR validation when local Supabase workflow is approved. Remote project generation should be used only when the approved plan says the remote project is the expected target for that validation.

## Output Ownership

Reserved output locations:

| Platform | Reserved Path | Current Status |
| --- | --- | --- |
| iOS / Swift data layer | `backend/supabase/types/swift/Database.generated.swift` | Reserved; do not commit generated output until Swift generated type ownership is approved. |
| Future web / TypeScript data layer | `backend/supabase/types/typescript/database.generated.ts` | Reserved; do not commit generated output until web generated type ownership is approved. |

Generated types are data-layer artifacts. SwiftUI views, domain models, and feature view models should not consume generated database types directly. Repository and mapping layers own translation from generated rows to approved domain contracts.

## Schema PR Requirements

Every schema-changing PR should include a generated type note:

- `Generated Types: Updated` when approved generated files were regenerated and committed.
- `Generated Types: Not changed` when the schema change does not affect generated output.
- `Generated Types: Deferred` when type generation is not approved yet or the owning platform path is not available.

The note should identify:

- Target platform: iOS, web, Edge Functions, or not applicable.
- Generation target: local database, `scout-dev`, or another approved project.
- Command used, if generation ran.
- Output path, if files were committed.
- Reason for deferral, if files were not committed.

## Review Expectations

Generated type files, once approved, should be treated as generated artifacts:

- Do not hand-edit generated files.
- Regenerate after applying the migration to the approved target.
- Keep generated type changes in the same PR as the schema change unless the approved plan says otherwise.
- Include generated type impact in migration headers and PR descriptions.
- Avoid committing generated output for platforms whose ownership or path is not approved.

## Open Decisions

- Whether iOS generated types are checked into the current root iOS app before any future app move.
- Whether future web generated types wait for web monorepo planning.
- Whether Edge Function types are generated separately from client types.
- Which generated type commands and output paths Scout standardizes.
- Whether CI validates generated type freshness after the first schema migration.

## Approval Boundary

This document does not approve generating type files, committing generated files, changing Swift models, changing web code, creating Supabase directories, or adding CI jobs.
