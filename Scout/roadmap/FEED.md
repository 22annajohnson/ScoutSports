# FEED Roadmap

## Active Domain Health

- 🟢 Foundation: Initial app feed area exists in iOS.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define Feed domain foundation.
- ⚪ Planned: Activity cards, local play prompts, recommendation previews.
- 💡 Ideas: Community recaps, venue activity, team updates.

## 🔵 Next

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| FEED-001 | Feed Domain Foundation | Define Feed philosophy, conceptual model, ownership, contracts, consumers, and AI rules using the domain plan template. | ARCH-001, DESIGN-001, PROFILE-001 | High | L |
| FEED-002 | V1 Feed Content Strategy | Define which content types appear in the first feed experience and how they support getting users to play. | FEED-001, EVENT-001, SWIPE-001 | High | M |

## ⚪ Soon

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| FEED-003 | Feed Card Contracts | Define contracts for profile prompts, event previews, discovery recommendations, and local activity. | FEED-001, DESIGN-001 | Medium | M |
| FEED-004 | Feed Ranking Principles | Define lightweight ordering rules that do not duplicate recommendation logic. | FEED-001, SWIPE-001 | Medium | L |

## ⚪ Later

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| FEED-005 | Community Activity Recaps | Plan recap cards for completed games, local activity, and player milestones. | EVENT-001, PROFILE-001 | Low | L |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| FEED-IDEA-001 | Venue Activity Feed | Explore venue-level activity and upcoming play. | MAPS roadmap, EVENT-001 | Idea | L |
| FEED-IDEA-002 | Team Updates | Explore team and club update cards. | Future Teams domain | Idea | L |
