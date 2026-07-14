# Implementation Plan: Web Monorepo Migration

## Status

Proposed

## Owner

TODO

## Product Domain

ARCH

## Planning Level

Level 1: Architecture Foundation

References:

- Foundation: `tech-plans/approved/ARCH-001-app-architecture.md`
- Jira epic/story: `ARCH-5`, `ARCH-12`

This plan is required before any web app code is moved into `apps/web/`. It does not approve the move by itself.

## Problem Statement

ARCH-001 defines `apps/web/` as a placeholder and keeps the web app in a separate repository until a dedicated migration plan is approved. Moving web code into this repository affects source ownership, build tooling, environment variables, Supabase/API boundaries, CI, deployment, release ownership, and local developer workflows.

## Goals / Non-goals

### Goals

- Define the future migration approach for moving the web app into `apps/web/`.
- Preserve stable build, environment, API, CI, and deployment behavior.
- Make source repository ownership, incremental migration, validation, and rollback explicit.
- Keep future implementation tickets small and reviewable after approval.

### Non-goals

- Move web code in this plan.
- Add a new web app scaffold.
- Change deployment, hosting, CI, environment variables, Supabase configuration, or production behavior.
- Create migration implementation tickets before this plan and any required ADR are approved.

## User Stories

- As a future web engineer, I want a migration plan before moving code so build and deployment behavior remain stable.
- As a release owner, I want deployment and CI impacts identified before implementation so web releases remain controlled.
- As a backend owner, I want API and Supabase boundaries documented so web migration does not change data ownership by accident.

## UX Flow

This plan has no end-user UX impact. The migration must preserve the existing web experience and deployment behavior.

Developer workflow after approval:

1. Inventory the external web repository and deployment pipeline.
2. Confirm target structure under `apps/web/`.
3. Move or mirror code in a migration branch.
4. Update build, test, lint, environment, and deployment paths.
5. Validate local web workflows and CI.
6. Cut over repository ownership only after approval and rollback readiness.

## Architecture

### Current State

The web app remains outside this repository. `apps/web/` is a placeholder only.

ARCH-001 does not approve adding, moving, or deploying web code from this repository.

### Proposed Target State

After approval and implementation, web should live under:

- `apps/web/`
- `apps/web/package.json` or equivalent project manifest.
- `apps/web/src/` or framework-specific source directory.
- `apps/web/tests/` or framework-specific test directories.
- `apps/web/public/` or static asset directory if used.

The exact framework and build layout should come from the existing external web repository. This migration should not introduce a new web architecture unless separately approved.

### Source Repository Ownership

Before implementation, the owner must confirm:

- Source repository URL and default branch.
- Whether the external repository is archived, mirrored, or kept temporarily active.
- Whether issues, PRs, releases, tags, and deployment history need migration.
- Cutover criteria for treating this repository as the source of truth.
- Owner responsible for web deployment during and after migration.

## Build Tooling

Implementation must inventory and preserve:

- Package manager and lockfile.
- Node/runtime version.
- Framework build command.
- Test command.
- Lint/typecheck command.
- Static asset paths.
- Generated files.
- Local development command.

Root-level commands may delegate into `apps/web/`, but the migration should not force unrelated iOS workflow changes.

## Environment Strategy

Implementation must document all environment variables before moving code:

- Public client-side values.
- Server-only secrets.
- Supabase URL, anon key, and any service-role key usage.
- Feature flag and analytics keys.
- Deployment-specific variables.

No real secrets should be committed. Any required secret migration must use the approved secret manager or hosting provider configuration.

## API And Supabase Boundaries

The migration must preserve existing API and Supabase ownership:

- Web must not introduce new tables, policies, storage buckets, Edge Functions, or generated types without an approved backend plan.
- Shared contracts with iOS must be documented before reuse.
- Any generated type strategy must align with approved database planning.
- Client-side Supabase usage must not expose privileged keys.

## CI

Implementation must define the future web CI jobs before cutover:

- Install dependencies.
- Lint or format check.
- Typecheck.
- Unit tests.
- Build.
- Optional end-to-end tests.
- Path filters or change detection, if used.

Adding required checks or changing release gates requires explicit approval.

## Deployment

Implementation must document:

- Hosting provider.
- Preview deployment behavior.
- Production deployment trigger.
- Rollback mechanism.
- Environment variable ownership.
- Domain and DNS ownership.
- Analytics and monitoring handoff.

No deployment behavior changes are approved by this proposed plan.

## Incremental Migration Strategy

Prefer the least risky approach approved by the owner:

1. Inventory external repo and deployment.
2. Add proposed target structure and migration checklist.
3. Move code with history-preserving Git operations where practical.
4. Run build/test/lint locally and in CI.
5. Enable preview deployment from the monorepo if required.
6. Cut over production deployment only after validation.
7. Archive or freeze the old repository after successful cutover.

## Database Changes

None. This migration must not change schema, migrations, RLS, storage, generated types, seed data, or Supabase configuration.

## API / Service Changes

None by default. Any API, shared contract, Supabase, or Edge Function change requires a separate approved plan.

## UI Components

None by default. Moving web code should preserve the existing web UI. Redesign, design-system adoption, or shared component work requires separate planning.

## Dependencies

- Approved ARCH-001 architecture foundation.
- ADR for repository/app structure change before implementation.
- Owner approval of this proposed migration plan.
- Access to the external web repository and deployment configuration.
- Confirmed environment variable and secret ownership.

## Milestones

1. Approve this proposed plan and create any required ADR.
2. Inventory external web repository, environment, CI, and deployment.
3. Create implementation tickets after approval.
4. Move code and repair build/test/deployment paths.
5. Validate local workflows, CI, preview deployment, and rollback.
6. Confirm source-of-truth cutover.

## Risks

- Secrets or server-only variables could be exposed if environment ownership is unclear.
- Deployment could diverge between old and new repositories during cutover.
- CI may pass locally but fail in hosting-specific build environments.
- Shared API or Supabase assumptions may drift from iOS if contracts are implicit.
- Large move diffs can hide unrelated web changes.

## Testing Strategy

Implementation PRs must run:

- Web dependency install.
- Web lint/format validation.
- Web typecheck.
- Web unit tests.
- Web production build.
- Preview deployment validation if deployment ownership moves.
- Docs validation for changed links or migration notes.

If any command is unavailable, the migration PR must document the missing command and the owner decision required before cutover.

## Rollout Plan

Recommended rollout:

1. Keep external web repository as source of truth until monorepo validation passes.
2. Move code into `apps/web/` without redesign or feature changes.
3. Run CI and preview deployment from the monorepo.
4. Cut over production deployment only after owner approval.
5. Archive or freeze the external repository after production cutover.

## Rollback Plan

Rollback should keep the external web repository available until production cutover is complete.

If monorepo migration fails before cutover, continue using the external repository and revert the migration PR. If failure happens after cutover, restore deployment to the external repository or revert the monorepo migration according to the hosting provider rollback process.

## Definition of Done

- This proposed plan is approved.
- Required ADR is created and approved before implementation.
- Migration Jira stories are created only after approval.
- Local web build/test/lint and CI pass after migration.
- Deployment behavior is validated or explicitly deferred by owner decision.
- Architecture docs reflect the new approved repository state after implementation.

## Jira Breakdown

Do not create implementation tickets until this plan and the required ADR are approved.

Potential future tickets after approval:

- Inventory external web repository, CI, deployment, and environment variables.
- Move web app into `apps/web/`.
- Repair web build, test, lint, and package paths.
- Add or update web CI validation.
- Validate preview/production deployment cutover.
- Update docs and agent guidance after migration.

## Open Questions

- What is the external web repository URL and current deployment provider?
- Which package manager and Node/runtime version should be treated as authoritative?
- Should root-level commands delegate to `apps/web/` after migration?
- Who owns production deployment cutover and rollback approval?
- Should the external repository be archived immediately or kept as a read-only fallback?

