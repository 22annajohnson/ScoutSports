# Scout Feature Readiness Report

## Scope

This report audits the current repository state on `origin/develop` at commit `27641e4`. It evaluates implemented code, tests, CI, documentation, and planning artifacts. It does not create new tech plans, Jira tickets, or production code.

Status legend:

- 🔴 Not Started: no meaningful implementation in the repository.
- 🟡 Prototype: mock, local-only, partial, or planning-only implementation exists.
- 🟢 MVP: usable vertical slice exists, but production gaps remain.
- 🔵 Production Ready: feature is robust, tested, observable, and operationally ready.

## Executive Summary

Scout is currently an early iOS MVP foundation, not a full product MVP. The strongest implemented areas are authentication/session handling, onboarding/profile write paths, profile repository boundaries, Supabase client integration, CI documentation validation, and a polished ScoutDesign package. The visible app experience is mostly two authenticated tabs: Swipe and Feed. Both are visually strong but data-light: Swipe uses a mock card provider and local ranking, while Feed uses hard-coded preview posts.

Most social product domains are not implementation-ready yet. Events, Chat, Notifications, Search, Business Accounts, Advertising, Entitlements, Feature Flags, Experiments, Analytics, Crash Reporting, Dynamic Content, Persona Generator, and Admin/Internal Tools are either planning-only or absent. The main architectural blocker is that the app has Supabase-facing code before the repo has source-controlled migrations, generated types, RLS validation, staging/prod environment strategy, or an approved security foundation.

## Current Strengths

- Real SwiftUI app shell exists with auth gate, onboarding gate, and authenticated home routing.
- Supabase auth/profile/storage integration exists in production code.
- Profile repository boundaries separate editable profile, match signals, relationships, feedback, and derived metrics.
- Swipe and Feed UI are visually advanced enough to guide product direction.
- ScoutDesign is a real local Swift package with tokens, components, previews, and tests.
- CI is in place for iOS tests, Markdown validation, and GitHub Actions YAML validation.
- Approved foundation plans exist for architecture, design, profile, events, and discovery.

## Current Weaknesses

- No repository-owned database migrations, generated Supabase types, seed data, or local Supabase workflow.
- No real discovery, feed, event, chat, notification, or search backend.
- Onboarding completion is tracked locally via `AppStorage`, not as authoritative account/profile state.
- Swipe ranking and candidate data are mock/local despite approved guidance that ranking should be server-owned unless an ADR changes ownership.
- UI test coverage is template-level and does not validate real flows.
- Product-critical domains lack navigation entry points.
- No analytics, crash reporting, feature flag, experiment, entitlement, or admin operations layer.

## Biggest Architectural Risks

- **Schema drift risk:** iOS code references profile, photo, club, and feedback tables, but no migrations or generated types make that schema reviewable in Git.
- **Privacy/RLS risk:** profile/discovery/event/chat features depend on visibility, block, account status, and safety rules that are not implemented or validated.
- **Mock-to-production risk:** Swipe and Feed are polished enough to look close, but their data models are not backed by production contracts.
- **Cross-domain coupling risk:** ProfileRepository already carries profile, match-signal, relationship, feedback, and metrics behavior. This is acceptable for a small app but should split as domains become real.
- **Operational blind spot:** no crash reporting, analytics, logging, or admin tooling means production behavior would be difficult to diagnose.

## Highest Priority Missing Features

1. Repository-owned Supabase migrations, RLS, generated types, and local validation.
2. Authoritative profile readiness/completion state.
3. Profile visibility and contract enforcement.
4. Real Discovery candidate queue, decisions, exclusions, and match authority.
5. First real Events slice for getting users to actual play.
6. Notifications and Chat foundations for coordination after matches/events.
7. Analytics and crash reporting before meaningful beta distribution.

## Highest ROI Implementation Opportunities

- Convert profile schema/RLS from proposed planning into migrations and tests.
- Replace mock Swipe candidates with a narrow Discovery repository backed by approved Profile contracts.
- Wire profile builder/profile completion into the authenticated app flow.
- Add a shared loading state and finish ScoutDesign adoption for repeated low-risk UI patterns.
- Add basic analytics/crash reporting wrappers before feature growth creates retrofitting cost.
- Add UI tests for sign-in/onboarding/home navigation.

## Largest Sources of Technical Debt

- Source-controlled backend is not yet authoritative.
- App-level Supabase calls use string table/column names directly.
- Template tests remain in `ScoutTests.swift` and `ScoutUITests.swift`.
- Feature UI is ahead of data contracts in Swipe and Feed.
- Design system adoption is broad but uneven, especially loading states, chips, stat tiles, and modal/icon typography.
- Roadmaps still reference some outdated status language after recent CI/design/social PR work.

## Areas To Avoid Until Later

- Business Advertising before Events, Feed, and Analytics exist.
- Entitlements/payments before there is a paid feature surface.
- Experiments before feature flags and analytics are available.
- Advanced recommendation learning/ML before deterministic Discovery works.
- Persona Generator before Dynamic Content, Admin Tools, and safety review exist.
- Monorepo app moves from root `Scout/` into `apps/ios/` before a dedicated migration plan.

## Feature Readiness Matrix

| Domain | Status | Current Implementation | UI | Backend | Repository Layer | Models | Navigation | Tests | Main Blocker | Recommended Next Slice | Remaining Effort |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | ---: |
| Authentication | 🟢 MVP | Email/password sign-in, sign-up, sign-out, session loading via Supabase. | Login/signup views exist. | Supabase Auth only. | `AuthProviding`, `AuthService`, `SessionStore`. | `SessionUser`, `Profile`. | Root auth gate. | SessionStore unit tests. | No password reset, auth recovery, email verification UX, account lifecycle, or security policy. | Add auth recovery and account-state handling. | 8 |
| Onboarding | 🟡 Prototype | Multi-step name/age/location/sport/photo flow writes profile basics and photos. | Complete initial flow. | Profile update and storage upload calls. | Uses profile repository and image upload service. | Onboarding form only; limited domain model. | Root post-auth gate. | No direct onboarding tests. | Completion stored locally in `AppStorage`; no authoritative server readiness. | Persist onboarding/profile readiness and test root routing. | 8 |
| Profile | 🟢 MVP | Profile builder, profile writes, photos, clubs, match signals, derived metrics. | Rich builder exists. No public/owner profile home entry. | Supabase profile/photo/club/feedback reads and writes. | Strong but broad `ProfileRepository`. | Profile, public profile, match signals, metrics, feedback. | Not a main tab; builder can be constructed but is not first-class navigation. | DTO and builder save tests. | Schema/RLS not source-controlled; visibility contracts proposed only. | Implement approved profile schema/RLS and wire profile management surface. | 21 |
| Feed | 🟡 Prototype | Hard-coded preview posts and category filters. | Polished feed cards and collapsing header. | None. | None. | `FeedPreviewPost` mock model. | Home tab. | None. | No Feed domain plan, backend, contracts, or persistence. | Define/feed V1 source contracts and replace mocks with repository. | 13 |
| Swipe Deck | 🟡 Prototype | Mock candidates rendered as swipe cards with gesture/dock interactions. | Strong card/deck UI and match modal. | None for queue/decisions. | `SwipeCardProviding` with mock implementation. | Candidate/card/ranking context models. | Home tab. | Candidate-to-card projection test only. | Mock data; no authoritative queue, decisions, or exclusions. | Build Discovery V1 candidate queue and decision repository. | 21 |
| Recommendation Pipeline | 🟡 Prototype | Local mock ranking provider scores mock candidates. | No standalone UI. | None. | `SwipeRankingProviding` local abstraction. | Ranking context and prior interaction summary. | Consumed only by Swipe. | None. | Server-owned scoring not implemented; no candidate eligibility or learning contract. | Deterministic server/repository-owned candidate eligibility slice. | 21 |
| Matching | 🟡 Prototype | Match modal appears when a mock card has `didLike`. | Celebration modal exists. | Feedback table calls exist, but no match persistence. | No match repository. Feedback lives in profile repository. | `MatchView.Model`, feedback model. | Modal only from Swipe. | Feedback DTO mapping tests. | No match authority, idempotency, or chat/event handoff. | Implement match creation contract after decisions are persisted. | 13 |
| Events | 🔴 Not Started | Approved domain plan only. | None. | None. | None. | None in app. | None. | None. | Needs v1 event scope, lifecycle, schema/RLS, profile contracts. | Lightweight community game read/create/join plan then implementation. | 34 |
| Community | 🔴 Not Started | Represented conceptually through Events/Feed only. | None beyond mock feed content. | None. | None. | None. | None. | None. | Events and Feed are not real yet. | Defer until Events MVP and Feed source contracts exist. | 21 |
| Chat | 🔴 Not Started | Roadmap only; no canonical domain plan. | None. | None. | None. | None. | None. | None. | Needs Chat domain foundation, match/event relationship model, safety rules. | Match conversation foundation after match authority exists. | 34 |
| Notifications | 🔴 Not Started | Roadmap only. | None. | None. | None. | None. | None. | None. | Needs notification domain, permissions, delivery infra, privacy copy rules. | Notification foundation and in-app notification record model. | 21 |
| Search | 🔴 Not Started | Mentioned in profile/discovery docs only. | None. | None. | None. | None. | None. | None. | Depends on profile visibility and discovery contracts. | Defer until profile contracts and discovery queue exist. | 21 |
| Business Accounts | 🔴 Not Started | No code or roadmap domain. | None. | None. | None. | None. | None. | None. | Product model not defined. | Defer until core player/event/feed MVP. | 34 |
| Business Advertising | 🟡 Prototype | Mock sponsored feed posts only. | Sponsored cards in Feed mock. | None. | None. | Mock feed category. | Feed tab. | None. | No business account, ad inventory, targeting, compliance, or analytics. | Defer; keep mock cards as design reference only. | 34 |
| Entitlements | 🔴 Not Started | None. | None. | None. | None. | None. | None. | None. | No paid feature/product surface. | Defer until monetization strategy exists. | 21 |
| Feature Flags | 🔴 Not Started | No flag layer. | None. | None. | None. | None. | None. | None. | No config service or local gating standard. | Add simple local/remote-ready flag abstraction before beta rollout. | 8 |
| Experiments | 🔴 Not Started | None. | None. | None. | None. | None. | None. | None. | Requires analytics and feature flags. | Defer until analytics and flags exist. | 13 |
| Analytics | 🔴 Not Started | No analytics wrapper or events. | None. | None. | None. | None. | None. | None. | No event taxonomy, privacy rules, provider, or tests. | Add privacy-safe analytics abstraction and first core events. | 13 |
| Crash Reporting | 🔴 Not Started | None. | None. | None. | None. | None. | None. | None. | No provider or release/beta strategy. | Add crash reporting abstraction and provider setup before beta. | 8 |
| Dynamic Content | 🔴 Not Started | None beyond hard-coded feed/mock data. | None. | None. | None. | None. | None. | None. | Needs backend, admin, safety, and caching rules. | Defer; use static content until Feed/Admin foundations exist. | 21 |
| Persona Generator | 🔴 Not Started | None. | None. | None. | None. | None. | None. | None. | Requires dynamic content/admin/safety and likely AI policy. | Defer until product need is validated. | 34 |
| Admin / Internal Tools | 🔴 Not Started | No admin app/tooling. | None. | None. | None. | None. | None. | None. | No roles, service access model, moderation workflows, audit logs. | Add minimal internal diagnostics/admin plan after DB/security foundation. | 21 |
| Design Factory | 🔴 Not Started | Proposed plan exists; no in-app debug factory. | Package previews exist only. | None. | None. | None. | None. | ScoutDesign package tests. | Debug entry/access policy not implemented. | Build debug-only Design Factory shell and galleries. | 13 |
| ScoutDesign Adoption | 🟢 MVP | Local package with tokens/components and broad imports. | Broad adoption in active screens. | None. | Package boundary exists. | Design primitives only. | N/A. | Package tests. | Loading/chip/stat/modal patterns still fragmented. | Shared loading state plus chip/stat taxonomy. | 13 |
| Repository Layer | 🟡 Prototype | Auth/Profile/Storage/Swipe provider boundaries exist. | N/A. | Partial Supabase use. | Good start; ProfileRepository is too broad. | Mixed DTO/domain models. | N/A. | Some unit tests. | No generated types; many domains missing repositories. | Split by domain as persistence becomes real. | 21 |
| Supabase Integration | 🟡 Prototype | Client config, auth, profile, storage calls exist. | N/A. | Real Supabase dependency. | SupabaseProvider/config plus repositories. | DTOs are hand-written. | N/A. | Limited unit tests with mocks. | No migrations/types/local validation/staging/prod. | Approve and implement Supabase database foundation. | 21 |
| Database | 🔴 Not Started | Planning docs only in repo. | N/A. | Live schema implied but not source-controlled. | None for migrations. | Proposed schema docs. | N/A. | None. | No repo-owned schema, RLS tests, seed data, generated types. | First profile schema/RLS migration set. | 34 |
| CI/CD | 🟢 MVP | iOS tests, docs validation, YAML validation, PR template, CODEOWNERS, Dependabot docs. | N/A. | No deployment. | N/A. | N/A. | N/A. | CI runs tests/docs/YAML. | No release, migration, lint, coverage, accessibility, or localization validation. | Add migration validation after DB foundation; add build/lint coverage later. | 13 |
| Testing | 🟡 Prototype | Unit tests for session/profile mapping/profile builder; template UI tests. | N/A. | No integration tests. | Mocks exist. | Test fixtures/mocks exist. | N/A. | Narrow coverage. | No meaningful UI flows, no repository integration/RLS tests. | Add smoke UI tests and repository contract tests. | 13 |
| Accessibility | 🔴 Not Started | Relies on SwiftUI defaults; no explicit audit. | No accessibility test coverage. | N/A. | N/A. | N/A. | N/A. | None. | No Dynamic Type/VoiceOver/reduced motion validation. | Accessibility audit of auth/onboarding/home/swipe/feed. | 13 |
| Localization | 🔴 Not Started | Hard-coded English strings. | English only. | N/A. | N/A. | N/A. | N/A. | None. | No string catalog or localization process. | Defer until product copy stabilizes; then add string catalog. | 13 |

## Domain Notes

### Authentication

Current status is MVP because users can sign in, sign up, sign out, and load an existing Supabase session. The missing production pieces are recovery flows, email verification UX, account deletion/deactivation, account status modeling, and security-state handling. The repository layer is sound for the current scope.

### Onboarding

Onboarding is visually and functionally useful but remains prototype-grade because completion is local to a device/user ID string. It must become server-driven profile readiness before Discovery, Events, or Chat rely on it.

### Profile

Profile is the most advanced domain implementation. The code already anticipates user-owned profile fields, match signals, clubs, photos, raw feedback, and derived metrics. The main issue is not UI or model absence; it is that the backend contract is not yet authoritative in the repo.

### Feed

Feed is a visual prototype. It should not be expanded with more mock content until the Feed domain boundary and V1 content strategy are approved. The fastest useful path is a small repository-backed feed that consumes Profile/Event/Discovery contracts.

### Swipe Deck and Recommendation Pipeline

Swipe has strong UI and interaction investment. The next architectural step is to replace the mock provider with a Discovery boundary that owns candidate eligibility, queue ordering, decisions, and exclusions. Avoid adding advanced ranking until deterministic eligibility and privacy work.

### Events and Community

Events are central to Scout's product goal but have no app implementation. The approved domain plan is strong; the next work should be a small community-game slice, not broad organizer tooling.

### Chat and Notifications

Both are product-critical but should not be implemented opportunistically inside Match or Events. Each needs a domain boundary first because both carry privacy, safety, and delivery implications.

### Business, Advertising, Entitlements

These should remain later-stage. Mock sponsored feed cards can inform design, but there is no business account, entitlement, ad inventory, targeting, billing, reporting, or compliance foundation.

### Analytics, Crash Reporting, Flags

These are absent and should be added before a serious external beta. Analytics and flags should be privacy-conscious and small; crash reporting should arrive before distribution broadens.

### Repository, Supabase, Database

The app is ahead of the repository backend foundation. Before adding more Supabase-backed features, Scout should make migrations, RLS, generated types, and validation source-controlled. This is the highest-leverage architecture fix.

### Testing, Accessibility, Localization

Testing exists but is narrow. Accessibility and localization are effectively not started. Accessibility should be addressed earlier than localization because it affects core UI quality and can be validated without broad copy churn.

## Recommended Implementation Order

| # | Milestone | Description | Dependencies | SP | AI Suitable |
| ---: | --- | --- | --- | ---: | --- |
| 1 | Approve database foundation | Finalize migration, RLS, generated type, seed, and local Supabase workflow rules. | ARCH-001, current docs/database. | 5 | Yes |
| 2 | Implement repo-owned profile schema/RLS | Add first source-controlled profile/profile-photo/profile-sport style migrations and RLS validation. | Milestone 1, PROFILE-002/003 approval. | 13 | Yes, with review |
| 3 | Add generated type workflow | Generate and validate Supabase types or document why iOS remains hand-mapped temporarily. | Milestone 2. | 5 | Yes |
| 4 | Server-backed profile readiness | Replace local onboarding completion dependency with persisted readiness/completion state. | Milestone 2. | 8 | Yes |
| 5 | Wire profile management entry point | Add authenticated route/surface for viewing/editing own profile builder state. | Milestone 4, ScoutDesign patterns. | 8 | Yes |
| 6 | Add auth recovery/account state | Password reset, email verification handling, restricted/deleted account UX. | Milestone 2, security decisions. | 8 | Yes |
| 7 | Add smoke UI tests | Cover launch, login gate, onboarding route, and home tab navigation using test-safe config. | CI foundation. | 5 | Yes |
| 8 | Define and implement feature flag foundation | Minimal typed flag abstraction with local defaults and future remote-ready boundary. | App architecture foundation. | 5 | Yes |
| 9 | Add crash reporting wrapper | Provider-neutral crash reporting initialization and environment gating. | Milestone 8 preferred. | 5 | Yes |
| 10 | Add privacy-safe analytics wrapper | Provider-neutral event API, no sensitive payloads, first auth/onboarding/home events. | Milestone 8. | 8 | Yes |
| 11 | Implement shared loading state | Add ScoutDesign loading component and migrate repeated raw loading surfaces opportunistically. | ScoutDesign adoption plan. | 5 | Yes |
| 12 | Discovery V1 boundary approval | Approve or revise Discovery V1 plan, candidate contract, queue, decision, exclusion boundaries. | Profile contracts, DB foundation. | 5 | Yes |
| 13 | Discovery candidate repository | Replace mock card provider with repository-backed candidate query using approved profile contract. | Milestones 2, 12. | 13 | Yes, with review |
| 14 | Persist swipe decisions | Add decision persistence, idempotency, and queue exclusion behavior. | Milestone 13. | 13 | Yes, with review |
| 15 | Match authority slice | Create authoritative match creation from mutual interest with duplicate prevention. | Milestone 14. | 13 | Yes, with review |
| 16 | Match modal real actions | Wire match modal next actions to approved chat/event placeholder routes or safe disabled states. | Milestone 15. | 5 | Yes |
| 17 | Event V1 scope approval | Narrow community game scope, lifecycle, participant permissions, visibility/location rules. | EVENT-001, Profile visibility. | 8 | Yes |
| 18 | Event schema/RLS slice | Add event and participant persistence with visibility and organizer ownership policies. | Milestone 17, DB foundation. | 13 | Yes, with review |
| 19 | Event list/detail/create MVP | Build event card/list/detail/create/join flow with ScoutDesign components. | Milestone 18. | 21 | Yes, with review |
| 20 | Notifications domain foundation | Define notification contracts, permission boundaries, and delivery ownership. | Events/Match direction. | 5 | Yes |
| 21 | In-app notification record MVP | Add notification model/repository and simple in-app notification surface. | Milestone 20, DB foundation. | 13 | Yes |
| 22 | Chat domain foundation | Define match conversation scope, membership, safety, and message visibility. | Match authority, Profile contracts. | 5 | Yes |
| 23 | Match chat MVP | Add one-to-one match conversation persistence and UI. | Milestone 22, Notifications optional. | 21 | Yes, with review |
| 24 | Feed domain and V1 content strategy | Define feed ownership and replace mock-only assumptions with source contracts. | Profile, Discovery, Events. | 8 | Yes |
| 25 | Repository-backed feed MVP | Replace hard-coded posts with real profile/event/match-driven feed cards. | Milestone 24 plus event/discovery slices. | 21 | Yes, with review |

## MVP Path Summary

The shortest credible MVP path is:

1. Make backend state source-controlled and safe.
2. Finish profile readiness and profile contracts.
3. Convert Swipe from mock discovery to real candidate/decision/match persistence.
4. Add lightweight Events so matches can become real-world play.
5. Add Notifications and Chat only after match/event ownership is clear.
6. Convert Feed from visual prototype into a contract-backed activity surface.

This order preserves Scout's core product goal: help compatible people find each other and coordinate real-world sports, starting with the smallest safe implementation that respects privacy and reviewability.
