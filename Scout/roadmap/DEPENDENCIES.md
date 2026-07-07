# Roadmap Dependencies

This document visualizes major dependencies between Scout roadmap items across domains.

It is intentionally high-level. Detailed sequencing belongs in implementation tech plans once work is imminent.

## Dependency Graph

```mermaid
flowchart TB
    ARCH["ARCH-001 Architecture Foundation"]
    DESIGN["DESIGN-001 Design Foundation"]
    PROFILE1["PROFILE-001 Player Identity Foundation"]
    EVENT1["EVENT-001 Real-World Coordination"]
    SWIPE1["SWIPE-001 Discovery & Recommendation"]

    INFRA1["INFRA-001 Database Foundation"]
    INFRA2["INFRA-002 Security Foundation"]
    PROFILE2["PROFILE-002 V1 Identity Field Set"]
    PROFILE3["PROFILE-003 Profile Visibility Matrix"]
    SWIPE2["SWIPE-002 V1 Recommendation Inputs"]
    SWIPE3["SWIPE-003 Candidate Card Contract"]
    EVENT2["EVENT-002 V1 Community Game Scope"]
    EVENT3["EVENT-003 Event Lifecycle & Participant Permissions"]
    NOTIF1["NOTIFICATIONS-001 Notifications Foundation"]
    NOTIF2["NOTIFICATIONS-002 Event Notification Scope"]
    FEED1["FEED-001 Feed Domain Foundation"]
    FEED2["FEED-002 V1 Feed Content Strategy"]
    CHAT1["CHAT-001 Chat Domain Foundation"]
    CHAT2["CHAT-002 Match Conversation Scope"]

    ARCH --> INFRA1
    ARCH --> INFRA2
    DESIGN --> PROFILE2
    DESIGN --> SWIPE3
    DESIGN --> EVENT2
    DESIGN --> FEED1
    DESIGN --> CHAT1
    DESIGN --> NOTIF1

    PROFILE1 --> PROFILE2
    PROFILE1 --> PROFILE3
    PROFILE2 --> SWIPE3
    PROFILE3 --> SWIPE3
    PROFILE3 --> EVENT3
    PROFILE3 --> CHAT2

    INFRA1 --> PROFILE2
    INFRA1 --> EVENT2
    INFRA1 --> SWIPE2
    INFRA2 --> PROFILE3
    INFRA2 --> EVENT3
    INFRA2 --> CHAT1
    INFRA2 --> NOTIF1

    SWIPE1 --> SWIPE2
    SWIPE1 --> SWIPE3
    SWIPE2 --> SWIPE3
    SWIPE2 --> FEED2
    SWIPE3 --> CHAT2

    EVENT1 --> EVENT2
    EVENT1 --> EVENT3
    EVENT2 --> NOTIF2
    EVENT3 --> NOTIF2
    EVENT2 --> FEED2

    NOTIF1 --> NOTIF2
    FEED1 --> FEED2
    CHAT1 --> CHAT2
```

## Critical Path

The near-term critical path is:

1. `INFRA-001` and `INFRA-002` define database and security rules.
2. `PROFILE-002` and `PROFILE-003` define the identity fields and visibility rules consumed by other domains.
3. `SWIPE-002` and `SWIPE-003` define the first discovery inputs and candidate card contract.
4. `EVENT-002` and `EVENT-003` define v1 community games and event lifecycle permissions.
5. `NOTIFICATIONS-001` and `NOTIFICATIONS-002` define the notification model needed for event attendance and coordination.
6. `CHAT-001` and `CHAT-002` define post-match coordination.
7. `FEED-001` and `FEED-002` compose Profile, Events, Discovery, and Notifications into the first useful feed experience.

## Work That Can Proceed In Parallel

The following can proceed in parallel after the foundation PRs are merged:

- `INFRA-001` Database Foundation and `INFRA-002` Security Foundation.
- `PROFILE-002` V1 Identity Field Set and `PROFILE-003` Profile Visibility Matrix, once Profile foundation is accepted.
- `FEED-001`, `CHAT-001`, and `NOTIFICATIONS-001` domain foundations, because they define boundaries rather than implementation.
- `EVENT-002` and `SWIPE-002` planning can begin in parallel, but implementation should wait for Profile visibility and Infra guidance.

## Dependency Risks

- Discovery and Events both depend on Profile visibility rules. Delaying `PROFILE-003` blocks safe candidate cards, event participant summaries, chat headers, and notifications.
- Notifications should not be implemented as a feature inside Events or Chat. `NOTIFICATIONS-001` should establish the domain boundary first.
- Feed risks becoming a catch-all surface unless `FEED-001` is completed before feed implementation work expands.
- Database and security foundations should land before schema, RLS, storage, or notification delivery implementation plans.
