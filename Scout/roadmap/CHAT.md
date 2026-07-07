# CHAT Roadmap

## Active Domain Health

- 🟢 Foundation: No canonical Chat domain plan yet.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define Chat domain foundation.
- ⚪ Planned: Match chat, event chat, notification contracts.
- 💡 Ideas: Group chat, availability-aware prompts, safety tooling.

## 🔵 Next

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| CHAT-001 | Chat Domain Foundation | Define Chat philosophy, lifecycle, ownership, contracts, consumers, AI rules, and safety boundaries. | ARCH-001, DESIGN-001, PROFILE-001 | High | L |
| CHAT-002 | Match Conversation Scope | Define the first conversation model for matched players coordinating play. | CHAT-001, SWIPE-001, PROFILE-001 | High | M |

## ⚪ Soon

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| CHAT-003 | Event Chat Scope | Define event-specific communication, organizer announcements, and participant messaging. | CHAT-001, EVENT-001 | Medium | L |
| CHAT-004 | Chat Safety & Reporting | Define abuse reporting, blocking impacts, message visibility, and safety escalation concepts. | CHAT-001, PROFILE-003 | Medium | L |

## ⚪ Later

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| CHAT-005 | Coordination Prompts | Plan lightweight prompts for time, venue, and availability to reduce coordination friction. | CHAT-002, EVENT-001 | Low | M |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| CHAT-IDEA-001 | Group Chat | Explore group conversations for teams, clubs, or recurring games. | CHAT-001, EVENT-001 | Idea | XL |
| CHAT-IDEA-002 | Smart Scheduling Assistant | Explore AI-assisted coordination suggestions after privacy and trust rules are mature. | CHAT-001, INFRA roadmap | Idea | XL |
