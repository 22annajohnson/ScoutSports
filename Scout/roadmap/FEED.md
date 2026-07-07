# FEED Roadmap

## Active Domain Health

- ⚪ Foundation: Initial app feed area exists in iOS, but no canonical Feed domain plan exists yet.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define Feed domain foundation.
- ⚪ Planned: Activity cards, local play prompts, recommendation previews.
- 💡 Ideas: Community recaps, venue activity, team updates.

## 🔵 Next

| Proposed Tech Plan ID | Status | Title | Description | Why Now? | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- | --- |
| FEED-001 | 🟦 Not Started | Feed Domain Foundation | Define Feed philosophy, conceptual model, ownership, contracts, consumers, and AI rules using the domain plan template. | Feed will consume Profile, Events, Discovery, and Notifications, so it needs a domain boundary before becoming a catch-all surface. | ARCH-001, DESIGN-001, PROFILE-001 | High | L |
| FEED-002 | 🟦 Not Started | V1 Feed Content Strategy | Define which content types appear in the first feed experience and how they support getting users to play. | This translates the Feed domain into a practical first surface and clarifies dependencies on Events and Discovery. | FEED-001, EVENT-001, SWIPE-001 | High | M |

## ⚪ Soon

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| FEED-003 | 🟦 Not Started | Feed Card Contracts | Define contracts for profile prompts, event previews, discovery recommendations, and local activity. | FEED-001, DESIGN-001 | Medium | M |
| FEED-004 | 🟦 Not Started | Feed Ranking Principles | Define lightweight ordering rules that do not duplicate recommendation logic. | FEED-001, SWIPE-001 | Medium | L |

## ⚪ Later

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| FEED-005 | 🟦 Not Started | Community Activity Recaps | Plan recap cards for completed games, local activity, and player milestones. | EVENT-001, PROFILE-001 | Low | L |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| FEED-IDEA-001 | 🟦 Not Started | Venue Activity Feed | Explore venue-level activity and upcoming play. | MAPS roadmap, EVENT-001 | Idea | L |
| FEED-IDEA-002 | 🟦 Not Started | Team Updates | Explore team and club update cards. | Future Teams domain | Idea | L |
