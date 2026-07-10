# NOTIFICATIONS Roadmap

## Active Domain Health

- ⚪ Foundation: No canonical Notifications domain plan yet.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define Notifications domain foundation.
- ⚪ Planned: Event reminders, match notifications, chat notifications.
- 💡 Ideas: Smart reminders, digest notifications, quiet hours, escalation rules.

## 🔵 Next

| Proposed Tech Plan ID | Status | Title | Description | Why Now? | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- | --- |
| NOTIFICATIONS-001 | 🟦 Not Started | Notifications Domain Foundation | Define notification philosophy, ownership, contracts, permission boundaries, delivery surfaces, AI rules, and safety expectations. | Events, Discovery, Chat, and Profile will all need notifications, so this foundation prevents each domain from inventing its own notification model. | ARCH-001, DESIGN-001, PROFILE-001 | High | L |
| NOTIFICATIONS-002 | 🟦 Not Started | Event Notification Scope | Define safe notification contracts for event joins, updates, cancellations, reminders, and location-sensitive messaging. | This enables EVENT-005 and supports real-world attendance without leaking sensitive event details. | NOTIFICATIONS-001, EVENT-001, EVENT-002 | High | M |

## ⚪ Soon

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| NOTIFICATIONS-003 | 🟦 Not Started | Match Notification Scope | Define notification behavior for matches, next actions, and post-match coordination. | NOTIFICATIONS-001, SWIPE-001, CHAT-002, PROFILE-002 | Medium | M |
| NOTIFICATIONS-004 | 🟦 Not Started | Chat Notification Scope | Define message notification behavior, privacy boundaries, preview text, and mute rules. | NOTIFICATIONS-001, CHAT-001, PROFILE-002 | Medium | L |

## ⚪ Later

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| NOTIFICATIONS-005 | 🟦 Not Started | Notification Preferences | Define user preferences for notification categories, quiet hours, and domain-specific opt-outs. | NOTIFICATIONS-001, PROFILE-001 | Medium | M |
| NOTIFICATIONS-006 | 🟦 Not Started | Notification Delivery Infrastructure | Plan server-side notification delivery, retry behavior, observability, and failure handling. | NOTIFICATIONS-001, INFRA-002 | Medium | L |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| NOTIFICATIONS-IDEA-001 | 🟦 Not Started | Smart Play Reminders | Explore context-aware reminders that help users show up prepared without becoming noisy. | NOTIFICATIONS-001, EVENT-001 | Idea | L |
| NOTIFICATIONS-IDEA-002 | 🟦 Not Started | Weekly Activity Digest | Explore digest-style notifications for local games, matches, and community activity. | NOTIFICATIONS-001, FEED-001 | Idea | M |
