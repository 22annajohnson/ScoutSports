# Monorepo CI Planning Questions

## Purpose

This document captures planning questions for future monorepo CI work. It is not an implementation decision and does not change GitHub Actions, required checks, build settings, deployment behavior, or validation policy.

ARCH-001 requires ADR or approval before changing CI strategy. Future iOS and web migration plans should reference this document before implementation.

## Planning Boundary

These questions are intentionally unresolved until the relevant migration plan or ADR is approved.

Do not use this document to:

- Add CI jobs.
- Remove CI jobs.
- Change required checks.
- Change workflow triggers.
- Change release gates.
- Change deployment behavior.
- Implement web or backend validation.

## Questions Requiring ADR Or Explicit Approval

- What CI matrix should exist after iOS, web, docs, and Supabase all live in one repository?
- Which checks are required for every PR, and which checks are conditional by path?
- Should iOS, web, docs, and Supabase checks be separate required statuses or one aggregate status?
- How should required GitHub checks behave when a path-filtered workflow skips?
- What release gates are required before production iOS or web deployment?
- Should migration PRs temporarily require broader validation than ordinary feature PRs?
- Who owns CI strategy after monorepo migration: ARCH, INFRA, release, or domain owners?

## iOS Questions

- Should the root `Makefile` remain the stable local and CI entry point after an iOS move to `apps/ios/`?
- Which iOS commands must run for app-code changes: build, unit tests, UI tests, release build, or simulator smoke test?
- Which iOS paths should trigger Swift Tests after the app moves?
- How should CI handle simulator availability failures?
- Which cache paths need to change if the Xcode project moves?
- Should docs-only PRs continue to skip Swift Tests when no iOS files change?

## Future Web Questions

- Which package manager, runtime version, and lockfile are authoritative?
- Which web checks are required: install, lint, typecheck, unit tests, build, end-to-end tests, or preview deployment?
- Should web CI run on all PRs after migration or only on web/shared path changes?
- What preview deployment check should block merge, if any?
- How should environment variables be validated without exposing secrets?
- Who owns production deployment approval after web moves into the monorepo?

## Docs Questions

- Should markdown and YAML validation remain global required checks?
- Should documentation link checks be added after README navigation is stable?
- Which docs paths should trigger architecture or planning review?
- Should implementation plans, tech plans, and Jira docs have separate validation rules?
- How should docs-only PRs demonstrate that app CI was intentionally skipped?

## Supabase Questions

- Which Supabase changes should trigger migration validation?
- Should generated types be checked into the repository, generated in CI, or both?
- How should local Supabase startup be validated without requiring production secrets?
- Which RLS, storage, Edge Function, and seed-data checks are required before merge?
- How should database rollback validation be represented in CI?

## Implementation Plan Questions

- Should proposed implementation plans require only docs validation?
- Should approved implementation plans require stricter link or reference validation?
- Should plans that mention CI, schema, auth, or architecture changes require an ADR-reference check?
- How should Jira keys and PR links be validated without coupling CI to Jira availability?

## Future Migration Validation Expectations

Future iOS and web migration plans should define:

- Required local validation commands.
- Required GitHub checks.
- Path filters and skip behavior.
- Cache and working-directory changes.
- Secret and environment variable handling.
- Rollback checks.
- Manual verification steps that CI cannot prove.

## Current Decision

No CI behavior changes are approved by this document. The current CI configuration remains authoritative until a future ADR or approved implementation plan changes it.

