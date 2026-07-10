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

## Feature Ownership Matrix

This matrix follows `DESIGN-001` and identifies which product area owns each design surface before future agents add or change UI.

| Design Area | Owner | Consumers | Reuse Guidance |
| --- | --- | --- | --- |
| Foundations | Design | All features | Color, typography, spacing, icons, elevation, shape, layout rhythm, and motion timing are shared foundations. Changes require design approval. |
| Navigation | App / Design | Profile, Swipe, Feed, Events, Chat, Maps | Preserve platform expectations and a clear sense of place. |
| Inputs | Design | Profile, Events, Chat, Maps, Settings | Reuse form, picker, selector, media, validation, and recovery patterns before creating feature-specific inputs. |
| Feedback | Design | All features | Loading, empty, error, success, validation, save, and recovery states should use shared patterns. |
| Cards | Design | Swipe, Feed, Events, Profile, Chat | Card variants should extend shared card behavior rather than duplicate layout, spacing, or state treatment. |
| Lists | Design | Feed, Events, Chat, Profile, Maps, Notifications | Lists should remain dense, grouped, scannable, and predictable. |
| Profile components | Profile | Swipe, Events, Chat, Feed, Teams, Search | Profile summaries, identity cues, sport badges, skill indicators, media, and availability previews should stay consistent across consumers. |
| Swipe components | Swipe | Feed, Profile, Recommendations | Swipe UI should emphasize sports compatibility and play intent, not dating-app cues. |
| Feed components | Feed | Profile, Swipe, Events, Notifications | Feed surfaces should guide useful action without becoming a generic social network. |
| Event components | Events | Feed, Profile, Chat, Maps, Notifications | Event UI should make time, place, capacity, organizer context, and participation state clear. |
| Chat components | Chat | Profile, Events, Teams, Notifications | Chat UI should support coordination toward real play, including match or event context. |
| Map components | Maps | Events, Profile, Feed | Map UI should communicate location with appropriate privacy and precision. |
| Notification components | Notifications | Feed, Events, Chat, Profile | Notification UI should reuse feedback and list patterns, and route users to the relevant domain context. |
| Animations | Design | All features | Motion should communicate state, reinforce intent, and remain consistent for similar changes. |
| Accessibility | Design | All features | Accessibility behavior is shared across design and feature owners. |

When ownership overlaps, agents should identify the primary user intent and the domain that owns the underlying product concept. Shared design areas should be extended before a domain creates a parallel pattern. If two domains need the same component behavior, document the overlap and route the change through design review before making it shared.

## Component Contribution Rules

These rules are guided by `tech-plans/approved/DESIGN-001-design-system.md` and `implementation/proposed/DESIGN-002-design-system-adoption.md`.

### Reuse-First Workflow

Before creating UI, contributors should:

1. Inspect `ScoutDesign` for an existing component, token, modifier, or preview that fits the need.
2. Prefer composing existing `ScoutDesign` primitives in the feature view.
3. Extend an existing component only when the concept already fits and the change benefits more than one consumer.
4. Create a new reusable component only when reuse is clear and the API can stay domain-free.
5. Keep feature-specific composition, copy, routing, data mapping, and business logic inside the feature.

Feature views should not copy package styling recipes for cards, chips, buttons, rows, states, or motion when a package component already fits.

### Creating Reusable Components

A new reusable component may be added to `ScoutDesign` when:

- At least two screens need the same UI pattern, or one pattern is foundational enough to justify reuse.
- The component can be expressed without feature-domain models.
- It uses existing Scout colors, typography, spacing, radius, stroke, shadow, and motion tokens.
- Its common states can be represented in Design Factory.
- The API is small, stable, and easy for feature views to compose.
- It does not duplicate an existing package component that could be extended.

Every new reusable component should:

- Live in `ScoutDesign`.
- Include relevant previews when useful.
- Include accessibility behavior or notes.
- Be represented in Design Factory once the Design Factory shell exists.
- Be referenced from the implementing Jira story.

### Extending Existing Components

Prefer extending an existing component when:

- The current component is conceptually correct but missing a variant, state, or configuration.
- The extension improves multiple consumers or an obvious cross-feature use case.
- The API can remain backward-compatible.

Do not extend an existing component when:

- The requested behavior is feature-specific.
- The change would move domain models, routing, or business logic into `ScoutDesign`.
- The component would become a broad catch-all with unclear purpose.

### Acceptable Duplication

Temporary duplication is acceptable when:

- A pattern appears only once.
- The reusable API is not clear yet.
- A feature is experimenting in a small surface area.
- Extracting immediately would create the wrong abstraction.
- The duplication is tracked as design debt if it is likely to spread.

Duplication is not acceptable when:

- A feature copies the visual behavior of an existing `ScoutDesign` component.
- A feature introduces local color, typography, spacing, radius, shadow, or motion scales.
- Multiple domains already need the same component.
- A one-off local style becomes the default for new work.

### Token Ownership

`ScoutDesign` owns reusable color, typography, spacing, radius, stroke, shadow, and motion tokens. Feature code may combine existing tokens for local composition, but it must not introduce parallel token scales.

Token changes require approved design work. New token names should describe semantic purpose rather than a single screen.

### Design Factory Expectations

Design Factory is the expected visual workbench for reusable UI once the approved debug entry and shell exist. Reusable components should have Design Factory coverage before broad production adoption.

Design Factory examples should show:

- Existing tokens and token names.
- Component variants and common states.
- Loading, empty, error, selected, disabled, pressed, and motion states where relevant.
- Accessibility notes when a component has non-obvious behavior.

Design Factory must remain internal/debug tooling according to the approved access policy. Production feature screens should compose reusable components from `ScoutDesign`; they should not become the first or only place where a reusable component state can be inspected.

### UI Contribution Checklist

Before opening a UI PR, confirm:

- Existing `ScoutDesign` components and tokens were checked first.
- Any new reusable component belongs in `ScoutDesign`, not a feature folder.
- Any feature-local styling has a clear reason to remain local.
- No duplicate tokens or local token scales were introduced.
- Loading, empty, error, disabled, selected, and pressed states are covered where applicable.
- Accessibility, Dynamic Type, touch targets, contrast, and reduced motion were considered.
- Screenshots are included for visible UI changes.
- Design Factory coverage is included or explicitly deferred for reusable component work.

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
