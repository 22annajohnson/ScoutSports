# Recommended Implementation Roadmap

Generated from `ROADMAP.md`, `roadmap/DEPENDENCIES.md`, and approved Level 1/2 plans.

## Phase 1 — Foundation

Goal: Establish the rules required before implementation tech plans introduce schema, privacy-sensitive data, or cross-domain contracts.

### Required Sequence

1. `ARCH: Foundation Governance`
2. `INFRA: Database Foundation`
3. `INFRA: Security Foundation`
4. `SOCIAL: Player Identity V1 Planning`

### Parallelizable Work

- `ARCH-FOUND-001` and `ARCH-FOUND-002`
- `INFRA-DB-001` and `INFRA-SEC-001`
- `PROFILE-V1-001` and `PROFILE-V1-002`, once Infra planning has started

### Critical Path

`ARCH-001` → `INFRA-001/INFRA-002` → `PROFILE-002/PROFILE-003`

### Major Milestones

- ADR template exists.
- Database ownership and migration workflow are defined.
- Security/visibility checklist exists.
- V1 identity fields and visibility matrix are approved.

## Phase 2 — Core Product

Goal: Define first usable Discovery and Events implementation plans without creating premature code tickets.

### Required Sequence

1. `SOCIAL: Discovery V1 Planning`
2. `SOCIAL: Events V1 Planning`
3. `SOCIAL: Notifications Domain Planning`
4. `SOCIAL: Chat Domain Planning`

### Parallelizable Work

- `SWIPE-V1-001` and `EVENT-V1-001` can draft in parallel once Profile field/visibility planning is underway.
- `EVENT-V1-002` can draft alongside `EVENT-V1-001`.
- `NOTIF-DOMAIN-001` can start after Security Foundation begins.
- `CHAT-DOMAIN-001` can start after Security Foundation begins.

### Critical Path

`PROFILE-003` → `SWIPE-003` and `EVENT-003` → `NOTIFICATIONS-001` → `CHAT-001`

### Major Milestones

- V1 recommendation inputs approved.
- Candidate Card contract approved.
- V1 community game scope approved.
- Event lifecycle and participant permissions approved.
- Notifications domain defined.
- Chat domain defined.

## Phase 3 — Polish

Goal: Prepare user-facing refinement plans after core contracts are approved.

### Required Sequence

1. Profile media and completion scoring.
2. Event visibility and location precision.
3. Empty deck recovery.
4. Feed domain and content strategy.

### Parallelizable Work

- Profile media planning and Profile completion scoring.
- Event notification contracts and Match notification scope.
- Feed domain planning after Profile/Event/Discovery foundations are accepted.

### Critical Path

`PROFILE-003` → `EVENT-004` / `SWIPE-006` / `FEED-001`

### Major Milestones

- Profile media rules approved.
- Profile completion scoring approved.
- Event visibility/location precision approved.
- Feed domain plan approved.

## Phase 4 — Intelligence & Scale

Goal: Add advanced recommendation, reputation, organizer, and operational capabilities after the core product loop is working.

### Required Sequence

1. Discovery learning and repeat-player weighting.
2. Reputation surfaces and attendance signals.
3. Organizer dashboard.
4. Infrastructure observability and generated type strategy.

### Parallelizable Work

- Observability foundation can proceed independently after database/security foundations.
- Reputation and attendance planning can proceed once Events and Profile contracts exist.
- Organizer dashboard planning can proceed after event lifecycle permissions are stable.

### Critical Path

`EVENT-007` + `PROFILE-007` + `SWIPE-IDEA-001`

### Major Milestones

- Recommendation learning proposal approved.
- Reputation/attendance model approved.
- Organizer dashboard implementation plan approved.
- Observability plan approved.

## AI-Agent Parallelization Guidance

To minimize merge conflicts:

- Keep planning tickets scoped to one document or one domain.
- Avoid having multiple agents edit the same roadmap file simultaneously.
- Separate contract-definition tickets from implementation tickets.
- Separate docs updates from iOS code changes.
- Do not let feature tickets redefine domain concepts.
- Generate code implementation tickets only from `implementation/approved/` plans.

## Current Jira Creation Blocker

Direct Jira issue creation is blocked until Atlassian grants the MCP token access to cloud `8f72ed51-951e-45b5-a9b4-93c2678a5c67`.

Once access is granted:

1. Search existing epics by summary.
2. Create missing epics.
3. Create stories in dependency order.
4. Link blocking relationships where supported.
5. Update roadmap item statuses to `🟪 Jira Planned`.
