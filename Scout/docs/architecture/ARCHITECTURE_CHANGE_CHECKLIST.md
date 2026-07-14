# Architecture Change Checklist

Use this checklist before creating Jira stories or changing code. It helps decide whether work is ordinary feature implementation or an architecture change that needs planning approval and an ADR.

## Required Ticket References

Every implementation ticket should identify:

- Jira key.
- Approved tech plan.
- Affected repo area: `iOS`, `Web`, `Supabase`, `Docs`, or `CI/CD`.
- Dependencies and blocked work.
- Acceptance criteria.
- Validation steps.
- Handoff expectations.

## Stop For Architecture Approval

Stop and require an ADR or approved architecture plan when the work changes:

- App structure, repository layout, or file ownership.
- Backend ownership between Supabase, Edge Functions, or another service.
- Database architecture, migration strategy, generated types, RLS, or storage policy.
- Auth strategy, session ownership, or employee/internal access rules.
- Shared packages, cross-platform contracts, or public API boundaries.
- CI strategy, required checks, release gates, or deployment structure.
- Module boundaries, feature ownership, or long-term technical direction.
- Established architecture patterns that future agents are expected to follow.

## Usually Feature Implementation

Work is usually feature implementation when it:

- Implements a Jira story from an approved tech plan.
- Stays inside existing feature, repository, and service boundaries.
- Extends an approved screen, view model, repository, or model contract.
- Adds tests for existing behavior.
- Fixes a bug without changing ownership, contracts, persistence strategy, auth, CI, or project structure.
- Updates documentation to reflect an approved decision or implemented behavior.

## Affected Area Questions

### iOS

- Does this move app files, Xcode project files, package paths, schemes, targets, tests, or Fastlane configuration?
- Does this introduce a new cross-feature service or module boundary?
- Does this create a reusable pattern future features must follow?

### Web

- Does this move or introduce web app code in this repository?
- Does this change web build, environment, deployment, or shared API assumptions?
- Does this create a cross-platform contract with iOS or Supabase?

### Supabase

- Does this change schema, migrations, RLS, storage, Edge Functions, generated types, or seed data?
- Does this change backend ownership for a product capability?
- Does this require production environment or secret handling decisions?

### Docs

- Does this update the source of truth for product, architecture, domain, design system, database, or CI decisions?
- Does this contradict an approved plan or ADR?
- Does this create implementation guidance that needs owner approval first?

### CI/CD

- Does this change required checks, workflow triggers, release gates, deployment behavior, or validation policy?
- Does this add or remove a build/test path future PRs depend on?
- Does this change how docs, iOS, Supabase, or future web work is validated?

## Conflict Rule

If product docs, architecture docs, ADRs, approved tech plans, Jira epics, or Jira stories conflict, do not resolve the conflict in implementation. Stop, document the conflict, and wait for the owning planning artifact to be updated.

