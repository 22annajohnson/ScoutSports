# SWIPE Roadmap

## Active Domain Health

- 🟢 Foundation: Player Discovery & Recommendation System is defined.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define v1 recommendation inputs and candidate card contract.
- ⚪ Planned: Decision semantics, exclusion rules, match authority.
- 💡 Ideas: Learning models, collaborative filtering, event recommendations.

## 🔵 Next

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| SWIPE-002 | V1 Recommendation Inputs | Define the initial compatibility inputs for candidate eligibility and ranking, such as sport, skill, availability, location, privacy, and exclusions. | SWIPE-001, PROFILE-001 | High | M |
| SWIPE-003 | Candidate Card Contract | Define the Candidate Card contract consumed by the swipe deck and future discovery surfaces. | SWIPE-001, PROFILE-002, DESIGN-001 | High | M |

## ⚪ Soon

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| SWIPE-004 | Decision Semantics & Idempotency | Define pass, interest, future undo, and decision persistence semantics. | SWIPE-001, ARCH-001 | High | M |
| SWIPE-005 | Match Creation Authority | Define where match creation happens and how mutual interest is detected safely. | SWIPE-004, PROFILE-003 | High | L |

## ⚪ Later

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| SWIPE-006 | Empty Deck Recovery | Define empty-state recommendations, broadened filters, and onboarding prompts for early markets. | SWIPE-002, DESIGN-001 | Medium | M |
| SWIPE-007 | Feed Recommendations | Plan how Discovery recommendations appear in Feed without duplicating ranking logic. | SWIPE-001, FEED roadmap | Medium | L |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| SWIPE-IDEA-001 | Recommendation Learning | Explore outcome-based learning using matches, completed games, and feedback. | SWIPE-001, EVENT-001 | Idea | XL |
| SWIPE-IDEA-002 | Collaborative Filtering | Explore future collaborative filtering once enough behavior data exists. | SWIPE-001 | Idea | XL |
