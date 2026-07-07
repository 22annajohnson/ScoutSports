# Scout

Scout is a Swift/SwiftUI product for helping people connect offline through sports, starting with pickleball.

This repository is currently the Scout iOS repository. It is being prepared to become the future Scout monorepo, but the existing iOS project has not been moved. The current Xcode project, source folders, package paths, schemes, CI configuration, and build settings remain in their original root-level locations.

The web application currently lives in a separate repository and will be migrated here later through an approved migration plan.

## Current State

- The iOS app currently lives at the repository root in `Scout/`, `ScoutTests/`, `ScoutUITests/`, `Scout.xcodeproj`, `fastlane/`, and related files.
- `apps/ios/` is a future placeholder only. It does not contain the current iOS app.
- `apps/web/` is a future placeholder only. It does not contain the current web app.
- `backend/supabase/` is a planning location for Supabase documentation and future backend assets.
- No production code has been moved as part of the monorepo preparation.

## Software Factory Workflow

Scout development should follow this pipeline:

1. Idea
2. Roadmap
3. Implementation Tech Plan
4. Approval
5. Jira Epic
6. Jira Stories
7. Implementation
8. Review + CI
9. Complete

Major feature work should not begin until a roadmap item has been promoted into an approved implementation tech plan and broken into small, reviewable Jira stories.

## Top-Level Structure

- `Scout/`, `ScoutTests/`, `ScoutUITests/`, `Scout.xcodeproj`, and `fastlane/` contain the current iOS app and supporting project files.
- `ROADMAP.md` is the executive planning dashboard.
- `apps/` contains placeholders for future application locations.
- `backend/` contains backend documentation, Supabase planning, and future backend assets.
- `docs/` contains durable product, architecture, design, database, agent, and contribution documentation.
- `roadmap/` contains lightweight living domain roadmaps.
- `tech-plans/` contains proposed, approved, archived, and template technical plans.
- `implementation/` contains detailed implementation tech plans as they move from proposed to complete.
- `jira/` documents Jira project organization, conventions, and workflow.
- `.github/` contains GitHub workflows, templates, and repository automation.
- `AGENTS.md` contains repository-wide instructions for AI agents.

## Validation

For current iOS work, use the repository `Makefile` before reaching for custom Xcode commands:

- `make build`
- `make test`
- `make run`
- `make clean`

Documentation-only changes do not require an iOS build unless they modify CI, project configuration, package paths, or build settings.
