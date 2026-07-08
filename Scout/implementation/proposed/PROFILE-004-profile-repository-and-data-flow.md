# Implementation Tech Plan: Profile Repository and Data Flow

## Status

Proposed

## Owner

TODO

## Product Domain

PROFILE

## Jira Project

SOCIAL

## Work Type

Implementation-readiness plan. This document authorizes Jira planning only while status is `Proposed`.

## Source of Truth

This plan builds on the approved Player Identity domain and the proposed v1 field/schema plans. It does not redefine Player Identity, profile fields, schema, RLS, storage, or UI requirements.

Authoritative inputs:

- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`
- `implementation/proposed/INFRA-001-database-foundation.md`
- `docs/architecture/API_BOUNDARIES.md`
- `docs/database/DATABASE.md`
- `docs/database/RLS.md`
- `AGENTS.md`

This plan must not be implemented until `PROFILE-002`, `PROFILE-003`, `INFRA-001`, and this plan are approved.

## Problem Statement

Scout needs a stable Profile repository boundary before iOS screens, onboarding, discovery, events, and chat consume profile data. The repository layer should isolate Supabase implementation details, generated database types, RLS-aware query behavior, caching, validation, and error mapping from SwiftUI views and feature view models.

Without an explicit repository plan, future agents may bind ViewModels directly to generated Supabase rows, duplicate mapping logic, leak private fields, or create parallel profile data access patterns that are difficult to test.

## Goals

- Define the Profile repository responsibilities for v1.
- Keep generated Supabase types out of SwiftUI and domain-facing ViewModels.
- Define mapping between database DTOs, repository DTOs, and domain models.
- Define read/update flows for owner profile state and approved profile contracts.
- Define caching, loading, validation, and error-handling expectations.
- Define dependency injection through `AppEnvironment` or the current app environment pattern.
- Define protocol and mock requirements so implementation agents can test Profile ViewModels without Supabase.
- Prepare small, independently reviewable Jira stories for implementation.

## Non-goals

- Writing production code in this planning PR.
- Creating Supabase tables, migrations, buckets, RLS policies, or generated types.
- Finalizing schema choices not approved by `PROFILE-003`.
- Implementing profile UI changes.
- Implementing profile media upload.
- Implementing Discovery, Events, Chat, Feed, Search, or Notification consumers.
- Moving files, packages, Xcode references, or project structure.
- Creating shared packages beyond documenting future ownership.

## Current Repository Context

Current iOS production code remains in the existing app location. Agents must inspect existing files before implementation, especially:

- `Scout/Scout/App/`
- `Scout/Scout/Profile/`
- `Scout/Scout/Data/Profiles/`
- `Scout/Scout/Domain/`
- `Scout/Scout/Shared/`

Exact type and file names must be verified by the implementation agent before editing. This plan defines architecture and workflow, not final file paths.

## Repository Responsibilities

The Profile repository should own:

- Fetching the authenticated user's editable profile.
- Fetching approved profile summaries/contracts when needed by Profile-owned flows.
- Updating owner-editable profile fields through approved write methods.
- Translating Supabase/database errors into app-level errors.
- Mapping generated/database representations into domain models.
- Applying client-side validation before write attempts where appropriate.
- Representing loading, empty/missing, stale, saved, and failed states to ViewModels.
- Coordinating lightweight in-memory cache behavior.
- Exposing testable protocols and mock repositories.

The Profile repository must not own:

- Auth session ownership.
- Raw schema definitions.
- RLS policy enforcement as a substitute for database policies.
- Discovery recommendation ranking.
- Event participant state.
- Chat participant visibility.
- Media upload unless a later media storage plan explicitly expands the repository.
- UI presentation, navigation, copy, or component styling.

## Separation Between Generated Types and Domain Models

Generated Supabase types are database-adjacent implementation details. They should not be consumed directly by SwiftUI views or Profile ViewModels.

Approved layering:

```text
Supabase generated types / query rows
  -> Data-layer DTOs and mappers
  -> ProfileRepository protocol
  -> Domain models / profile contracts
  -> ViewModels
  -> SwiftUI views
```

Rules:

- Generated types may appear in data-layer implementation files only.
- Domain models should use product language from `PROFILE-001` and `PROFILE-002`, not table-specific naming when avoidable.
- ViewModels should depend on repository protocols and domain models/contracts.
- Mapping code should be centralized and tested.
- If schema-generated types are deferred, repository implementation should still preserve the boundary by using explicit DTOs rather than leaking raw Supabase response shapes.

## Mapping Strategy

Mapping should be explicit and directional:

- `ProfileRow` or generated table row -> internal data DTO.
- Data DTO -> `EditableProfile` or equivalent owner-facing domain model.
- Data DTO -> approved contract models such as `SwipeProfileSummary`, `EventProfileSummary`, or `ChatProfileSummary` only after those contracts are approved.
- Domain update command -> validation result -> repository update DTO -> Supabase update payload.

Mapping rules:

- Optional fields must remain optional unless `PROFILE-002` makes them required.
- System-owned fields must not be writable through owner update commands.
- Privacy-related fields must default toward non-exposure.
- Missing optional media should produce safe placeholders at the domain/UI layer, not invalid repository state.
- Mapping failures should surface as typed repository errors with enough context for logging and user recovery.

## Read Flows

### Owner Editable Profile

```text
ViewModel requests current profile
  -> ProfileRepository checks in-memory cache
  -> repository fetches Supabase data if cache is empty/stale/forced
  -> repository maps data rows into owner editable domain model
  -> ViewModel renders loading, loaded, empty setup, or error state
```

Expected behaviors:

- A signed-in user with no profile should produce an explicit setup-needed state, not a generic failure.
- A signed-out user should return an authentication-required error from the repository boundary.
- RLS-denied owner reads should surface as a permission/configuration error for debugging.

### Profile Contract Reads

Profile contract reads should be implemented only after the relevant contract plan is approved. When added, consumers should request the narrowest approved contract.

Example future methods:

- `profileSummaryForDiscovery(profileID:)`
- `profileSummaryForEvent(profileID:eventContext:)`
- `profileSummaryForChat(profileID:conversationContext:)`

These names are illustrative; implementation should match approved contracts.

## Update Flows

Owner updates should use command-like methods rather than allowing arbitrary row mutation.

Example conceptual commands:

- Update identity fields.
- Update sports and primary sport.
- Update availability/preferences.
- Update privacy/discoverability settings.
- Update derived readiness only through system-approved behavior, not direct owner edits.

Expected update flow:

```text
ViewModel validates local form shape
  -> ProfileRepository validates command against PROFILE-002 rules
  -> repository maps command to allowed update payload
  -> Supabase write occurs under RLS
  -> repository refetches or merges saved state
  -> cache updates
  -> ViewModel renders saved or recoverable error state
```

Rules:

- Partial updates must not clear unrelated optional fields accidentally.
- Failed saves must preserve unsaved user input in the ViewModel.
- Repository should expose enough error information for UI recovery without exposing database internals.
- Updates that touch multiple profile tables require a transaction/RPC decision in `PROFILE-003` or a later approved plan before implementation.

## Caching Strategy

V1 should use a simple repository-owned in-memory cache for the authenticated user's editable profile.

Cache expectations:

- Cache only safe owner profile state in memory.
- Invalidate after successful writes.
- Allow force refresh.
- Avoid persistent offline cache in v1 unless separately approved.
- Do not cache broad non-owner profile summaries beyond a focused consumer plan.
- Keep cache behavior observable in tests.

Cache non-goals:

- Durable offline profile editing.
- Conflict resolution between devices.
- Background sync.
- Cross-user profile summary cache.

## Error Handling

The repository should translate low-level failures into typed app errors.

Recommended categories:

- `notAuthenticated`
- `profileMissing`
- `permissionDenied`
- `validationFailed`
- `networkUnavailable`
- `serverUnavailable`
- `decodingFailed`
- `mappingFailed`
- `conflictOrStaleWrite`
- `unknown`

Rules:

- ViewModels should not inspect Supabase error strings directly.
- Errors should support user-facing recovery decisions.
- Debug logs may include technical context, but UI-safe errors should not leak SQL, policy, or private details.
- Permission/RLS failures should be easy for developers to distinguish from user validation failures.

## Loading States

The repository should expose async operations and allow ViewModels to own presentation state.

ViewModels should be able to represent:

- Idle.
- Loading initial profile.
- Refreshing profile.
- Saving.
- Saved.
- Empty/setup-needed.
- Validation error.
- Network/server error.
- Permission/configuration error.

The repository should not own SwiftUI presentation state. It should return values and typed errors that ViewModels convert into UI state.

## Offline Considerations

Offline editing is future work.

V1 behavior:

- Reads may show cached owner profile if already loaded during the session.
- Writes should fail with a recoverable network error when offline.
- ViewModels should preserve unsaved form input after failed saves.
- No persistent offline queue is approved.

Future work may add:

- Persistent local profile cache.
- Offline edit drafts.
- Conflict detection and merge prompts.
- Background sync.

## Dependency Injection

Profile repository dependencies should be injected through the app's environment pattern, likely `AppEnvironment` or the current equivalent after implementation inspection.

Expected dependencies:

- Supabase client or data service abstraction.
- Auth/session provider.
- Logger/diagnostics abstraction if available.
- Clock/date provider where timestamps or cache age matter.
- Feature flags only if already established.

Rules:

- ViewModels should receive a protocol, not instantiate the concrete Supabase repository.
- Preview and tests should use mock repositories.
- The concrete repository should be created near app composition/root environment wiring.
- Do not introduce a new dependency container if the current app already has a suitable environment pattern.

## Repository Protocols

The protocol should be small and use-case oriented.

Conceptual shape:

```swift
protocol ProfileRepository {
    func currentEditableProfile(forceRefresh: Bool) async throws -> EditableProfileState
    func updateIdentity(_ command: UpdateProfileIdentityCommand) async throws -> EditableProfile
    func updateSports(_ command: UpdateProfileSportsCommand) async throws -> EditableProfile
    func updateAvailability(_ command: UpdateProfileAvailabilityCommand) async throws -> EditableProfile
    func updatePrivacy(_ command: UpdateProfilePrivacyCommand) async throws -> EditableProfile
}
```

This is illustrative only. Final names and method grouping should follow existing app conventions.

Protocol rules:

- Prefer use-case methods over generic `updateProfile(Dictionary)`.
- Keep owner-editable profile methods separate from consumer contract reads.
- Avoid exposing generated Supabase types.
- Keep methods async and testable.
- If existing repository protocols already exist, extend them carefully rather than creating a parallel pattern.

## Mock Repositories for Testing

Mock/fake repositories should support:

- Successful current profile load.
- Missing profile/setup-needed state.
- Validation failure.
- Network/server failure.
- Permission failure.
- Save success.
- Save failure that preserves ViewModel form state.
- Cache refresh behavior where relevant.

Mock rules:

- Mocks should return domain models/contracts, not generated database rows.
- Mocks should be usable by ViewModel tests and SwiftUI previews.
- Mocks should avoid hidden global state.

## Future Package Ownership

V1 repository code should remain in the current app/data layer unless an approved architecture plan moves it.

Future extraction candidates:

- Profile domain models.
- Repository protocols.
- Shared data-layer mapping utilities.
- Contract models consumed by iOS and future web.

Extraction requires an ADR if it changes shared package ownership, module boundaries, backend ownership, or public API strategy.

## Interaction With AppEnvironment

Implementation should:

- Add the concrete Profile repository to the app environment composition root.
- Provide a mock/default repository for previews and tests.
- Avoid creating repository instances directly inside SwiftUI views.
- Preserve existing app startup/auth flow.
- Avoid moving app environment files unless a separate architecture plan approves it.

## Interaction With Profile ViewModels

Profile ViewModels should:

- Depend on `ProfileRepository` protocol.
- Own form state and presentation state.
- Call repository methods for reads/writes.
- Preserve unsaved input on save failure.
- Convert repository errors into UI-safe messages and recovery actions.
- Avoid direct Supabase calls.
- Avoid generated type imports.

## Validation Strategy

Validation should be layered:

- Domain validation: required fields, lengths, option membership, readiness rules from `PROFILE-002`.
- Repository validation: update command allowed fields, mapping completeness, generated/database shape compatibility.
- Supabase validation: constraints and RLS from `PROFILE-003`.
- ViewModel validation: form affordances and immediate user feedback.

V1 implementation should avoid duplicating business validation in unrelated features. Shared validation helpers may be introduced only when reuse is clear and local patterns support it.

## Rollout Strategy

1. Approve `PROFILE-002`, `PROFILE-003`, `INFRA-001`, and this plan.
2. Implement domain/update command models without Supabase dependency.
3. Add repository protocol and mock repository.
4. Add mapping layer and mapping tests.
5. Implement concrete Supabase repository behind the protocol.
6. Wire repository into the app environment.
7. Update Profile ViewModels one surface at a time.
8. Add contract reads only after contract-specific plans are approved.

## Risks

| Risk | Mitigation |
| --- | --- |
| ViewModels accidentally depend on generated Supabase types. | Enforce repository protocol and mapper boundaries in code review. |
| Repository becomes a generic catch-all for every profile consumer. | Keep owner-editable methods separate from approved contracts. |
| RLS behavior is assumed rather than tested. | Require owner/non-owner validation in profile schema/RLS stories. |
| Partial updates clear unrelated fields. | Use command-specific payloads and mapping tests. |
| AppEnvironment changes create broad merge conflicts. | Keep environment wiring minimal and in one story. |
| Offline expectations exceed v1. | Explicitly keep durable offline editing deferred. |
| Future web needs different contracts. | Keep domain/contracts stable and avoid iOS-specific generated type leakage. |

## Jira Backlog

Create one Epic:

- `SOCIAL: Profile Repository and Data Flow`

### Stories

| Order | Story | Work Type | Points | Dependencies | Repository Area |
| --- | --- | --- | ---: | --- | --- |
| 1 | Define Profile domain models and update commands | 🤖 AI Implementation | 0.75 | PROFILE-002 approval | iOS |
| 2 | Add ProfileRepository protocol and mock repository | 🤖 AI Implementation | 0.75 | Story 1 | iOS |
| 3 | Add profile mapping layer and mapper tests | 🤖 AI Implementation | 1 | Story 1, PROFILE-003 approval | iOS, Supabase |
| 4 | Implement concrete Supabase ProfileRepository | 🤖 AI Implementation | 1.5 | Stories 2-3, approved schema/RLS | iOS, Supabase |
| 5 | Wire ProfileRepository through AppEnvironment | 🤖 AI Implementation | 0.5 | Story 4 | iOS |
| 6 | Update Profile ViewModels to consume repository protocol | 🤖 AI Implementation | 1 | Stories 2 and 5 | iOS |
| 7 | Add repository error/loading state validation | 🤖 AI Implementation | 0.75 | Stories 2-6 | iOS |
| 8 | Review repository boundary and future package ownership | 🤝 Shared | 0.5 | Stories 1-7 | Docs, iOS |

Do not create implementation work from these stories until this plan is approved.

## Testing Strategy

Future implementation PRs should include:

- Unit tests for mapping optional/required fields.
- Unit tests for update command validation.
- Unit tests for repository mock behavior.
- ViewModel tests for loading, success, missing profile, validation failure, save failure, and retry.
- Manual or automated Supabase validation for owner read/write and RLS-denied paths after schema/RLS is approved.
- No SwiftUI screenshots unless a story changes visible UI.

## Definition of Done

- Repository responsibilities and non-responsibilities are clear.
- Generated Supabase types are isolated from domain models and ViewModels.
- Mapping, read/update flows, cache behavior, error handling, loading states, and offline boundaries are documented.
- Dependency injection and `AppEnvironment` interaction are defined.
- Repository protocols and mock expectations are defined.
- Jira epic and stories are created with Scout story points and work-type labels.
- No production code, schema, migration, generated type, storage, Xcode, or app behavior changes are made by this planning PR.
