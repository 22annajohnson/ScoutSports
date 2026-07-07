# Approved Planning Backlog

Generated from approved Level 1 and Level 2 technical plans plus roadmap `Next` items.

## Important Scope Boundary

The approved foundation/domain plans authorize planning, contracts, documentation, and implementation-plan preparation. They do not authorize production code, schema, API, auth, storage, CI, or migration implementation unless a dedicated implementation tech plan is approved.

Stories below are Jira-ready planning and design work items. Code implementation stories should be generated only after the relevant item is promoted into `implementation/approved/`.

## Project Mapping

- `ARCH`: Architecture, ADRs, repository structure, planning governance.
- `INFRA`: Database, security, Supabase, CI/CD, environments, observability.
- `CORE`: Shared app foundations and cross-domain app infrastructure.
- `SOCIAL`: Profile, Discovery, Events, Feed, Chat, Notifications, and other user-facing social/product domains.

## Epic Index

| Epic | Project | Purpose | Depends On | Parallelizable |
| --- | --- | --- | --- | --- |
| ARCH: Foundation Governance | ARCH | Create architecture governance artifacts and ADR process. | ARCH-001 | Yes, with design documentation. |
| INFRA: Database Foundation | INFRA | Define database ownership, schema documentation, migrations, RLS, and generated type rules. | ARCH-001 | Yes, with security foundation. |
| INFRA: Security Foundation | INFRA | Define auth, privacy, RLS, storage, secrets, abuse, and data visibility principles. | ARCH-001, PROFILE-001, EVENT-001 | Yes, with database foundation. |
| SOCIAL: Player Identity V1 Planning | SOCIAL | Define v1 identity fields and visibility rules. | PROFILE-001, DESIGN-001, INFRA foundations | Partially. Field set and visibility can start in parallel. |
| SOCIAL: Discovery V1 Planning | SOCIAL | Define recommendation inputs and Candidate Card contract. | SWIPE-001, PROFILE-001 | Partially. Inputs before Candidate Card finalization. |
| SOCIAL: Events V1 Planning | SOCIAL | Define community game scope and lifecycle permissions. | EVENT-001, PROFILE-001, DESIGN-001 | Partially. Scope and lifecycle can start in parallel. |
| SOCIAL: Notifications Domain Planning | SOCIAL | Establish Notifications as its own domain. | ARCH-001, DESIGN-001, PROFILE-001 | Yes, after security foundation starts. |
| SOCIAL: Feed Domain Planning | SOCIAL | Define Feed domain boundaries and first content strategy. | ARCH-001, DESIGN-001, PROFILE-001 | Yes, after domain foundations. |
| SOCIAL: Chat Domain Planning | SOCIAL | Define Chat domain boundaries and match conversation scope. | ARCH-001, DESIGN-001, PROFILE-001 | Yes, after security foundation starts. |

---

# Epic: ARCH: Foundation Governance

Project: `ARCH`

Related tech plans: `ARCH-001`

Affected repo area: `Docs`

Goal: Ensure architecture changes, ADRs, planning hierarchy, and implementation ticket rules are explicit before implementation work scales.

## Story ARCH-FOUND-001: Create ADR Template

Story points: `0.5`

User story: As a planning agent, I want a reusable ADR template so architectural decisions are recorded consistently before implementation.

Problem being solved: ARCH-001 requires ADRs for changes to app structure, backend ownership, database architecture, auth strategy, shared packages, CI strategy, module boundaries, cross-platform contracts, and long-term technical direction, but no ADR template exists yet.

Scope:

- Create an ADR template under `docs/decisions/`.
- Include context, decision, options considered, consequences, affected repo areas, rollout implications, validation expectations, and status.
- Reference ARCH-001 authority and ADR requirements.

Explicitly out of scope:

- Writing actual ADRs.
- Approving architecture changes.
- Changing code, CI, schema, or project structure.

Dependencies: `ARCH-001`

Acceptance criteria:

- ADR template exists in `docs/decisions/`.
- Template includes all required ARCH-001 sections.
- Template explains when to use an ADR.
- README or decisions docs link to the template.

Testing requirements:

- Documentation review only.
- Confirm no production files changed.

Likely files/modules:

- `docs/decisions/`
- `docs/decisions/README.md`

Related ADRs: None.

Definition of Done:

- Template merged.
- Linked from decisions docs.
- Reviewer confirms it satisfies ARCH-001.

## Story ARCH-FOUND-002: Document Architecture Change Checklist

Story points: `0.5`

User story: As an implementation agent, I want a checklist that tells me whether work is architectural so I know when to stop for ADR approval.

Problem being solved: Agents need a practical review checklist based on ARCH-001 before creating implementation tickets.

Scope:

- Add a concise architecture change checklist to `docs/architecture/`.
- Include examples of architectural change versus feature implementation.
- Include required references for Jira stories.

Explicitly out of scope:

- Changing ARCH-001 substance.
- Creating implementation tickets.

Dependencies: `ARCH-001`, ADR template preferred.

Acceptance criteria:

- Checklist maps directly to ARCH-001 architecture-change triggers.
- Checklist is short enough to be used during ticket review.
- Checklist references affected repo areas: iOS, Web, Supabase, Docs, CI/CD.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `docs/architecture/`
- `docs/agents/AGENTS.md`

Related ADRs: None.

Definition of Done:

- Checklist merged.
- Agents can use it before implementation work.

Parallelization: Can run after or alongside `ARCH-FOUND-001`.

---

# Epic: INFRA: Database Foundation

Project: `INFRA`

Related tech plans: `ARCH-001`, `docs/database/DATABASE.md`, roadmap `INFRA-001`

Affected repo area: `Supabase`, `Docs`

Goal: Define database rules before Profile, Discovery, Events, Chat, Notifications, or Feed create schema-dependent implementation plans.

## Story INFRA-DB-001: Define Database Ownership Model

Story points: `0.5`

User story: As a backend planning agent, I want a database ownership model so domain plans know which system owns each table or contract before schema work begins.

Problem being solved: Profile, Discovery, Events, and Notifications all need persistence, but database ownership is not yet formalized.

Scope:

- Define ownership rules for domain tables, shared lookup tables, audit fields, storage metadata, and generated types.
- Document how ownership maps to Level 1 foundations and Level 2 domains.
- Add rules for consumers that read data but do not own it.

Explicitly out of scope:

- Creating tables.
- Writing SQL migrations.
- Choosing final schema.

Dependencies: `ARCH-001`, `DATABASE.md`

Acceptance criteria:

- Ownership model is documented.
- Document states that schema changes require approved implementation tech plans.
- Profile, Events, Discovery, Notifications, and Chat are named as future consumers.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `docs/database/DATABASE.md`
- `backend/supabase/README.md`
- `implementation/proposed/INFRA-001-database-foundation.md` if promoted.

Related ADRs: Required only if database architecture changes are proposed.

Definition of Done:

- Ownership model reviewed by planning owner.
- Downstream roadmap items can reference it.

## Story INFRA-DB-002: Define Migration Workflow

Story points: `0.5`

User story: As an implementation agent, I want a documented migration workflow so future schema work is reviewable and reversible.

Problem being solved: Future Supabase work needs naming, review, validation, rollback, and generated type expectations before migrations exist.

Scope:

- Define where migrations will live.
- Define naming conventions.
- Define review requirements.
- Define rollback or forward-fix guidance.
- Define when generated types must be updated.

Explicitly out of scope:

- Adding migration tooling.
- Creating any migration.
- Running Supabase commands.

Dependencies: `INFRA-DB-001`

Acceptance criteria:

- Migration workflow documented under database or backend docs.
- Workflow includes validation expectations.
- Workflow identifies approval gates for schema/RLS/storage.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `docs/database/DATABASE.md`
- `backend/supabase/README.md`

Related ADRs: Required if migration strategy changes architecture.

Definition of Done:

- Migration workflow merged.
- Future schema tickets can reference it.

## Story INFRA-DB-003: Define RLS Planning Requirements

Story points: `0.5`

User story: As a security-minded reviewer, I want every future table plan to define RLS rules before implementation.

Problem being solved: Profile visibility, event participation, chat, notifications, and discovery all depend on safe data access.

Scope:

- Define required RLS documentation fields: read, insert, update, delete, service role, owner, blocked/hidden/deleted states.
- Define review expectations for privacy-sensitive domains.
- Document that RLS implementation requires approved implementation plans.

Explicitly out of scope:

- Writing RLS policies.
- Testing policies against Supabase.

Dependencies: `INFRA-DB-001`, `INFRA-SEC-001`

Acceptance criteria:

- RLS planning checklist exists.
- Checklist is referenced from database docs.
- Checklist includes Profile, Events, Chat, Notifications, and Discovery examples.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `docs/database/DATABASE.md`
- `backend/supabase/README.md`

Related ADRs: None unless RLS ownership model changes.

Definition of Done:

- RLS checklist merged.
- Future implementation plans can copy the checklist.

Parallelization: `INFRA-DB-001` and `INFRA-SEC-001` can start together. `INFRA-DB-002` and `INFRA-DB-003` follow ownership/security framing.

---

# Epic: INFRA: Security Foundation

Project: `INFRA`

Related tech plans: `ARCH-001`, `PROFILE-001`, `EVENT-001`, roadmap `INFRA-002`

Affected repo area: `Supabase`, `Docs`

Goal: Define cross-domain security and privacy rules before implementation plans introduce private profile data, event visibility, chat safety, notifications, or storage.

## Story INFRA-SEC-001: Define Scout Security Principles

Story points: `0.5`

User story: As a product engineer, I want shared security principles so every domain handles privacy, visibility, and trust consistently.

Problem being solved: Security is currently distributed across domain concepts without a single foundation.

Scope:

- Document security principles for privacy defaults, visibility, blocked users, auth, RLS, storage, secrets, and abuse reporting.
- Reference Profile privacy, Event safety, Discovery exclusions, and future Chat/Notifications boundaries.

Explicitly out of scope:

- Implementing auth changes.
- Writing policies or code.
- Selecting third-party security tooling.

Dependencies: `ARCH-001`, `PROFILE-001`, `EVENT-001`, `SWIPE-001`

Acceptance criteria:

- Security foundation doc exists.
- Document defines approval gates for auth/RLS/storage/security changes.
- Document links to relevant domain plans.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `docs/architecture/`
- `docs/database/`
- `backend/supabase/`

Related ADRs: Required for auth strategy changes.

Definition of Done:

- Security principles merged.
- Downstream implementation plans reference them.

## Story INFRA-SEC-002: Define Blocked User and Visibility Rules Checklist

Story points: `0.5`

User story: As an AI coding agent, I want a checklist for blocked users and visibility so I do not accidentally expose users across domains.

Problem being solved: Profile, Discovery, Events, Chat, and Notifications all mention blocking/visibility but need a shared planning checklist.

Scope:

- Define a checklist for blocked users, hidden sports, discoverability, location precision, and notification leakage.
- Document required fields every implementation plan must answer.

Explicitly out of scope:

- Implementing block/report behavior.
- Defining final data model.

Dependencies: `INFRA-SEC-001`, `PROFILE-003`

Acceptance criteria:

- Checklist exists.
- Checklist maps to Profile visibility, Event safety, and Discovery exclusions.
- Future tickets can include it in acceptance criteria.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `docs/architecture/API_BOUNDARIES.md`
- `docs/database/DATABASE.md`
- `docs/agents/AGENTS.md`

Related ADRs: None.

Definition of Done:

- Checklist merged and linked.

---

# Epic: SOCIAL: Player Identity V1 Planning

Project: `SOCIAL`

Related tech plans: `PROFILE-001`, `DESIGN-001`, roadmap `PROFILE-002`, `PROFILE-003`

Affected repo area: `iOS`, `Supabase`, `Docs`

Goal: Define v1 profile fields and visibility rules before code, schema, storage, or UI implementation.

## Story PROFILE-V1-001: Define V1 Identity Field Set

Story points: `0.5`

User story: As a new Scout player, I want the minimum profile fields needed for discovery so I can start connecting without excessive setup.

Problem being solved: Consuming domains need a stable v1 profile field subset before Candidate Cards, Event Summaries, Chat headers, and Notifications can be implemented.

Scope:

- Define required, recommended, and optional v1 fields.
- Map fields to PROFILE-001 domains: Identity, Sports, Availability, Preferences, Social, Privacy, Reputation, System.
- State whether each field is owner-editable, system-owned, or future-only.

Explicitly out of scope:

- Adding fields to code.
- Creating schema.
- Updating UI.
- Upload/storage behavior.

Dependencies: `PROFILE-001`, `DESIGN-001`

Acceptance criteria:

- Field list exists and is mapped to PROFILE-001 domains.
- Each field has a clear purpose.
- Each field includes source of truth and visibility notes.
- Future-only fields are explicitly marked.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `docs/product/PRODUCT.md`
- `docs/database/DATABASE.md`

Related ADRs: None unless field ownership changes architecture.

Definition of Done:

- Plan moved to `implementation/approved/` after review.
- Jira Epic/Stories can be created for implementation only after approval.

## Story PROFILE-V1-002: Define Profile Visibility Matrix

Story points: `0.5`

User story: As a Scout player, I want my profile information shown only in appropriate contexts so I can feel safe using discovery, events, and chat.

Problem being solved: Privacy and visibility rules are blockers for Discovery, Events, Chat, Feed, and Notifications.

Scope:

- Define visibility by context: owner, pre-match, post-match, event participant, organizer, chat, feed, notification, public/future web.
- Define fallback behavior for missing or hidden fields.
- Identify fields that must never be exposed without explicit approval.

Explicitly out of scope:

- Implementing filtering.
- Changing RLS.
- Changing UI.

Dependencies: `PROFILE-001`, `INFRA-SEC-001`, `INFRA-SEC-002`

Acceptance criteria:

- Visibility matrix covers all v1 fields from `PROFILE-V1-001`.
- Matrix references PROFILE contracts.
- Matrix identifies downstream consumers affected by each visibility decision.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `implementation/proposed/PROFILE-003-profile-visibility-matrix.md`
- `docs/database/DATABASE.md`

Related ADRs: None unless privacy ownership changes architecture.

Definition of Done:

- Visibility matrix reviewed.
- Downstream planning can reference approved contexts.

Parallelization: `PROFILE-V1-001` and `PROFILE-V1-002` can start in parallel but should be reconciled before implementation tickets are created.

---

# Epic: SOCIAL: Discovery V1 Planning

Project: `SOCIAL`

Related tech plans: `SWIPE-001`, `PROFILE-001`, `DESIGN-001`, roadmap `SWIPE-002`, `SWIPE-003`

Affected repo area: `iOS`, `Supabase`, `Docs`

Goal: Define the first recommendation inputs and Candidate Card contract without implementing ranking, persistence, or UI.

## Story SWIPE-V1-001: Define V1 Recommendation Inputs

Story points: `0.5`

User story: As a Scout player, I want recommendations based on meaningful compatibility so I can find people I am likely to enjoy playing with.

Problem being solved: Discovery needs approved eligibility and ranking inputs before Candidate Cards, queues, decisions, or matches can be implemented.

Scope:

- Define v1 eligibility inputs.
- Define v1 ranking inputs.
- Separate required inputs from optional/future inputs.
- Identify privacy, blocking, and exclusion dependencies.

Explicitly out of scope:

- Implementing ranking.
- Creating service APIs.
- Persisting decisions.
- Building UI.

Dependencies: `SWIPE-001`, `PROFILE-002`, `PROFILE-003`, `INFRA-SEC-001`

Acceptance criteria:

- Inputs are mapped to Player Identity, Events, Reputation, Preferences, Exclusions, Availability, and Location where applicable.
- Inputs do not imply client-owned scoring.
- Exclusions override ranking.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `implementation/proposed/SWIPE-002-v1-recommendation-inputs.md`
- `roadmap/SWIPE.md`

Related ADRs: Required if client-owned scoring is proposed.

Definition of Done:

- Inputs reviewed and approved.
- Candidate Card contract can finalize against these inputs.

## Story SWIPE-V1-002: Define Candidate Card Contract

Story points: `0.5`

User story: As a Scout player, I want candidate cards to show enough sports context to make a decision without exposing private data.

Problem being solved: The swipe deck and future discovery surfaces need a stable presentation contract before UI implementation.

Scope:

- Define Candidate Card fields.
- Map each field to a Profile contract or recommendation context.
- Define missing-data fallback behavior.
- Define privacy and visibility constraints.

Explicitly out of scope:

- Building SwiftUI card UI.
- Creating models in code.
- Fetching data.

Dependencies: `SWIPE-001`, `PROFILE-002`, `PROFILE-003`, `DESIGN-001`

Acceptance criteria:

- Contract includes included/excluded fields.
- Contract references Profile visibility matrix.
- Contract identifies downstream consumers.
- Contract explicitly avoids dating-app-style assumptions per DESIGN-001.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `implementation/proposed/SWIPE-003-candidate-card-contract.md`
- `docs/design/DESIGN_SYSTEM.md`

Related ADRs: None.

Definition of Done:

- Contract approved.
- UI/model tickets may be generated only from approved implementation plan.

Parallelization: `SWIPE-V1-001` can begin after Profile visibility draft starts. `SWIPE-V1-002` should wait for field/visibility decisions to stabilize.

---

# Epic: SOCIAL: Events V1 Planning

Project: `SOCIAL`

Related tech plans: `EVENT-001`, `PROFILE-001`, `DESIGN-001`, roadmap `EVENT-002`, `EVENT-003`

Affected repo area: `iOS`, `Supabase`, `Docs`

Goal: Define the first real-world coordination scope and event lifecycle rules before schema, UI, or notification implementation.

## Story EVENT-V1-001: Define V1 Community Game Scope

Story points: `0.5`

User story: As a Scout player, I want a lightweight community game experience so I can find and join real-world play.

Problem being solved: Events need a narrow v1 scope that supports completed games without overbuilding organizer tooling.

Scope:

- Define v1 event type and supported use cases.
- Define what appears in Event Card and Event Detail at a planning level.
- Define join/request behavior conceptually.
- Define organizer responsibilities for v1.

Explicitly out of scope:

- Implementing event creation/join.
- Creating schema.
- Building UI.
- Notifications or chat implementation.

Dependencies: `EVENT-001`, `PROFILE-001`, `DESIGN-001`

Acceptance criteria:

- V1 scope is narrow and excludes tournaments, payments, recurring events, reservations.
- Scope maps to EVENT-001 lifecycle and contracts.
- Scope identifies dependencies on Profile and Notifications.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `implementation/proposed/EVENT-002-v1-community-game-scope.md`

Related ADRs: None unless event ownership changes.

Definition of Done:

- V1 scope approved.
- Lifecycle/permission story can finalize.

## Story EVENT-V1-002: Define Event Lifecycle and Participant Permissions

Story points: `0.5`

User story: As an organizer, I want clear lifecycle and participant rules so games remain viable and fair.

Problem being solved: Event lifecycle and participant state rules block safe joins, organizer tools, notifications, and event chat.

Scope:

- Define v1 lifecycle states.
- Define allowed transitions.
- Define organizer actions per state.
- Define participant actions per state.
- Define invalid transitions and fallback behavior.

Explicitly out of scope:

- Implementing enum/code.
- Persisting state.
- Writing RLS.

Dependencies: `EVENT-001`, `EVENT-V1-001`, `INFRA-SEC-001`

Acceptance criteria:

- Lifecycle table exists.
- Participant permission matrix exists.
- Organizer permissions are authoritative.
- Visibility and safety rules override convenience.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `implementation/proposed/EVENT-003-event-lifecycle-participant-permissions.md`

Related ADRs: Required if lifecycle ownership moves outside Events.

Definition of Done:

- Lifecycle/permission model approved.
- Schema and UI implementation tickets remain blocked until implementation plan approval.

Parallelization: `EVENT-V1-001` and `EVENT-V1-002` can draft in parallel but must reconcile before implementation.

---

# Epic: SOCIAL: Notifications Domain Planning

Project: `SOCIAL`

Related tech plans: `ARCH-001`, `DESIGN-001`, `PROFILE-001`, `EVENT-001`, `SWIPE-001`, roadmap `NOTIFICATIONS-001`

Affected repo area: `iOS`, `Supabase`, `Docs`

Goal: Establish Notifications as its own domain before Events, Chat, Discovery, or Feed create notification behavior.

## Story NOTIF-DOMAIN-001: Draft Notifications Domain Plan

Story points: `0.5`

User story: As a Scout player, I want notifications to be timely, safe, and useful so they help me show up and coordinate without leaking sensitive information.

Problem being solved: Notifications are currently dependencies across domains but do not have a canonical domain plan.

Scope:

- Create `NOTIFICATIONS-001` using the domain tech plan template.
- Define philosophy, conceptual model, lifecycle, ownership, contracts, consumers, AI rules, and future extensions.
- Reference Events, Discovery, Chat, Profile, and Infra dependencies.

Explicitly out of scope:

- Implementing push notifications.
- Selecting notification provider.
- Writing delivery infrastructure.

Dependencies: `ARCH-001`, `DESIGN-001`, `PROFILE-001`, `INFRA-SEC-001`

Acceptance criteria:

- Domain plan exists in `tech-plans/proposed/` or `implementation/proposed/` per planning decision.
- Plan defines notification contracts and privacy rules.
- Plan separates domain rules from delivery infrastructure.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `tech-plans/proposed/NOTIFICATIONS-001-notifications-domain.md`
- `roadmap/NOTIFICATIONS.md`

Related ADRs: Required if notification delivery architecture is decided.

Definition of Done:

- Plan drafted and reviewed.
- Can be approved or revised before implementation tickets are created.

---

# Epic: SOCIAL: Feed Domain Planning

Project: `SOCIAL`

Related tech plans: `ARCH-001`, `DESIGN-001`, `PROFILE-001`, `EVENT-001`, `SWIPE-001`, roadmap `FEED-001`

Affected repo area: `iOS`, `Docs`

Goal: Define Feed as a domain before expanding feed implementation.

## Story FEED-DOMAIN-001: Draft Feed Domain Plan

Story points: `0.5`

User story: As a Scout player, I want Feed to show useful play opportunities without becoming a generic social feed.

Problem being solved: Feed risks becoming a catch-all surface unless its ownership, contracts, and consumers are defined.

Scope:

- Create `FEED-001` using the domain tech plan template.
- Define philosophy, conceptual model, ownership, contracts, consumers, lifecycle if applicable, AI rules, and future extensions.
- Reference Profile, Events, Discovery, Notifications, and Design dependencies.

Explicitly out of scope:

- Implementing feed cards.
- Changing existing Feed code.
- Defining ranking algorithms in code.

Dependencies: `ARCH-001`, `DESIGN-001`, `PROFILE-001`, `EVENT-001`, `SWIPE-001`

Acceptance criteria:

- Feed domain plan draft exists.
- Plan defines what Feed owns versus consumes.
- Plan states Feed must not duplicate Discovery ranking logic.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `tech-plans/proposed/FEED-001-feed-domain-foundation.md`
- `roadmap/FEED.md`

Related ADRs: None unless Feed ownership changes architecture.

Definition of Done:

- Plan reviewed and ready for approval.
---

# Epic: SOCIAL: Chat Domain Planning

Project: `SOCIAL`

Related tech plans: `ARCH-001`, `DESIGN-001`, `PROFILE-001`, `SWIPE-001`, `EVENT-001`, roadmap `CHAT-001`

Affected repo area: `iOS`, `Supabase`, `Docs`

Goal: Define Chat as a domain before match or event conversations are implemented.

## Story CHAT-DOMAIN-001: Draft Chat Domain Plan

Story points: `0.5`

User story: As a Scout player, I want chat to help me coordinate real-world play safely after a match or event connection.

Problem being solved: Chat touches safety, privacy, Profile, Events, Discovery, and Notifications but has no canonical domain plan.

Scope:

- Create `CHAT-001` using the domain tech plan template.
- Define philosophy, conceptual model, lifecycle, ownership, contracts, consumers, AI rules, and future extensions.
- Define relationship to Match Conversation and Event Chat future plans.

Explicitly out of scope:

- Implementing messaging UI.
- Creating message schema.
- Push notification behavior.
- Moderation implementation.

Dependencies: `ARCH-001`, `DESIGN-001`, `PROFILE-001`, `INFRA-SEC-001`

Acceptance criteria:

- Chat domain plan draft exists.
- Plan defines safety and privacy boundaries.
- Plan defines Chat ownership versus Profile/Event/Notification consumption.

Testing requirements:

- Documentation review only.

Likely files/modules:

- `tech-plans/proposed/CHAT-001-chat-domain-foundation.md`
- `roadmap/CHAT.md`

Related ADRs: Required if message storage or delivery architecture is decided.

Definition of Done:

- Plan reviewed and ready for approval.
