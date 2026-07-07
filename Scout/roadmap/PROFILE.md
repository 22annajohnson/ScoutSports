# PROFILE Roadmap

## Active Domain Health

- 🟢 Foundation: Player Identity & Profile System is defined.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define v1 identity field subset.
- ⚪ Planned: Privacy matrix, profile media, public profile contracts.
- 💡 Ideas: Reputation, teams, badges, achievements, league history.

## 🔵 Next

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| PROFILE-002 | V1 Identity Field Set | Define the minimum identity fields needed for onboarding, discovery, and profile display. This should clarify required versus optional fields without deciding storage implementation prematurely. | PROFILE-001, DESIGN-001 | High | M |
| PROFILE-003 | Profile Visibility Matrix | Define what profile data is visible before matching, after matching, in events, in chat, and to the profile owner. | PROFILE-001, ARCH-001 | High | M |

## ⚪ Soon

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| PROFILE-004 | Profile Media Model | Plan profile photo and action photo behavior, storage expectations, fallbacks, and moderation concerns. | PROFILE-002, PROFILE-003, DATABASE foundation | Medium | L |
| PROFILE-005 | Profile Completion Scoring | Define progressive completion scoring and prompts that encourage completion without blocking core value. | PROFILE-002, DESIGN-001 | Medium | M |

## ⚪ Later

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| PROFILE-006 | Public Profile Preview | Define owner preview and context-specific profile previews for discovery, events, chat, and future web. | PROFILE-003, DESIGN-001 | Medium | M |
| PROFILE-007 | Reputation Surface Planning | Define how badges, ratings, attendance reliability, and trust signals may appear in identity contracts. | PROFILE-001, EVENT-001 | Low | XL |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| PROFILE-IDEA-001 | League History | Explore how competitive history could appear without making Scout intimidating to beginners. | PROFILE-001 | Idea | L |
| PROFILE-IDEA-002 | Equipment Preferences | Explore paddle, gear, and play preference fields for richer compatibility. | PROFILE-001 | Idea | S |
