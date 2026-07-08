# Scout Design System

## Purpose

This document defines the starting point for Scout's design system. It should help future feature plans and implementation tickets preserve a consistent product experience across iOS today and web later.

This is planning documentation, not a final design spec.

## Design Principles

- Support fast real-world action. Interfaces should help users discover, decide, and coordinate quickly.
- Make sports context scannable. Skill level, sport, location, availability, and play intent should be easy to understand.
- Build trust through clarity. Profiles, matches, and event participation should communicate enough context for confident decisions.
- Stay warm but practical. Scout should feel social and energetic without becoming visually noisy.
- Preserve platform expectations. iOS should feel native; future web should feel consistent without copying iOS controls blindly.

## Current iOS Design Areas

The current iOS app has design-related structure in:

- `Scout/Design/Assets.xcassets`
- `Scout/Design/Components`
- `Scout/Design/Modifiers`
- `Scout/Design/Preview`
- `Scout/Design/Theme`
- `Scout/Design/Typography`

Future design work should inspect these areas before adding new components, modifiers, colors, or typography styles.

## Visual Language

### Color

Document approved semantic colors rather than one-off usage. Future tokens should distinguish roles such as:

- Background
- Surface
- Primary action
- Secondary action
- Text primary
- Text secondary
- Border
- Error
- Success
- Sport or skill indicators

### Typography

Typography should prioritize scanability on mobile:

- Large titles for screen identity.
- Section headings for grouping.
- Body text for profile and event details.
- Captions for metadata and secondary context.
- Button labels that remain short and action-oriented.

### Spacing and Layout

Layout should support repeated use and mobile ergonomics:

- Consistent vertical rhythm.
- Clear separation between profile sections.
- Stable card dimensions where swipe or feed content changes dynamically.
- Avoid layouts that jump when async data loads.

### Motion

Motion should clarify state changes and social feedback:

- Swipe decisions.
- Match confirmation.
- Loading transitions.
- Error recovery.

Motion should not block core tasks.

## Component Families

Initial component families to document and standardize:

- Buttons and icon buttons.
- Form fields and pickers.
- Profile field rows.
- Profile photo and media components.
- Sport and skill badges.
- Swipe cards.
- Match modal.
- Empty states.
- Loading states.
- Error states.
- Event cards and attendance controls.

New components should be added only when existing components cannot be extended cleanly.

## Component Hierarchy

Scout's design system hierarchy follows `DESIGN-001` and should be used as the reference point for UI planning and implementation tickets:

| Level | Area | Role |
| --- | --- | --- |
| 1 | Foundations | Color, typography, spacing, icons, elevation, shape, layout rhythm, and motion timing. |
| 2 | Navigation | Root structure, tab or section navigation, stack navigation, modal and sheet behavior, dismissal, and future routes. |
| 3 | Inputs | Text entry, pickers, segmented controls, toggles, sliders, sport and skill selectors, date/time inputs, location inputs, and media inputs. |
| 4 | Feedback | Loading, empty, error, success, inline validation, recovery, match feedback, and save confirmation states. |
| 5 | Cards | Swipe cards, profile summary cards, feed cards, event cards, match cards, and invitation cards. |
| 6 | Lists | Feed lists, profile detail lists, participant lists, search results, settings lists, and notification lists. |
| 7 | Domain components | Profile, Swipe, Feed, Event, Chat, Map, Team, Search, and Notification components owned by their product domains. |
| 8 | Animations | Screen transitions, swipe decisions, match confirmation, loading transitions, save feedback, error recovery, and empty-state reveals. |
| 9 | Accessibility | Dynamic Type, VoiceOver, contrast, touch targets, reduced motion, non-color state indication, and future web focus behavior. |

Foundation changes are design system direction changes. Do not change or add color scales, typography scales, spacing systems, icon strategy, elevation, shape, layout rhythm, motion timing, design tokens, or cross-platform design tooling without an approved design proposal.

## Reuse Rules

Before creating or changing UI, agents should:

- Inspect the current iOS design areas listed above and the relevant feature area.
- Identify the design system level and product domain owner for the UI being changed.
- Reuse existing foundations, components, modifiers, and interaction patterns where they fit the use case.
- Extend an existing component with a clear variant, state, or configuration when the behavior belongs to the same component family.
- Keep feature-specific components inside the owning feature unless repeated use proves they should graduate into shared design system documentation.
- Document loading, empty, error, accessibility, and motion impact for UI implementation tickets.

Create a new component only when existing components cannot be extended cleanly. The ticket or PR should explain what was inspected, what is being reused, why extension is insufficient, and whether the new component is feature-specific or a candidate for shared reuse.

New shared components, new foundation patterns, cross-feature component ownership changes, and any divergence from native iOS platform behavior require design review or an approved proposal before implementation.

## Interaction Patterns

### Onboarding

Onboarding should request only the information needed to make first discovery useful.

### Profile Editing

Profile editing should make required and optional fields clear, preserve user input, and provide visible save/error feedback.

### Swipe and Discovery

Swipe interactions should provide enough context before decisions and should recover gracefully from empty decks, load failures, and accidental actions where supported.

### Events

Events should make time, location, skill expectations, capacity, and participation state clear before a user joins.

## Accessibility

Design and implementation should account for:

- Dynamic Type.
- VoiceOver labels and reading order.
- Sufficient color contrast.
- Touch target sizes.
- Reduced motion.
- Error states that do not rely on color alone.

## Platform Considerations

iOS and web should share product concepts, language, and visual identity, but each platform should use native interaction expectations. Shared design tokens may be proposed later, but require explicit approval before implementation.

## Open Design Questions

- What are Scout's approved semantic color tokens?
- What typography scale should be shared across product surfaces?
- Which components must exist before web migration?
- How should sport-specific visuals scale beyond pickleball?
- What match and event feedback patterns are core to the brand?
