# Tech Plan Templates

This directory contains reusable templates for Scout technical plans.

Use these templates to keep planning consistent across product domains and to help future AI coding agents implement approved work with minimal ambiguity.

## Templates

- `TECH_PLAN_TEMPLATE.md` is the generic template for feature, infrastructure, migration, and implementation plans.
- `DOMAIN_TECH_PLAN_TEMPLATE.md` is the required template for major domain-level plans such as Profile, Events, Swipe, Feed, Chat, Maps, Search, Notifications, Teams, and Recommendations.

Domain-level plans should become the authoritative source for a business capability. They must document philosophy, conceptual model, lifecycle, ownership, contracts, consumers, AI rules, and future extensions.

## Planning Levels

Use `../PLANNING_LEVELS.md` to determine whether a plan is:

- Level 1: Foundation
- Level 2: Domain
- Level 3: Feature

Level 3 feature plans should reference the relevant Level 2 domain plan and must not redefine domain concepts.
