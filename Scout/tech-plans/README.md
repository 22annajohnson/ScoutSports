# Tech Plans

This directory contains Scout technical plans.

Every major feature should begin with a technical plan before implementation begins. A plan should define the product problem, user experience, technical design, risks, testing strategy, rollout approach, and Definition of Done.

Scout planning follows a three-tier architecture:

- Level 1: Foundations define platform rules, such as Architecture, Design System, Player Identity, Database, and Security.
- Level 2: Domains define business capabilities, such as Events, Swipe, Feed, Chat, Maps, Recommendations, and Notifications.
- Level 3: Features define specific implementations, such as Event Waitlist, Swipe Undo, or Profile Photo Cropping.

See `PLANNING_LEVELS.md` for the canonical planning hierarchy.

Major domain-level plans should use `templates/DOMAIN_TECH_PLAN_TEMPLATE.md`. Domain-level plans are the authoritative source for a business capability such as Profile, Events, Swipe, Feed, Chat, Maps, Search, Notifications, Teams, or Recommendations.

Each domain-level plan must explain:

- Philosophy: why the system exists and the user problem it solves.
- Conceptual Model: core entities and relationships.
- Lifecycle: how entities evolve over time.
- Ownership: which system owns each concept and which systems consume it.
- Contracts: summaries or interfaces exposed to other domains.
- Consumers: every feature or subsystem that depends on the domain.
- AI Rules: implementation guardrails and architectural boundaries.
- Future Extensions: how the system should evolve without breaking assumptions.

## Directories

- `templates/` contains reusable planning templates.
- `proposed/` contains plans that are still under review.
- `approved/` contains plans approved for Jira ticket breakdown and implementation.
- `archived/` contains obsolete, rejected, or superseded plans.

Do not create implementation tickets for architectural changes until the relevant technical plan has been approved.
