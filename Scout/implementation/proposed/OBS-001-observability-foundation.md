# Implementation Tech Plan: OBS-001 Observability Foundation

## Status

Proposed

## Product Domain

INFRA / CORE

## Jira Project

INFRA

## Source of Truth

References:

- `tech-plans/approved/ARCH-001-app-architecture.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `tech-plans/approved/DESIGN-001-design-system.md`
- `implementation/proposed/DB-001-supabase-database-foundation.md`
- `implementation/proposed/PROFILE-005-public-profile-and-owner-profile.md`
- `implementation/proposed/SWIPE-004-discovery-candidate-queue.md`
- `implementation/proposed/EVENT-002-community-games-v1.md`

## Problem Statement

Scout needs a lightweight observability layer before beta so implementation agents can add analytics, crash, and diagnostic signals consistently without coupling product code to a permanent vendor or leaking private user data.

## Goals

- Add analytics, crash reporting, and logging abstractions.
- Support no-op/local providers for development and tests.
- Define event naming and payload conventions.
- Protect privacy by default.
- Wire the first high-value app, onboarding, profile, discovery, feed, and event signals.
- Keep vendor selection replaceable.

## Non-goals

- Permanently selecting analytics, crash, or logging vendors.
- Building dashboards.
- Capturing sensitive profile, location, chat, or auth payloads.
- Adding server-side telemetry.
- Implementing product experiments or A/B testing.

## Architecture

```text
SwiftUI / ViewModels / Repositories
  -> AnalyticsTracking protocol
  -> CrashReporting protocol
  -> AppLogging protocol
  -> NoOp / LocalDebug / FutureProvider adapters
```

App and feature code depend on Scout-owned protocols. Provider-specific SDKs, when adopted later, must live behind adapters and may not leak into feature code.

## Repository Ownership

Infrastructure owns observability protocols, provider adapters, event naming conventions, and privacy enforcement helpers. Product domains own when domain events should be emitted, but they do not own provider configuration or telemetry transport.

## Domain Ownership

| Area | Owner | Consumers |
| --- | --- | --- |
| Analytics protocols | INFRA | App, Profile, Discovery, Feed, Events |
| Crash reporting protocols | INFRA | App, repositories, ViewModels |
| Event naming | INFRA | All domains |
| Domain event emission | Owning domain | INFRA transports |
| Privacy redaction | INFRA | All domains |

## Backend Ownership

OBS-001 does not create backend schema or choose observability vendors. Future server-side logging or Supabase audit tables require a separate approved implementation plan.

## iOS Responsibilities

- Inject observability protocols through the app environment.
- Use no-op providers in tests/previews.
- Use local debug logging in development builds.
- Emit only approved, non-sensitive event names and metadata.
- Keep telemetry calls out of SwiftUI rendering where practical.

## Event Naming

Use stable, domain-prefixed names:

- `app.opened`
- `onboarding.started`
- `profile.discovery_ready`
- `discovery.queue_loaded`
- `discovery.decision_recorded`
- `feed.loaded`
- `event.created`
- `event.joined`
- `event.cancelled`

Payloads should prefer booleans, counts, coarse categories, and internal IDs only when approved. Do not include free-form bio text, exact location, chat contents, auth tokens, emails, or sensitive profile details.

## Implementation Sequencing

1. Add observability protocols and no-op providers.
2. Add local debug provider and dependency injection through AppEnvironment.
3. Add event naming constants and privacy validation helpers.
4. Wire high-value lifecycle and feature events.
5. Add crash/error capture hooks at repository and app boundaries.
6. Add tests proving providers are replaceable and payloads avoid PII.

## Validation Strategy

- Unit tests for no-op/local providers.
- Tests for event naming constants and payload privacy helpers.
- ViewModel/repository tests proving telemetry failures do not break user flows.
- Manual debug build validation of local event output.

## Rollout Strategy

1. Merge protocols and no-op providers first.
2. Wire local debug provider for development only.
3. Add feature events incrementally in small PRs.
4. Choose and integrate beta vendor later through a separate implementation plan or owner-approved story.

## Risks

- Telemetry leaking sensitive profile, location, chat, or auth data.
- Feature code becoming coupled to a vendor SDK.
- Event names changing frequently and breaking trend analysis.
- Too much instrumentation slowing product work.

## Definition of Done

- Observability protocols are available through AppEnvironment.
- No-op/local providers support tests and development.
- Event naming and privacy conventions are enforced by tests.
- Initial beta-relevant events are wired without choosing a permanent vendor.
- Product code is not coupled to third-party observability SDKs.

## Jira Breakdown

- Epic: `INFRA-40` - OBS-001: Observability Foundation

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `INFRA-41` | Observability: Add analytics crash and logging protocols | 🤖 AI Implementation | 0.75 | OBS-001 |
| 2 | `INFRA-42` | Observability: Add no-op and local debug providers | 🤖 AI Implementation | 0.75 | `INFRA-41` |
| 3 | `INFRA-43` | Observability: Define event naming constants and privacy rules | 🤖 AI Implementation | 0.5 | `INFRA-41` |
| 4 | `INFRA-44` | Observability: Wire initial beta-relevant app and feature events | 🤖 AI Implementation | 1 | `INFRA-42`, `INFRA-43` |
| 5 | `INFRA-45` | Observability: Add telemetry privacy regression tests | 🤖 AI Implementation | 0.75 | `INFRA-42`, `INFRA-43` |
| 6 | `INFRA-46` | Observability: Decide beta analytics and crash reporting vendors | 👤 Owner Action | 0.25 | `INFRA-41` |
