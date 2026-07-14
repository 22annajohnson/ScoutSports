# Implementation Tech Plan: TEST-002 Repository & UI Testing

## Status

Proposed

## Product Domain

INFRA / CORE

## Jira Project

INFRA

## Source of Truth

References:

- `tech-plans/approved/ARCH-001-app-architecture.md`
- `implementation/proposed/INFRA-003-ci-cd-foundation.md`
- `implementation/proposed/DB-001-supabase-database-foundation.md`
- `implementation/proposed/PROFILE-004-profile-database-schema.md`
- `implementation/proposed/PROFILE-005-public-profile-and-owner-profile.md`
- `implementation/proposed/SWIPE-004-discovery-candidate-queue.md`
- `implementation/proposed/FEED-002-feed-backend.md`
- `implementation/proposed/EVENT-002-community-games-v1.md`

## Problem Statement

Scout is moving from mock-driven flows to repository-backed production behavior. Implementation agents need a shared testing structure so repository, ViewModel, navigation, and UI-state changes can be reviewed safely and independently.

## Goals

- Establish repository test fixture and mock conventions.
- Expand coverage for onboarding, profile, swipe, feed, and navigation flows.
- Add a lightweight snapshot/screenshot strategy for high-risk reusable UI states.
- Ensure tests are compatible with CI and local validation.
- Keep tests focused enough for small agent PRs.

## Non-goals

- Rewriting the app architecture for testability.
- Full end-to-end automation across real Supabase environments.
- Mandatory snapshots for every view.
- Replacing existing CI workflows.
- Broad production code refactors.

## Architecture

```text
Feature ViewModels
  -> Repository protocols
  -> Mock repositories / fixtures
  -> Unit and UI-state tests
  -> CI validation
```

Tests should verify domain behavior at repository and ViewModel boundaries. SwiftUI rendering checks should focus on reusable components, key states, and regression-prone screens rather than duplicating every manual QA path.

## Repository Ownership

Infrastructure owns test conventions, fixture helpers, snapshot strategy, and CI compatibility. Each product domain owns tests for its own repository, ViewModel, and UI states.

## Domain Ownership

| Test Area | Owner | Consumers |
| --- | --- | --- |
| Fixture helpers | INFRA | Profile, Discovery, Feed, Events |
| Repository mock conventions | INFRA | All repository-backed domains |
| Profile tests | Profile | Discovery, Events, Chat |
| Swipe tests | Discovery | Feed, Match |
| Feed tests | Feed | Events, Discovery |
| Navigation tests | CORE | All feature flows |
| Snapshot strategy | Design / INFRA | ScoutDesign, feature UI |

## Backend Ownership

TEST-002 does not create Supabase schema. Repository tests may use mocks, local Supabase fixtures, or generated type fixtures depending on the relevant implementation plan. Any real database test workflow must follow DB-001.

## iOS Responsibilities

- Add test doubles for repository protocols.
- Keep ViewModels testable through dependency injection.
- Cover loading, empty, error, success, and permission states.
- Validate navigation routes that connect core product flows.
- Use snapshots/screenshots selectively for reusable components and critical state regressions.

## Testing Scope

Initial coverage targets:

- Repository fixtures and mock conventions.
- Onboarding readiness and transition tests.
- Profile owner/public/editing ViewModel tests.
- Swipe queue and decision state tests.
- Feed loading/empty/error/refresh tests.
- Navigation smoke tests for onboarding -> profile -> main app.
- Snapshot/screenshot strategy for shared cards, empty states, loading states, and high-risk profile/swipe/feed screens.

## Jira Search Findings

Before expanding screenshot/debugging work, search found existing Jira coverage:

- `INFRA-47` - `TEST-002: Repository and UI Testing`
- `INFRA-52` - `Testing: Add selective snapshot and screenshot strategy`
- `CORE-31` - `Design: Add UI PR screenshot and Design Factory validation checklist`

`INFRA-52` already covers the V0 scope for selective snapshot and screenshot strategy. Do not create a duplicate epic or story for simulator screenshot support unless `INFRA-52` is closed, split, or explicitly superseded. This plan extends `INFRA-52` as the implementation vehicle.

## Simulator and Local Test Findings

Current inspection found:

- `Scout/Makefile` defines `make test` with one explicit destination: `platform=iOS Simulator,name=iPhone 17 Pro`.
- `Scout/Makefile` does not list multiple test destinations and does not explicitly enable parallel destination testing.
- `.github/workflows/ios-tests.yml` runs `bundle exec fastlane ios tests`.
- `Scout/fastlane/Fastfile` calls `run_tests(scheme: "Scout", clean: true)` without specifying a simulator device.
- `xcodebuild -showdestinations` lists all available iOS simulators, one physical device, Any iOS Device, Any iOS Simulator Device, and Mac-designed-for-iPad/iPhone.
- `ScoutUITestsLaunchTests` currently captures an XCTest screenshot attachment on launch.

Based on the checked-in configuration, multiple simulators are not intentionally configured in `make test`. The Makefile points at one simulator. If agents see approximately five simulators boot, the likely causes are Xcode/Fastlane destination discovery, scheme/test runner behavior, or simulator preparation outside the Makefile command rather than multiple explicit Makefile destinations. A follow-up should inspect an actual `make test` result bundle or `xcodebuild` log before changing the command.

Agents should not run the full `make test` suite after every small change. CI is the default first full validation pass. Local simulator use is appropriate only when debugging failed CI, reproducing a UI failure, capturing a requested screenshot, recording or updating an approved snapshot, or verifying a visual change that CI cannot explain clearly.

Agents may use a narrower local command for targeted debugging if needed, such as overriding `TEST_DESTINATION` to one known simulator or using Xcode's `-only-testing` option for a specific test target/class. A dedicated supported Makefile target for one-simulator visual debugging should be added by `INFRA-52`; this plan does not change commands.

## V0 Visual Evidence Workflow

V0 should give UI-focused agents a deterministic way to produce review evidence without turning Scout into a broad visual regression platform.

Proposed V0:

- Add one deterministic launch path for a specific screen or fixture state.
- Add one documented command for booting or targeting a single simulator.
- Add one documented command or workflow for capturing a simulator screenshot.
- Preserve XCTest screenshot attachments for UI tests where useful.
- Use snapshot tests only for selected stable components or states.
- Upload screenshots or `.xcresult` bundles as CI artifacts only when the owning story explicitly adds that behavior.
- Document when local simulator work is appropriate and when PR CI is sufficient.

Expected agent workflow:

1. Agent completes the change locally without automatically running the full test suite.
2. Agent pushes the change and opens or updates the pull request.
3. CI runs the required build and test checks.
4. If CI passes, the agent does not need to rerun the full suite locally for a simple change.
5. If CI fails, inspect the CI failure first.
6. If the cause is clear, make a correction and push again.
7. If local reproduction is needed, run a targeted local test or one-simulator visual command.
8. Agents may use the simulator locally for failed UI tests, CI-only visual failures, new screenshots, approved snapshot recording/updating, or visual changes CI cannot explain clearly.
9. After fixing the issue, push again and allow CI to rerun as the source of truth.

Likely files or systems affected by `INFRA-52`:

- `Scout/Makefile`
- `Scout/Scout/App/` launch/debug routing if a fixture entry point is needed
- `Scout/ScoutUITests/`
- `.github/workflows/ios-tests.yml`
- `.github/local-ci-validation.md`
- `.github/README_github.md`
- PR template or agent docs only if screenshot evidence expectations change

V0 acceptance criteria:

- A UI agent can launch Scout into one approved deterministic screen or fixture state.
- A UI agent can target one simulator for local visual debugging.
- A UI agent can capture a simulator screenshot and attach or link it in a PR when requested.
- XCTest screenshot attachments remain available for targeted UI tests.
- Snapshot tests are limited to selected stable components/states.
- CI artifacts are added only for screenshots or `.xcresult` output explicitly produced by the workflow.
- Documentation says PR CI is the default first validation pass and local full-suite testing is not required for every small change.
- The five-simulator `make test` behavior is documented as an investigation follow-up, not silently changed.

## Implementation Sequencing

1. Add shared fixture and mock repository conventions.
2. Add onboarding/profile ViewModel tests.
3. Add swipe/feed repository and ViewModel tests.
4. Add navigation smoke tests.
5. Add selective snapshot/screenshot harness through the V0 visual evidence workflow.
6. Document local test commands and CI compatibility.

## Validation Strategy

- Run relevant Swift tests locally.
- Ensure test targets run in CI without expensive duplication.
- Verify tests do not require production secrets.
- Confirm snapshots are deterministic or documented as screenshot/manual artifacts.
- Prefer PR CI for the first full validation pass. Use local simulator/test commands only for targeted debugging, visual evidence capture, or explicitly requested validation.

## Rollout Strategy

1. Land fixture conventions first.
2. Add tests domain by domain alongside implementation PRs.
3. Introduce snapshots only for stable reusable UI and critical states.
4. Expand coverage as Profile, Discovery, Feed, and Events move from plans into code.

## Risks

- Overly broad tests slowing agent iteration.
- Snapshot churn from unstable UI.
- Tests accidentally depending on real dev data.
- Mock conventions drifting from repository contracts.
- CI runtime increasing too quickly.

## Definition of Done

- Repository fixture and mock conventions exist.
- Core onboarding/profile/swipe/feed/navigation tests are planned and ticketed.
- Snapshot/screenshot strategy is defined for selective adoption.
- Test work can run locally and in CI without secrets.
- Future implementation agents have clear testing tickets tied to production features.

## Jira Breakdown

- Epic: `INFRA-47` - TEST-002: Repository and UI Testing
- Story points use Scout's `0.25` increment scale. Values such as `0.75` and `1.5` are valid.

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `INFRA-48` | Testing: Add repository fixtures and mock conventions | 🤖 AI Implementation | 0.75 | TEST-002 |
| 2 | `INFRA-49` | Testing: Add onboarding and profile ViewModel coverage | 🤖 AI Implementation | 1.5 | `INFRA-48`, PROFILE-005 |
| 3 | `INFRA-50` | Testing: Add swipe and feed repository state coverage | 🤖 AI Implementation | 1.5 | `INFRA-48`, SWIPE-004, FEED-002 |
| 4 | `INFRA-51` | Testing: Add navigation smoke tests for core app flows | 🤖 AI Implementation | 1 | `INFRA-48`, current navigation architecture |
| 5 | `INFRA-52` | Testing: Add agent-accessible screenshot and snapshot-debugging V0 | 🤖 AI Implementation | 1 | `INFRA-48`, DESIGN-002/DESIGN-004 |
| 6 | `INFRA-53` | Testing: Document local test commands and CI compatibility | 🤖 AI Implementation | 0.5 | INFRA-003, TEST-002 |

Recommended `INFRA-52` implementation order:

1. Document the one-simulator visual-debug command and default PR CI workflow.
2. Add deterministic launch/fixture routing for one stable screen.
3. Add screenshot capture instructions or helper command.
4. Preserve or add targeted XCTest screenshot attachment support.
5. Add selected stable snapshot coverage only if the implementation story chooses a snapshot library or native approach.
6. Add CI artifact upload for screenshots or `.xcresult` only if the generated artifacts are stable and useful.

Separate follow-up:

- Investigate why a local `make test` run appears to boot approximately five simulators. Do not change the test command until an actual result bundle or `xcodebuild` log confirms whether Xcode/Fastlane is preparing multiple devices, running UI configurations, or inheriting destination behavior from outside the Makefile.
