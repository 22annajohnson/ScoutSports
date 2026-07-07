# EVENT Roadmap

## Active Domain Health

- 🟢 Foundation: Real-World Sports Coordination is defined.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define v1 lightweight community game scope.
- ⚪ Planned: Lifecycle state machine, participation contracts, organizer permissions.
- 💡 Ideas: Tournaments, leagues, recurring events, payments, reservations.

## 🔵 Next

| Proposed Tech Plan ID | Status | Title | Description | Why Now? | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- | --- |
| EVENT-002 | 🟦 Not Started | V1 Community Game Scope | Define the smallest viable version of community games, including event card, detail, join/request behavior, and organizer responsibilities. | Scout's product goal depends on getting people onto the court, and this scopes the first real-world coordination capability before schema or UI work begins. | EVENT-001, PROFILE-001, DESIGN-001 | High | L |
| EVENT-003 | 🟦 Not Started | Event Lifecycle & Participant Permissions | Define lifecycle transitions, participant states, and organizer permissions for v1. | Lifecycle and permission rules block safe event joins, organizer tools, notifications, and event chat. | EVENT-001, ARCH-001 | High | L |

## ⚪ Soon

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| EVENT-004 | 🟦 Not Started | Event Visibility & Location Precision | Define approximate versus exact location behavior and visibility rules before and after joining. | EVENT-003, PROFILE-003 | High | M |
| EVENT-005 | 🟦 Not Started | Event Notification Contracts | Define safe notification summaries for joins, updates, cancellations, and reminders. | EVENT-002, NOTIFICATIONS-001 | Medium | M |

## ⚪ Later

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| EVENT-006 | 🟦 Not Started | Organizer Dashboard | Plan participant request review, capacity management, updates, and cancellation tooling. | EVENT-003, DESIGN-001 | Medium | L |
| EVENT-007 | 🟦 Not Started | Attendance & No-Show Signals | Define attendance, completion, cancellation, and reliability concepts without creating punitive mechanics. | EVENT-001, PROFILE-007 | Low | XL |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| EVENT-IDEA-001 | 🟦 Not Started | Recurring Games | Explore recurring games and organizer templates. | EVENT-001 | Idea | L |
| EVENT-IDEA-002 | 🟦 Not Started | Court Reservations | Explore integrations or lightweight workflows for court booking. | EVENT-001, MAPS roadmap | Idea | XL |
| EVENT-IDEA-003 | 🟦 Not Started | Tournaments & Leagues | Explore higher-structure competition formats after community games are proven. | EVENT-001 | Idea | XL |
