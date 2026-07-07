# EVENT Roadmap

## Active Domain Health

- 🟢 Foundation: Real-World Sports Coordination is defined.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define v1 lightweight community game scope.
- ⚪ Planned: Lifecycle state machine, participation contracts, organizer permissions.
- 💡 Ideas: Tournaments, leagues, recurring events, payments, reservations.

## 🔵 Next

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| EVENT-002 | V1 Community Game Scope | Define the smallest viable version of community games, including event card, detail, join/request behavior, and organizer responsibilities. | EVENT-001, PROFILE-001, DESIGN-001 | High | L |
| EVENT-003 | Event Lifecycle & Participant Permissions | Define lifecycle transitions, participant states, and organizer permissions for v1. | EVENT-001, ARCH-001 | High | L |

## ⚪ Soon

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| EVENT-004 | Event Visibility & Location Precision | Define approximate versus exact location behavior and visibility rules before and after joining. | EVENT-003, PROFILE-003 | High | M |
| EVENT-005 | Event Notification Contracts | Define safe notification summaries for joins, updates, cancellations, and reminders. | EVENT-002, NOTIFICATIONS roadmap | Medium | M |

## ⚪ Later

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| EVENT-006 | Organizer Dashboard | Plan participant request review, capacity management, updates, and cancellation tooling. | EVENT-003, DESIGN-001 | Medium | L |
| EVENT-007 | Attendance & No-Show Signals | Define attendance, completion, cancellation, and reliability concepts without creating punitive mechanics. | EVENT-001, PROFILE-007 | Low | XL |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| EVENT-IDEA-001 | Recurring Games | Explore recurring games and organizer templates. | EVENT-001 | Idea | L |
| EVENT-IDEA-002 | Court Reservations | Explore integrations or lightweight workflows for court booking. | EVENT-001, MAPS roadmap | Idea | XL |
| EVENT-IDEA-003 | Tournaments & Leagues | Explore higher-structure competition formats after community games are proven. | EVENT-001 | Idea | XL |
