# Tech Plan: Scout Design System Foundation

## Status

Approved

## Owner

TODO

## Product Domain

DESIGN

## Current Approved State

- Existing iOS design assets remain the source of truth.
- Current design implementation remains under `Scout/Design/`.
- No design tokens or cross-platform design tooling are being introduced yet.
- Web should follow the documented Scout design language in the future rather than sharing implementation.
- Any change to typography, spacing, color scales, design token strategy, or cross-platform design tooling requires an approved design proposal before implementation.

## Problem Statement

Scout already has iOS design assets and components, but the product needs a long-term design foundation before larger profile, swipe, feed, event, chat, and future web work expands the surface area. Without a shared design philosophy and system hierarchy, future agents may introduce inconsistent colors, typography, spacing, components, motion, accessibility behavior, and interaction patterns.

This plan establishes the design bible for Scout. It defines how Scout should feel, how future UI decisions should be made, and how AI agents should work inside the design system.

## Design Philosophy

Scout should feel:

- Friendly and approachable to beginners.
- Competitive without being intimidating.
- Premium, polished, and highly animated.
- Social rather than transactional.
- Playful with subtle personality.
- Clean and information-dense without feeling cluttered.

Scout should avoid anything that feels like:

- LinkedIn.
- Facebook.
- Generic enterprise software.
- Material Design by default.
- A dating app, despite swipe interactions.

The product should feel like a sports companion that helps people find momentum: clear enough for beginners, polished enough for serious players, and social enough to make real-world play feel natural.

## Experience Principles

Scout's design system is not only visual. It should shape how people feel while moving from digital discovery to real-world play.

- Reduce anxiety when joining new games, groups, or events.
- Encourage confidence without arrogance.
- Make local sports feel welcoming, especially for beginners.
- Reward participation over perfection.
- Help users build real-world relationships rather than maximize screen time.
- Make users feel prepared before showing up to play.
- Make social risk feel smaller through clear context, expectations, and recovery paths.
- Celebrate momentum, consistency, and contribution.
- Treat competitive signals as useful context, not status theater.
- Optimize for getting people onto the court, not keeping them inside the app.

Every major feature should ask: does this help someone feel more ready, welcome, and confident to play?

## Design Principles

- Motion should communicate state, not just decorate.
- Every screen should have one obvious primary action.
- Minimize cognitive load.
- Prefer progressive disclosure.
- Reuse existing components before creating new ones.
- Empty states should educate the user.
- Errors should always suggest a recovery path.
- Sports context should be scannable at a glance.
- Trust and safety cues should be visible where user decisions depend on them.
- UI density should come from hierarchy and grouping, not visual noise.
- Platform conventions matter, but Scout should still feel ownable and distinct.
- Native iOS behavior should follow Apple's Human Interface Guidelines unless there is a documented reason to diverge.

## Goals / Non-goals

### Goals

- Define Scout's design philosophy.
- Establish durable design principles.
- Define the design system hierarchy.
- Document current approved design state.
- Define animation philosophy.
- Define future AI rules for UI work.
- Support consistent iOS and future web experiences.
- Prepare future Jira tickets for design documentation, audit, and component standardization.

### Non-goals

- Redesign the app.
- Replace existing components.
- Add new production UI.
- Introduce design tokens.
- Introduce cross-platform design token tooling.
- Change asset catalogs, colors, typography, spacing, or build settings.
- Share implementation between iOS and web.

## User Stories

- As a player, I want Scout screens to feel friendly and polished so that I feel comfortable using the app.
- As a beginner, I want sports information explained clearly so that I can participate without feeling judged.
- As a competitive player, I want the product to feel credible and high-quality so that I trust it for real games.
- As a designer, I want a durable design philosophy so that new features feel connected.
- As an iOS engineer, I want clear rules before adding components so that I do not duplicate existing design work.
- As a future web engineer, I want shared design language so that web feels like Scout without sharing implementation.
- As an AI coding agent, I want explicit UI rules so that generated UI fits the product.

## UX Flow

Design system work supports user flows rather than owning one direct flow:

1. User enters onboarding, profile, swipe, feed, event, or chat surface.
2. User sees consistent navigation, typography, controls, loading states, feedback, and motion.
3. User recognizes repeated patterns across features.
4. User sees one clear primary action.
5. User can progressively reveal more detail when needed.
6. User receives helpful recovery guidance when something goes wrong.

## Architecture

Current iOS design areas:

- `Scout/Design/Assets.xcassets`
- `Scout/Design/Components`
- `Scout/Design/Modifiers`
- `Scout/Design/Preview`
- `Scout/Design/Theme`
- `Scout/Design/Typography`

Future design work should inspect these areas before creating new UI primitives. Existing components should be extended when they fit the use case.

Apple's Human Interface Guidelines are the baseline for platform behavior on iOS. Scout should intentionally follow native navigation, gestures, controls, accessibility behavior, and interaction expectations unless an approved design plan documents why a custom pattern is better for Scout.

### Approved Direction

This plan approves Scout's design philosophy, design principles, design system hierarchy, animation philosophy, and AI rules.

It does not approve implementation changes to assets, components, tokens, typography, spacing, colors, or platform tooling.

## Design System Hierarchy

### Foundations

Foundations define the raw design language:

- Color.
- Typography.
- Spacing.
- Icons.
- Elevation.
- Shape.
- Layout rhythm.
- Motion timing.

Foundation changes require an approved design proposal.

### Navigation

Navigation patterns should define:

- Root app structure.
- Tab or section navigation.
- Stack navigation.
- Modal presentation.
- Sheet presentation.
- Back and dismiss behavior.
- Deep links or future web routes.

Every navigation surface should preserve a clear sense of place.

### Inputs

Input components should support:

- Text entry.
- Pickers.
- Segmented controls.
- Toggles.
- Sliders or steppers.
- Sport and skill selectors.
- Date, time, and availability inputs.
- Location inputs.
- Media inputs.

Inputs should make required fields, validation, and recovery paths clear.

### Feedback

Feedback components should include:

- Loading states.
- Empty states.
- Error states.
- Success states.
- Inline validation.
- Toasts or banners if approved.
- Match feedback.
- Save confirmation.

Empty states should educate users and guide the next action. Errors should explain what happened and how to recover.

### Cards

Card patterns should support:

- Swipe cards.
- Profile summary cards.
- Feed cards.
- Event cards.
- Match cards.
- Invitation cards.

Cards should be scannable, stable in size where possible, and visually distinct from full-screen surfaces.

### Lists

List patterns should support:

- Feed lists.
- Profile detail lists.
- Participant lists.
- Search or discovery results.
- Settings lists.
- Notification lists.

Lists should prioritize density, grouping, and quick comparison without visual clutter.

### Profile Components

Profile components should include:

- Profile header.
- Profile media.
- Sport badges.
- Skill indicators.
- Availability summaries.
- Location or play area summaries.
- Bio and play style.
- Edit rows.
- Public preview patterns.

### Swipe Components

Swipe components should include:

- Candidate card.
- Decision controls.
- Gesture states.
- Match modal.
- Empty deck state.
- Loading and retry states.
- Context chips for sport, skill, availability, and distance.

Swipe UI must avoid feeling like a dating app. Sports compatibility and play intent should be more prominent than superficial judgment.

### Feed Components

Feed components should include:

- Activity cards.
- Suggested players.
- Suggested games or events.
- Profile completion prompts.
- Local play prompts.
- Empty and loading states.

Feed should feel social and useful, not like a generic social network.

### Event Components

Event components should include:

- Event card.
- Event detail header.
- Date and time presentation.
- Location presentation.
- Capacity and RSVP state.
- Organizer summary.
- Participant preview.
- Join, request, leave, and manage actions.

### Chat Components

Chat components should include:

- Conversation list item.
- Message bubble.
- Composer.
- Match or event context header.
- System message.
- Empty conversation state.
- Error and retry state.

Chat should support coordination toward real play rather than generic social posting.

### Animations

Animation patterns should cover:

- Screen transitions.
- Swipe decisions.
- Match confirmation.
- Loading transitions.
- Save and success feedback.
- Error recovery.
- Empty-state reveals.
- Event join feedback.

### Accessibility

Accessibility patterns should cover:

- Dynamic Type.
- VoiceOver labels and order.
- Color contrast.
- Touch target sizing.
- Reduced motion.
- Non-color-only state indication.
- Keyboard and focus expectations for future web.

## Consistency Rules

- Similar actions should always look and behave the same.
- Primary actions should be visually consistent across features.
- Secondary actions should be visually distinct from primary actions.
- Destructive actions should use consistent color, copy, confirmation, and placement patterns.
- Loading states should follow shared patterns.
- Error states should follow shared patterns and always offer a recovery path.
- Empty states should follow shared patterns and educate users on what to do next.
- Spacing and typography should be predictable across screens.
- Component behavior should remain consistent across Profile, Swipe, Feed, Events, Chat, Maps, and future surfaces.
- Animation behavior should be consistent for similar state changes.
- Navigation and dismissal should follow native iOS expectations unless a design plan approves a custom pattern.
- Feature-specific UI may add personality, but it must not create a parallel design language.

## Feature Ownership Matrix

| Design System Area | Owned By | Consumed By | Notes |
| --- | --- | --- | --- |
| Foundations | Design | All features | Color, typography, spacing, icons, elevation, shape, and motion timing. |
| Navigation | App / Design | Profile, Swipe, Feed, Events, Chat, Maps | Must follow platform expectations and preserve clear location. |
| Inputs | Design | Profile, Events, Chat, Maps, Settings | Reuse form, picker, selector, and validation patterns. |
| Feedback | Design | All features | Loading, empty, error, success, and recovery states should be shared. |
| Cards | Design | Swipe, Feed, Events, Profile, Chat | Card variants should extend shared card behavior rather than duplicate it. |
| Lists | Design | Feed, Events, Chat, Profile, Maps, Notifications | Lists should remain dense, scannable, and predictable. |
| Profile Components | Profile | Swipe, Events, Chat, Feed, Teams, Search | Profile summaries must stay consistent across consumers. |
| Swipe Components | Swipe | Feed, Profile, Recommendations | Swipe should emphasize sports compatibility, not dating-app cues. |
| Feed Components | Feed | Profile, Swipe, Events, Notifications | Feed should guide useful action without becoming a generic social network. |
| Event Components | Events | Feed, Profile, Chat, Maps, Notifications | Event patterns should make time, place, capacity, and participation clear. |
| Chat Components | Chat | Profile, Events, Teams, Notifications | Chat should support coordination toward real play. |
| Map Components | Maps | Events, Profile, Feed | Maps should communicate location with appropriate privacy and precision. |
| Animations | Design | All features | Motion should communicate state and reinforce intent. |
| Accessibility | Design | All features | Accessibility behavior is a shared responsibility. |

Before creating a new UI component, future agents should identify the relevant owner and consumers from this matrix and inspect existing components in that area.

## Animation Philosophy

Animations should:

- Feel smooth and responsive.
- Reinforce user intent.
- Communicate state transitions.
- Never block interaction unnecessarily.
- Be consistent across the app.
- Follow Apple's Human Interface Guidelines while giving Scout its own personality.

Motion should make Scout feel polished and alive, but it should always serve comprehension, feedback, or confidence.

## Future Design Evolution

The design system should grow through extension, versioning, and refinement rather than duplication.

- New features should extend existing foundations before introducing new patterns.
- New components should be proposed only when existing components cannot be adapted cleanly.
- Component changes should preserve existing behavior unless a migration plan explains the change.
- Shared primitives should evolve through clear variants and documented states.
- Deprecated patterns should be documented and removed intentionally.
- Feature-specific components should graduate into shared components only after repeated use proves the need.
- Web should follow Scout's documented design language without requiring shared implementation.
- Design tokens or cross-platform tooling should be introduced only through an approved design proposal.

Scout should avoid parallel component libraries. Multiple ways to solve the same UI problem make the app harder to maintain and make AI-generated work less reliable.

## Future AI Rules

AI agents working on UI must:

- Reuse existing components whenever possible.
- Never invent a new component if an existing one can be extended.
- Never change typography, spacing, or color scales without an approved design proposal.
- Include screenshots in PRs for UI changes.
- Reference `DESIGN-001` in every UI-related Jira ticket.
- Inspect `Scout/Design/` before editing UI.
- Preserve platform conventions unless the approved plan says otherwise.
- Document loading, empty, error, and accessibility states in UI tickets.
- Follow Apple's Human Interface Guidelines as the baseline for iOS behavior unless an approved design plan documents a divergence.
- Identify the relevant design system owner and consumers before introducing or changing UI.

Every UI implementation ticket must document:

- Existing components reused.
- New components introduced, if any.
- Why any new component is necessary.
- Accessibility considerations.
- Loading state.
- Empty state.
- Error state.
- Screenshots required for review.
- Animations affected.
- Any divergence from Apple's Human Interface Guidelines.

## Database Changes

No database changes.

## API / Service Changes

No API or service changes.

## UI Components

This plan defines the hierarchy for future UI components, but it does not approve implementing or changing components.

Future component implementation should be ticketed only after the relevant feature plan or design proposal is approved.

## Dependencies

- Existing iOS design files.
- Product decisions for brand voice and visual identity.
- Accessibility requirements.
- Apple's Human Interface Guidelines.
- Future web migration timing.
- Approved feature plans for profile, swipe, feed, events, and chat.

## Milestones

1. Approve design philosophy and principles.
2. Document current iOS design inventory.
3. Expand `docs/design/DESIGN_SYSTEM.md` into the living design bible.
4. Document existing component hierarchy and gaps.
5. Define accessibility checklist.
6. Document feature ownership matrix.
7. Propose semantic color, typography, and spacing tokens only when implementation is ready.
8. Create implementation tickets only after approvals.

## Risks

- Agents may create new components instead of reusing existing ones.
- A highly animated product may become distracting if motion lacks purpose.
- Cross-platform token work may introduce complexity before web migration.
- The swipe surface may accidentally feel like a dating app if sports context is not prioritized.
- Documentation may drift from implementation if UI PRs do not reference the design plan.
- Accessibility may be deferred if not included in every feature plan.
- Features may create parallel components if ownership and consumers are not checked first.
- UI may drift from native iOS expectations if HIG divergence is not documented.

## Testing Strategy

Documentation-only validation:

- Verify design docs reference existing iOS design folders.
- Verify DESIGN-001 is referenced in future UI-related Jira tickets.
- Verify UI tickets include reused components, new components, accessibility, loading, empty, error, screenshots, and animations affected.
- No build required unless design assets or Swift files change.

Future implementation validation:

- PR screenshots for UI changes.
- iOS previews where available.
- Manual animation checks.
- Manual native interaction checks against Apple's Human Interface Guidelines.
- Manual Dynamic Type checks.
- VoiceOver spot checks.
- Reduced Motion checks when animations are added.
- Unit or snapshot tests if introduced.
- `make build` for UI code changes.

## Rollout Plan

1. Move this plan to `tech-plans/approved/`.
2. Use DESIGN-001 as the authority for UI-related Jira tickets.
3. Expand `docs/design/DESIGN_SYSTEM.md` from this plan.
4. Generate documentation and audit tickets first.
5. Propose implementation tickets separately for component, token, animation, or accessibility changes.

## Definition of Done

- Design system foundation approved.
- Design philosophy documented.
- Experience principles documented.
- Design principles documented.
- Current approved design state documented.
- Design system hierarchy documented.
- Consistency rules documented.
- Feature ownership matrix documented.
- Animation philosophy documented.
- Future AI rules documented.
- Apple's Human Interface Guidelines documented as the iOS baseline.
- Future implementation tickets are blocked on approved component, token, or design proposals where needed.

## Jira Breakdown Candidates

- `DESIGN: Expand design system bible from DESIGN-001`
- `DESIGN: Inventory current iOS design components`
- `DESIGN: Document current color usage and semantic roles`
- `DESIGN: Document current typography usage`
- `DESIGN: Document current spacing and layout patterns`
- `DESIGN: Define animation guidelines for Scout UI`
- `DESIGN: Create accessibility checklist for UI tickets`
- `DESIGN: Add DESIGN-001 reference requirement to UI ticket template`
- `DESIGN: Add UI ticket checklist for states, screenshots, and animations`
- `DESIGN: Document HIG divergence review process`

These are documentation and planning tickets unless a later approved design proposal authorizes implementation changes.

## Open Questions

- What are Scout's canonical brand colors?
- Should design tokens be iOS-only initially?
- Which components must be standardized before profile and swipe expansion?
- What animation patterns are signature Scout interactions?
- How should future web consume design guidance?
- What PR screenshot format should UI changes require?
- Which feature owns Maps design patterns?
- What level of animation is signature versus excessive?
- How should component versioning be documented?
