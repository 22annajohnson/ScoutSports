# Scout Architecture

## Purpose

This document describes Scout's current architecture and intended monorepo direction. It should guide planning, but it does not approve future restructures by itself.

Any change to project organization, database schema, shared service contracts, app boundaries, or build infrastructure requires an approved technical plan before implementation.

## Current State

Scout is currently an iOS-focused repository with a Swift/SwiftUI application at the repository root.

### Approved Repository State

The approved state is defined by `tech-plans/approved/ARCH-001-app-architecture.md`:

- iOS remains at the repository root; do not move app files into `apps/ios/` yet.
- The web app remains in a separate repository; do not add or move web app code into `apps/web/` yet.
- `apps/ios/` and `apps/web/` are placeholders until dedicated migration plans are approved.
- `backend/supabase/` is documentation and planning only until backend implementation work is approved.
- Do not edit Xcode project references, schemes, package paths, CI, Fastlane, or build settings as part of architecture foundation work.
- Do not create migration implementation tickets from ARCH-001 alone.

Current notable areas:

- `Scout/App/`: app entry, root routing, app environment, and home screen wiring.
- `Scout/AuthGate/`: authentication gate, session handling, auth view models, and auth views.
- `Scout/Profile/`: profile UI and view models.
- `Scout/Swipe/`: swipe card models, data, view models, views, and match modal.
- `Scout/Feed/`: feed models, view models, and views.
- `Scout/Data/`: auth, profile, storage, and Supabase-facing data access.
- `Scout/Domain/`: domain models currently shared across features.
- `Scout/Design/`: design assets, components, modifiers, preview helpers, theme, and typography.
- `Scout/Shared/`: shared models and views.
- `ScoutTests/` and `ScoutUITests/`: current test targets.

Supabase is the current backend provider for authentication, data, and storage.

## Future Monorepo Direction

The intended future repository shape is:

- `apps/ios/`: future home of the iOS app after an approved migration.
- `apps/web/`: future home of the web app after an approved migration from its current separate repository.
- `backend/supabase/`: Supabase documentation, SQL, migrations, Edge Functions, policies, and storage docs.
- `docs/`: durable product, architecture, design, database, and agent documentation.
- `tech-plans/`: proposed, approved, archived, and template technical plans.
- `jira/`: Jira operating model and ticket conventions.

This direction is not an instruction to move code now. The iOS move should be its own migration project.

## Architectural Principles

- Keep feature boundaries clear and reviewable.
- Prefer existing local patterns before adding new abstractions.
- Separate domain decisions from platform-specific UI where the current codebase supports it.
- Treat schema, auth, storage, and API boundaries as product-level decisions.
- Keep shared code intentional. Avoid creating broad shared layers before multiple apps genuinely need them.
- Optimize for AI-assisted implementation by documenting contracts, dependencies, and validation steps.

## Application Boundaries

### iOS

The iOS app owns native user experience, local state presentation, SwiftUI views, iOS-specific navigation, and platform-specific integrations.

### Web

The web app will remain outside this repository until migration. Future web architecture must be documented before code is moved.

### Backend

Supabase owns auth, database, storage, policies, and any future Edge Functions unless a different backend boundary is approved.

### Shared Contracts

Shared domain concepts should be documented first. Generated types, shared schemas, or cross-platform packages require explicit approval.

## Feature Organization

Use product domains to keep planning and implementation aligned:

- `AUTH`
- `ONBOARDING`
- `PROFILE`
- `SWIPE`
- `FEED`
- `SOCIAL`
- `EVENTS`
- `NOTIFICATIONS`
- `INFRA`
- `ARCH`

Feature-specific code should remain in the relevant feature area unless a shared abstraction is justified by repeated use.

## Data Flow

Current expected pattern:

1. SwiftUI view renders state and sends user intent to a view model.
2. View model coordinates feature behavior.
3. Repository or service layer performs Supabase, auth, storage, or persistence work.
4. Domain or data models represent app-facing state.
5. View model maps loaded data into UI state.

Future plans should document when they follow or intentionally change this pattern.

## Dependency Strategy

- iOS validation should use the root `Makefile`.
- New dependencies require justification in the relevant technical plan.
- Cross-platform dependencies should not be added until the monorepo architecture is approved.
- Backend or schema dependencies should be documented in `docs/database/` and the relevant tech plan.

## Migration Guidance

The iOS migration to `apps/ios/` should be planned separately and should include:

- Xcode project reference mapping.
- Scheme and target validation.
- Package and build path review.
- CI updates.
- Fastlane updates.
- Git history and review strategy.
- Rollback plan.

The web migration should also be planned separately and should include build, environment, deployment, API, and CI implications.

## Open Architecture Questions

- When should the iOS app move to `apps/ios/`?
- Should any shared package exist between iOS and web, and what problem would it solve?
- How should Supabase types be generated and versioned?
- What CI matrix should exist after web migration?
- Which domain models should become documented cross-platform contracts?
