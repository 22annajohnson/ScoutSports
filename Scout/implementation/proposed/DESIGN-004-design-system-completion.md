# Implementation Tech Plan: DESIGN-004 Design System Completion

## Status

Proposed

## Product Domain

DESIGN / CORE

## Jira Project

CORE

## Source of Truth

References:

- `tech-plans/approved/DESIGN-001-design-system.md`
- `implementation/proposed/DESIGN-002-design-system-adoption.md`
- `implementation/proposed/DESIGN-003-design-factory.md`
- `implementation/proposed/PROFILE-005-public-profile-and-owner-profile.md`
- `implementation/proposed/SWIPE-004-discovery-candidate-queue.md`
- `implementation/proposed/FEED-002-feed-backend.md`
- `implementation/proposed/EVENT-002-community-games-v1.md`

## Problem Statement

Scout needs to finish the reusable design system surface required for production feature work. Without a complete Design Factory and shared components for common states, agents will continue creating one-off UI, increasing visual drift and merge risk.

## Goals

- Complete Design Factory integration for reusable components and tokens.
- Add missing shared loading, empty, and error states.
- Standardize modal/sheet presentation patterns.
- Add shared cards, chips, pills, and stat tiles needed by Profile, Discovery, Feed, and Events.
- Finish high-value ScoutDesign adoption paths for production feature screens.
- Require new reusable components to appear in Design Factory before feature use.

## Non-goals

- Redefining Scout's design philosophy or token scales.
- Broad visual redesign.
- Cross-platform design token tooling.
- Web implementation.
- Rewriting every existing screen in one PR.

## Architecture

```text
Design Factory
  -> Reusable Component Inspection
  -> ScoutDesign Package Components
  -> Feature Screens
```

Feature screens should compose ScoutDesign components and pass domain models/contracts into them. ScoutDesign owns reusable styling and component state. Feature domains own product-specific data and actions.

## Repository Ownership

ScoutDesign owns reusable components, tokens, typography, spacing, shared cards, chips, pills, stat tiles, loading states, empty states, error states, and modal/sheet primitives. Feature areas own screen composition and feature-specific copy/actions.

## Domain Ownership

| Design Area | Owner | Consumers |
| --- | --- | --- |
| Tokens and typography | ScoutDesign | All iOS features |
| Loading/empty/error states | ScoutDesign | Profile, Discovery, Feed, Events, Chat |
| Shared cards | ScoutDesign | Profile, Discovery, Feed, Events |
| Chips/pills/stat tiles | ScoutDesign | Profile, Discovery, Events |
| Modal/sheet primitives | ScoutDesign / CORE | All features |
| Design Factory | CORE / ScoutDesign | Developers, AI agents |
| Feature-specific layouts | Owning feature | Users |

## Backend Ownership

DESIGN-004 does not change backend schema, Supabase ownership, or API contracts. UI components consume domain contracts from Profile, Discovery, Feed, and Events.

## iOS Responsibilities

- Complete Design Factory navigation and galleries.
- Add reusable components in ScoutDesign.
- Migrate highest-value duplicated UI to shared components.
- Preserve native iOS behavior unless a design plan approves divergence.
- Include screenshots or Design Factory evidence in future UI PRs.

## Component Scope

DESIGN-004 covers:

- Design Factory token and component galleries.
- Loading states.
- Empty states.
- Error states.
- Modal/sheet standardization.
- Shared cards.
- Shared chips and pills.
- Shared stat tiles.
- High-value ScoutDesign adoption in Profile, Swipe, Feed, and Events.

## Implementation Sequencing

1. Complete Design Factory navigation, token galleries, and component galleries.
2. Add shared loading, empty, and error state components.
3. Standardize modal/sheet primitives.
4. Add shared cards, chips, pills, and stat tiles.
5. Migrate high-use duplicated UI in Profile, Swipe, Feed, and Events.
6. Add screenshot/visual validation guidance tied to TEST-002.

## Validation Strategy

- Build ScoutDesign and app targets.
- Verify Design Factory renders all reusable components and token galleries.
- Add component previews/tests where existing project patterns support them.
- Capture screenshots for reusable states and migrated feature screens.
- Use TEST-002 snapshot/screenshot strategy when available.

## Rollout Strategy

1. Land Design Factory completion first.
2. Add shared state components and modal primitives.
3. Adopt components in new feature work first.
4. Migrate existing duplicated UI incrementally when touched by feature tickets.
5. Avoid large all-screen visual rewrites.

## Risks

- Over-migration creating large, hard-to-review PRs.
- Design Factory drifting from actual components.
- Feature screens embedding custom styles despite shared components.
- Reusable components becoming too feature-specific.
- Visual regressions without screenshot evidence.

## Definition of Done

- Design Factory displays tokens, typography, colors, spacing, icons, shared components, and component states.
- ScoutDesign provides shared loading, empty, error, modal, card, chip/pill, and stat tile primitives.
- High-value duplicated UI has a migration path and initial adoption.
- Future reusable components must appear in Design Factory before feature use.
- UI PR expectations reference screenshots and relevant Design Factory states.

## Jira Breakdown

- Epic: `CORE-25` - DESIGN-004: Design System Completion

| Order | Jira | Story | Type | Points | Dependencies |
| --- | --- | --- | --- | --- | --- |
| 1 | `CORE-26` | Design: Complete Design Factory navigation and token galleries | 🤖 AI Implementation | 1 | DESIGN-003 |
| 2 | `CORE-27` | Design: Add shared loading empty and error states to ScoutDesign | 🤖 AI Implementation | 2 | `CORE-26` |
| 3 | `CORE-28` | Design: Standardize modal and sheet primitives | 🤖 AI Implementation | 2 | `CORE-26` |
| 4 | `CORE-29` | Design: Add shared cards chips pills and stat tiles | 🤖 AI Implementation | 2 | `CORE-26` |
| 5 | `CORE-30` | Design: Migrate high-use duplicated UI to ScoutDesign | 🤖 AI Implementation | 2 | `CORE-27`, `CORE-28`, `CORE-29`, feature work |
| 6 | `CORE-31` | Design: Add UI PR screenshot and Design Factory validation checklist | 🤖 AI Implementation | 1 | DESIGN-004, PR template conventions |
