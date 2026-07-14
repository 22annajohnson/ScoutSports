# Implementation Plan: iOS Monorepo Migration

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
- Jira epic/story: `ARCH-5`, `ARCH-11`

This plan is required before any implementation work moves the iOS app into `apps/ios/`. It does not approve the move by itself.

## Problem Statement

ARCH-001 preserves the current root-level iOS app until a dedicated migration plan is approved. Moving iOS affects Xcode project references, schemes, package paths, tests, Fastlane, CI, local developer workflows, and review history. Those changes need a deliberate migration plan before implementation tickets exist.

## Goals / Non-goals

### Goals

- Define the future migration approach for moving the iOS app to `apps/ios/`.
- Preserve build stability, scheme behavior, tests, Fastlane, CI, and local `Makefile` workflows.
- Make validation and rollback explicit before implementation begins.
- Keep the migration reviewable through small follow-up Jira stories after approval.

### Non-goals

- Move iOS files in this plan.
- Edit Xcode project references, schemes, package paths, CI, Fastlane, or build settings.
- Change app architecture, feature boundaries, product behavior, schema, auth, or storage.
- Create migration implementation tickets before this plan and any required ADR are approved.

## User Stories

- As an iOS engineer, I want a migration plan before moving files so Xcode references and schemes remain stable.
- As a release owner, I want CI and Fastlane impacts identified before implementation so release validation remains reliable.
- As a reviewer, I want a rollback plan so the migration can be reverted if build or tooling behavior breaks.

## UX Flow

This plan has no end-user UX impact. The migration must preserve the existing app experience.

Developer workflow after approval:

1. Create migration branch from current `develop`.
2. Move the iOS app into `apps/ios/` in a dedicated implementation ticket.
3. Update Xcode project references and schemes.
4. Update local build/test scripts and Fastlane paths.
5. Update CI paths and cache keys.
6. Run full local and CI validation.
7. Review as a migration-only PR with no product behavior changes.

## Architecture

### Current State

The iOS app currently lives at the repository root:

- `Scout/`
- `ScoutTests/`
- `ScoutUITests/`
- `Scout.xcodeproj`
- `Makefile`

ARCH-001 explicitly says this state remains approved until a dedicated migration plan is approved.

### Proposed Target State

After approval and implementation, iOS should live under:

- `apps/ios/Scout/`
- `apps/ios/ScoutTests/`
- `apps/ios/ScoutUITests/`
- `apps/ios/Scout.xcodeproj`
- `apps/ios/Makefile` or a root `Makefile` wrapper that delegates to `apps/ios/`

The exact Makefile ownership should be decided during implementation planning. If the root `Makefile` remains, it should keep current developer commands stable by delegating to the moved iOS app.

### Migration Slices

1. Preflight inventory: document current project file references, schemes, Fastlane paths, CI paths, and Makefile targets.
2. File move: move iOS app, tests, project, and iOS-local build files to `apps/ios/`.
3. Xcode repair: update project references, schemes, package paths, and test target references.
4. Tooling repair: update Makefile, Fastlane, CI, and any scripts that assume root-level iOS paths.
5. Documentation repair: update architecture docs, local CI docs, README references, and agent guidance.
6. Validation and cleanup: run full local validation and confirm CI parity.

## Xcode Project Reference Mapping

Implementation must inventory and update:

- File references for `Scout/`, `ScoutTests/`, and `ScoutUITests/`.
- Build phase paths.
- Test target references.
- Scheme shared data.
- Package references and derived-data assumptions.
- Asset, Info.plist, entitlements, preview, and generated file paths.

The migration PR should include before/after notes for each changed Xcode area.

## Scheme Validation

Implementation must confirm:

- Main app scheme builds.
- Unit test scheme runs.
- UI test scheme remains discoverable.
- Release/archive configuration still resolves paths.
- Schemes remain shared where CI expects them.

## Package And Build Paths

Implementation must update path assumptions in:

- Root or iOS-local `Makefile`.
- Swift Package references if any path-based packages are present.
- Build scripts.
- Test scripts.
- Derived output or generated file locations.

The default local commands should remain documented and stable.

## Fastlane

Implementation must inventory Fastlane configuration before the move and update:

- Project path.
- Scheme names only if unavoidable.
- Build output paths.
- Test lane paths.
- Any lane that assumes the project is at the repository root.

No release process changes are approved by this migration plan.

## CI

Implementation must update CI only as required to preserve current validation behavior:

- iOS change detection paths.
- Swift test workflow working directory.
- Cache keys and dependency paths.
- Documentation validation paths only if documentation links change.
- Any script paths that point at root-level iOS files.

Changing required checks, release gates, or CI strategy requires separate approval.

## Git History And Review Strategy

The migration should be one reviewable PR when possible, but implementation tickets should keep review risk small:

- Prefer `git mv` for file moves so history remains traceable.
- Avoid product behavior changes in the migration PR.
- Avoid formatting-only churn.
- Keep path repair commits separate from optional documentation cleanup when practical.

## Database Changes

None. This migration must not change schema, migrations, RLS, storage, generated types, seed data, or Supabase configuration.

## API / Service Changes

None. This migration must not change repository contracts, Supabase calls, service boundaries, auth behavior, or public/shared API contracts.

## UI Components

None. This migration must not change production UI, visual styling, navigation, accessibility behavior, or design tokens.

## Dependencies

- Approved ARCH-001 architecture foundation.
- ADR for repository/app structure change before implementation.
- Owner approval of this proposed migration plan.
- Stable CI workflow expectations before implementation begins.

## Milestones

1. Approve this proposed plan and create any required ADR.
2. Create small implementation stories for inventory, move, repair, validation, and documentation.
3. Execute migration without product behavior changes.
4. Validate local and CI parity.
5. Update architecture and agent docs to reflect the new approved state.

## Risks

- Xcode references may break silently until build or test execution.
- CI path filters or working directories may skip required validation.
- Fastlane or release paths may diverge from local build paths.
- Large move diffs can hide unintended code changes.
- Open PRs against root-level iOS files may need rebasing after the migration.

## Testing Strategy

Implementation PRs must run:

- `make build`
- `make test`
- Any existing UI test or release validation command required by the touched workflow.
- CI docs validation when documentation links change.
- Manual Xcode scheme open/build verification if project references change.

If simulator availability blocks `make test`, the PR must document the exact failure and retry after simulator cleanup.

## Rollout Plan

This is a repository migration, not a runtime feature rollout.

Recommended rollout:

1. Announce migration window and pause broad iOS feature branches if practical.
2. Merge migration after CI passes.
3. Require active iOS PRs to rebase onto the moved structure.
4. Keep root-level wrappers temporarily if needed to preserve developer commands.
5. Remove temporary compatibility wrappers in a later cleanup only after approval.

## Rollback Plan

Rollback should be a revert of the migration PR if build, CI, Fastlane, or project references cannot be repaired quickly.

The migration PR must avoid product changes so rollback does not revert user-facing behavior. Any compatibility wrappers added during migration should be documented so rollback can remove them cleanly.

## Definition of Done

- This proposed plan is approved.
- Required ADR is created and approved before implementation.
- Migration Jira stories are created only after approval.
- Implementation preserves app behavior and validation coverage.
- Local build/test and CI pass after the move.
- Architecture docs reflect the new approved repository state after implementation.

## Jira Breakdown

Do not create implementation tickets until this plan and the required ADR are approved.

Potential future tickets after approval:

- Inventory root-level iOS project references and tooling paths.
- Move iOS app and tests to `apps/ios/`.
- Repair Xcode project references and schemes.
- Repair Makefile, Fastlane, CI, and script paths.
- Update docs and agent guidance after migration.

## Open Questions

- Should the root `Makefile` remain as the stable developer entry point after the move?
- Should Fastlane move under `apps/ios/` or remain root-level with updated paths?
- Should the migration pause new iOS feature PRs until merged?
- Which CI checks are required before approving the migration PR?

