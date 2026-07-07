# Scout Roadmap Dashboard

This is the executive dashboard for Scout planning.

Use this page first to understand overall project health, current focus, and next milestones. Domain-specific details live under `roadmap/`.

## Status Legends

Active domain health:

- 🟢 Complete: Foundation or capability is implemented and stable.
- 🟡 In Progress: Currently being implemented.
- 🔵 Ready Next: Planned next implementation after current work.
- ⚪ Planned: Planned but not yet scheduled.
- 💡 Ideas: Future ideas that have not yet been prioritized.

Roadmap item status:

- 🟦 Not Started
- 🟨 Drafting Tech Plan
- 🟧 Tech Plan Approved
- 🟪 Jira Planned
- 🟥 In Development
- 🟩 Complete

## Executive Summary

Scout's planning foundation is moving from static tech plans into a living roadmap system. Foundations for architecture, design, player identity, real-world coordination, and discovery are defined. The next phase is to promote the highest-priority roadmap items into detailed implementation tech plans only when work is imminent.

## Domain Dashboard

| Domain | Health | Overall Maturity | Current Focus | Next Milestone | Roadmap |
| --- | --- | --- | --- | --- | --- |
| Infrastructure | 🔵 Ready Next | Foundation docs exist; database and security foundations still needed. | Database and security planning. | `INFRA-001` Database Foundation | [INFRA](roadmap/INFRA.md) |
| Profile | 🔵 Ready Next | Player Identity foundation approved. | V1 identity field set and visibility matrix. | `PROFILE-002` V1 Identity Field Set | [PROFILE](roadmap/PROFILE.md) |
| Discovery | 🔵 Ready Next | Discovery & Recommendation foundation approved. | V1 recommendation inputs and Candidate Card contract. | `SWIPE-002` V1 Recommendation Inputs | [SWIPE](roadmap/SWIPE.md) |
| Events | 🔵 Ready Next | Real-World Coordination foundation approved. | V1 community game scope and lifecycle permissions. | `EVENT-002` V1 Community Game Scope | [EVENT](roadmap/EVENT.md) |
| Feed | ⚪ Planned | Initial iOS feature area exists; no canonical domain plan yet. | Define Feed domain foundation. | `FEED-001` Feed Domain Foundation | [FEED](roadmap/FEED.md) |
| Chat | ⚪ Planned | No canonical domain plan yet. | Define Chat domain foundation. | `CHAT-001` Chat Domain Foundation | [CHAT](roadmap/CHAT.md) |
| Notifications | ⚪ Planned | No canonical domain plan yet. | Define Notifications domain foundation. | `NOTIFICATIONS-001` Notifications Domain Foundation | [NOTIFICATIONS](roadmap/NOTIFICATIONS.md) |

## Current Critical Path

1. `INFRA-001` Database Foundation
2. `INFRA-002` Security Foundation
3. `PROFILE-002` V1 Identity Field Set
4. `PROFILE-003` Profile Visibility Matrix
5. `SWIPE-002` V1 Recommendation Inputs
6. `SWIPE-003` Candidate Card Contract
7. `EVENT-002` V1 Community Game Scope
8. `EVENT-003` Event Lifecycle & Participant Permissions
9. `NOTIFICATIONS-001` Notifications Domain Foundation

See [roadmap/DEPENDENCIES.md](roadmap/DEPENDENCIES.md) for dependency graph and parallel work guidance.

## Planning Pipeline

```text
💡 Idea
⬇️
🗺️ Roadmap
⬇️
📄 Implementation Tech Plan
⬇️
✅ Approval
⬇️
🎯 Jira Epic
⬇️
📝 Jira Stories
⬇️
💻 Implementation
⬇️
🔍 Review + CI
⬇️
🎉 Complete
```

## Current Guidance

- Keep roadmap items lightweight until work is imminent.
- Promote only `Next` items into `implementation/proposed/`.
- Do not create placeholder implementation plans for every roadmap item.
- Do not redefine domain concepts inside feature plans.
- Check dependencies before promoting an item into implementation planning.
