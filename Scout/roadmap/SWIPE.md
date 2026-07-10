# SWIPE Roadmap

## Active Domain Health

- 🟢 Foundation: Player Discovery & Recommendation System is defined.
- 🟡 In Progress: None.
- 🔵 Ready Next: Define v1 recommendation inputs and candidate card contract.
- ⚪ Planned: Decision semantics, exclusion rules, match authority.
- 💡 Ideas: Learning models, collaborative filtering, event recommendations.

## 🔵 Next

| Proposed Tech Plan ID | Status | Title | Description | Why Now? | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- | --- |
| SWIPE-002 | 🟦 Not Started | V1 Recommendation Inputs | Define the initial compatibility inputs for candidate eligibility and ranking, such as sport, skill, availability, location, privacy, and exclusions. | This unlocks the first useful discovery experience and gives Feed, Events, and future Recommendations a shared eligibility foundation. | SWIPE-001, PROFILE-001, PROFILE-002 | High | M |
| SWIPE-003 | 🟦 Not Started | Candidate Card Contract | Define the Candidate Card contract consumed by the swipe deck and future discovery surfaces. | Candidate cards need a stable contract before UI, privacy filtering, and profile summary work can proceed safely. | SWIPE-001, PROFILE-002, DESIGN-001 | High | M |

## ⚪ Soon

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| SWIPE-004 | 🟦 Not Started | Decision Semantics & Idempotency | Define pass, interest, future undo, and decision persistence semantics. | SWIPE-001, ARCH-001 | High | M |
| SWIPE-005 | 🟦 Not Started | Match Creation Authority | Define where match creation happens and how mutual interest is detected safely. | SWIPE-004, PROFILE-003 | High | L |

## ⚪ Later

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| SWIPE-006 | 🟦 Not Started | Empty Deck Recovery | Define empty-state recommendations, broadened filters, and onboarding prompts for early markets. | SWIPE-002, DESIGN-001 | Medium | M |
| SWIPE-007 | 🟦 Not Started | Feed Recommendations | Plan how Discovery recommendations appear in Feed without duplicating ranking logic. | SWIPE-001, FEED-001 | Medium | L |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Status | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- | --- |
| SWIPE-IDEA-001 | 🟦 Not Started | Recommendation Learning | Explore outcome-based learning using matches, completed games, and feedback. | SWIPE-001, EVENT-001 | Idea | XL |
| SWIPE-IDEA-002 | 🟦 Not Started | Collaborative Filtering | Explore future collaborative filtering once enough behavior data exists. | SWIPE-001 | Idea | XL |
