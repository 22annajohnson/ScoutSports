# Scout Design System Tasks

## Goal
- Build a modern, dark, glass-forward UI layer for Scout that matches the current product direction without forcing a broad app rewrite.
- Use the inspiration screens as the visual target: high-contrast dark surfaces, frosted chips/cards, cyan-to-violet accent gradients, soft glows, rounded geometry, and strong typography hierarchy.
- Roll the work out in small, reviewable steps that can land as clear commits/PRs while keeping the app functional at every stage.
- Prepare the design layer so it can later be extracted into a local package once the API surface is proven inside the app.

## Visual Direction From Inspiration
- Base theme: near-black backgrounds with slightly lifted charcoal surfaces.
- Glass treatment: liquid glass for floating controls, top chips, stat capsules, bottom actions, and modal/card surfaces.
- Accent system: electric cyan to violet gradient used sparingly for emphasis, selection, progress, and CTA states.
- Shape language: large continuous corner radii, capsule chips, softly inset cards, and roomy spacing.
- Typography: bold hero headlines, compact uppercase micro-labels, strong stat numerals, and restrained supporting copy.
- Motion: subtle depth, blur, fade, and spring transitions that make the UI feel tactile rather than ornamental.

## Constraints
- Keep the current IA and product flows intact.
- Avoid mixing design-system setup with unrelated data/model refactors.
- Prefer replacing repeated ad hoc styling with reusable primitives over one-off screen polish.
- Where liquid glass APIs are version-gated, provide a clean fallback using SwiftUI materials so the system stays usable across supported OS versions.

## Proposed File Shape
- `Scout/Design/Theme/` for tokens and theme models.
- `Scout/Design/Typography/` for font roles and text treatments.
- `Scout/Design/Components/` for reusable controls and surfaces.
- `Scout/Design/Modifiers/` for shared view modifiers such as card chrome, glow, and glass treatments.
- `Scout/Design/Preview/` for design-system previews and component galleries.
- Keep feature-specific composition in `AuthGate/`, `Profile/`, and `Swipe/` until the reusable API is stable.

## Delivery Plan

### Phase 1: Foundation Tokens
- [ ] Define semantic color tokens for app background, elevated surface, glass stroke, primary text, secondary text, positive state, destructive state, and accent gradient stops.
- [ ] Replace direct color literals/usages with semantic `Color` accessors where practical in touched views.
- [ ] Expand typography beyond `fonts.swift` into a more complete type scale with hero, title, body, label, number, and micro-label roles.
- [ ] Define spacing, corner radius, stroke width, shadow, blur, and glow constants in one place.
- [ ] Add a lightweight theme reference doc inside the code comments or preview area so contributors know which token to use.

### Phase 2: Core Glass Primitives
- [ ] Create a reusable glass surface container for cards and sheets.
- [ ] Create a reusable glass pill/chip component for tags, filters, and top badges.
- [ ] Create a primary gradient CTA style and a secondary glass CTA style.
- [ ] Create reusable stat tile and metric row components.
- [ ] Create a reusable selection row style for onboarding/profile options.
- [ ] Create a bottom action dock treatment for swipe/profile flows.

### Phase 3: Screen Composition Rules
- [ ] Define page-level layout patterns for full-bleed hero screens, form flows, and sheet/modal content.
- [ ] Standardize navigation/header treatments including title, dismiss/back controls, and progress placement.
- [ ] Standardize section spacing, label spacing, and safe-area behavior for long scrolling screens.
- [ ] Document when to use full-bleed imagery, when to use elevated cards, and when to keep content flat.

### Phase 4: Swipe Experience Restyle
- [ ] Update the swipe deck/player card presentation to use the new glass chips, hero overlays, stat tiles, overlap chart card, and bottom action dock.
- [ ] Convert current debug/profile actions to use the new chip/button language where appropriate.
- [ ] Tune hierarchy so the player photo remains dominant and metadata reads clearly over imagery.
- [ ] Keep swipe interaction mechanics unchanged in this phase unless styling work exposes a real UX issue.

### Phase 5: Onboarding Restyle
- [ ] Restyle onboarding into a more premium multi-step flow using the shared header, card, selection row, and CTA components.
- [ ] Introduce consistent step cards for skill/style/rating inputs instead of rebuilding styling per step.
- [ ] Use glass surfaces and accent gradients to emphasize selection and progress, not as background noise.
- [ ] Preserve all existing onboarding logic and validation behavior.

### Phase 6: Profile Builder Restyle
- [ ] Restyle the profile builder shell, step cards, media pickers, sliders/rating controls, and footer actions with the new component system.
- [ ] Unify photo placeholders, preview chrome, and review-step presentation with the swipe card visual language.
- [ ] Ensure forms still feel efficient and editable, not over-decorated.

### Phase 7: Motion, States, and Polish
- [ ] Add shared animation guidance for press states, selection transitions, card entry, glass highlight shifts, and step changes.
- [ ] Add loading, empty, disabled, and error state styling that matches the new theme.
- [ ] Audit contrast/readability over image backgrounds and glass surfaces.
- [ ] Validate dynamic type behavior and touch target sizing on core controls.

### Phase 8: Package Extraction Prep
- [ ] Audit which `Scout/Design` types are truly reusable versus still app-specific.
- [ ] Move only stable tokens, modifiers, and generic components behind a clean API surface.
- [ ] Create a local package after at least two feature areas are successfully using the shared primitives.
- [ ] Keep feature compositions and product-specific copy outside the package.

## Suggested PR Sequence

### PR 1: Theme Tokens
- Scope:
  Create semantic colors, typography roles, spacing/radius constants, and any basic gradient definitions.
- Likely touch points:
  `Scout/Design/`
- Done when:
  New design tokens exist and at least one preview or small usage proves they compile cleanly.

### PR 2: Glass Surface Kit
- Scope:
  Add reusable glass card, pill, button, and stat-tile primitives with previews.
- Likely touch points:
  `Scout/Design/Components/`
  `Scout/Design/Modifiers/`
- Done when:
  Shared building blocks can reproduce the visual language from the inspiration screens in isolation.

### PR 3: Layout and Navigation Shell
- Scope:
  Add page shell/header/footer patterns for onboarding and profile flows.
- Likely touch points:
  `Scout/Design/`
  small integration points in `AuthGate/` or `Profile/`
- Done when:
  Feature screens can adopt a common structural wrapper without changing their business logic.

### PR 4: Swipe UI Pass
- Scope:
  Restyle `Swipe` screens using the new kit, especially hero header, stat section, chips, overlap card, and bottom actions.
- Likely touch points:
  `Scout/Swipe/Views/`
  shared design primitives as needed
- Done when:
  The swipe experience visually matches the target direction while retaining current behavior.

### PR 5: Onboarding UI Pass
- Scope:
  Apply the design system to onboarding steps and shared controls.
- Likely touch points:
  `Scout/AuthGate/Views/Onboarding/`
  shared design primitives as needed
- Done when:
  Onboarding looks cohesive with swipe and uses shared components instead of local styling.

### PR 6: Profile Builder UI Pass
- Scope:
  Apply the design system to profile builder steps, media pickers, review, and footer actions.
- Likely touch points:
  `Scout/Profile/Views/`
  shared design primitives as needed
- Done when:
  Profile editing feels like the same product family as onboarding and swipe.

### PR 7: States and Motion
- Scope:
  Polish transitions, pressed/selected states, loading/empty/error treatments, and accessibility issues found during rollout.
- Done when:
  The app feels intentional and consistent in non-happy paths too.

### PR 8: Local Package Extraction
- Scope:
  Move stable design primitives into a local package without changing the visual result.
- Done when:
  The app imports a local design package for reusable tokens/components, while feature-level assembly stays in-app.

## Commit Strategy Inside Each PR
- Commit 1: add or adjust tokens/constants
- Commit 2: add reusable component(s) plus previews
- Commit 3: adopt components in one focused screen area
- Commit 4: cleanup naming/docs/previews if needed

## Recommended First Deliverables
- [ ] Semantic color and gradient palette.
- [ ] Expanded typography roles and naming cleanup for `fonts.swift`.
- [ ] `GlassCard`, `GlassChip`, `ScoutPrimaryButtonStyle`, and `ScoutStatTile`.
- [ ] A small preview/gallery screen that shows the kit in one place before broad feature adoption.

## Review Checklist For Each PR
- [ ] Business logic unchanged unless explicitly in scope.
- [ ] Reusable styling extracted before duplicating view code.
- [ ] Visual contrast remains readable on dark/image-heavy surfaces.
- [ ] Buttons and chips have clear pressed, selected, disabled, and loading states.
- [ ] New design primitives are previewable/testable in isolation.
- [ ] `make build` passes after each phase.

## Notes For Package Extraction Later
- Do not package too early.
- Wait until the token names and primitive APIs survive real use in at least swipe plus one form flow.
- Package the minimum stable surface:
  theme tokens, button styles, card/pill/stat primitives, and shared modifiers.
- Leave Scout-specific feature compositions, copy, and screen orchestration inside the main app target.
