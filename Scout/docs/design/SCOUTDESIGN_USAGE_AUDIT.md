# ScoutDesign Usage Audit

## Purpose

This audit records the current adoption of the `ScoutDesign` Swift package across the iOS app for CORE-9. It is a documentation-only inventory intended to guide later migration stories without changing production UI.

## Sources Reviewed

- `tech-plans/approved/DESIGN-001-design-system.md`
- `implementation/proposed/DESIGN-002-design-system-adoption.md`
- `docs/design/DESIGN_SYSTEM.md`
- `Scout/Scout/**/*.swift`
- `Scout/ScoutDesign/Sources/ScoutDesign/**/*.swift`

## Current Package Surface

`ScoutDesign` is already a real local Swift package. Its reusable surface includes:

| Family | Current package examples |
| --- | --- |
| Color and theme | `Color.scout...`, `ScoutTheme.screenBackground`, `ScoutTheme.accentGradient` |
| Typography | `Font.scout...` semantic roles such as body, caption, pill, title, display, and number roles |
| Layout tokens | `ScoutLayout.Spacing`, `ScoutLayout.Radius`, `ScoutLayout.Stroke`, tracking values |
| Cards and surfaces | `GlassCard`, `ScoutCard`, `ScoutGlassPanel`, `ScoutGlassSelectableSurface`, `ScoutGradientSurface` |
| Chips and pills | `GlassChip`, `ScoutBadge`, `ScoutStatPill` |
| Buttons | `ScoutButton`, `ScoutIconButton`, `ScoutPrimaryButtonStyle`, `ScoutSecondaryGlassButtonStyle` |
| Structure | `ScoutPageHeader`, `ScoutSection`, `ScoutFooterBar`, `ScoutFormPageShell`, `ScoutHeroLayout` |
| Rows and controls | `ScoutSelectionRow`, `ScoutSegmentedToggle` |
| State and data display | `ScoutStateCard`, `ScoutStatTile`, `ScoutSignalCard`, `ScoutActionDock` |
| Motion | `ScoutMotion`, `scoutInteractiveScale`, `scoutPulseHighlight` |
| Preview inventory | Design foundation, glass component, layout, state, and motion previews |

## Adoption Snapshot

The app already imports `ScoutDesign` widely in UI-heavy areas:

| Area | Files importing `ScoutDesign` | Notes |
| --- | ---: | --- |
| App | 2 of 5 | Root tint/background and home screen navigation animation use design tokens. |
| AuthGate and Onboarding | 7 of 10 | Onboarding is one of the strongest adopters of form shells, headers, cards, chips, footers, button styles, and tokens. |
| Profile | 2 of 2 | Profile builder and view model both import `ScoutDesign`; the view uses package layout, cards, sections, headers, footer, chips, and selection rows. |
| Swipe | 22 of 31 | Swipe surfaces are token-heavy and use several package components, while still keeping many feature-specific overlays and gesture surfaces local. |
| Feed | 11 of 13 | Feed uses shared state cards, color tokens, motion, spacing, and typography, but keeps post shells and category filters feature-local. |
| Shared | 1 of 2 | `StarStatView` uses semantic fonts and colors. |
| App-local design | 1 of 1 | `ScoutBottomNavigationBar` imports `ScoutDesign` but remains app-owned because it depends on app navigation state. |

Package token and component usage is broad:

| Usage pattern | Current reach |
| --- | --- |
| `Color.scout...` semantic colors | 34 Swift files |
| Semantic Scout fonts | 26 Swift files |
| `ScoutLayout` spacing/radius/stroke tokens | 28 Swift files |
| `ScoutTheme` | 12 Swift files |
| `GlassCard` | 7 app files |
| `GlassChip` | 5 app files |
| `ScoutStateCard` | 1 app file |
| `ScoutSection` | 3 app files |
| `ScoutPageHeader` | 2 app files |
| `ScoutFooterBar` | 2 app files |
| `ScoutSelectionRow` | 1 app file |
| `ScoutMotion` or Scout motion modifiers | 5 app files |

## Feature Area Findings

### App

Strong adoption:

- `ScoutApp.swift` applies Scout tint using `Color.scout`.
- `ScoutHomeScreen.swift` uses `ScoutTheme.screenBackground`, `ScoutLayout.Spacing`, and `ScoutMotion.selection`.
- `ScoutBottomNavigationBar.swift` uses package colors, layout tokens, gradients, strokes, and `scoutInteractiveScale`.

Gaps:

- `ScoutBottomNavigationBar.swift` still has direct `.system(...)` fonts and a custom glass navigation recipe.
- Navigation chrome is coupled to `ScoutHomeTab`, `ScoutHomeNavigationStyle`, `ScoutHomeNavigationVisibility`, and `ScoutHomeChromeMode`, so it should stay app-owned until a clear reusable navigation API is approved.
- `RootView.swift` uses a raw full-screen `ProgressView`.

### AuthGate and Onboarding

Strong adoption:

- `OnboardingView.swift` uses `ScoutFormPageShell`, `ScoutPageHeader`, `GlassCard`, `ScoutSection`, `GlassChip`, `ScoutFooterBar`, Scout button styles, `ScoutLayout`, `ScoutTheme`, and semantic colors.
- `SportsCardView.swift` uses `GlassChip`, semantic fonts/colors, layout tokens, and `scoutGlassSelectableSurface`.
- `LocationRowView.swift` uses layout, semantic fonts/colors, radius, and stroke tokens.
- `LoginView.swift` and `SignupView.swift` import `ScoutDesign`.

Gaps:

- Login, signup, and onboarding save buttons still use raw `ProgressView` spinners.
- `OnboardingView.swift` and `LocationRowView.swift` contain direct `.system(...)` icon fonts.
- Some onboarding field rows and photo placeholders are locally composed even though they are close to package row/card patterns.
- Onboarding step motion currently uses `.default` animation rather than a named `ScoutMotion` role.

### Profile

Strong adoption:

- `ProfileBuilderView.swift` is heavily aligned with `ScoutDesign`: package headers, cards, sections, footer, chips, selection rows, button styles, semantic colors, semantic fonts, layout tokens, and `ScoutTheme.screenBackground`.
- Profile review and summary surfaces already follow shared card and row language in many places.

Gaps:

- Several local summary rows, field rows, media placeholders, and image/photo treatments repeat card and row recipes.
- The save footer uses a raw `ProgressView`.
- The step transition uses `.easeInOut` directly.
- At least one icon treatment uses a direct `.system(size: 40, weight: .semibold)` font.

### Swipe

Strong adoption:

- Swipe has the broadest import footprint, with most view files importing `ScoutDesign`.
- `SwipeCardIdentitySection.swift` and `SwipeCardMatchupSection.swift` use `GlassCard`, `GlassChip`, semantic fonts, semantic colors, layout tokens, and package radii/strokes.
- `SwipeMetricTileView.swift`, `SwipeCompactHeaderCard.swift`, `AvailabilityGridView.swift`, `SwipeBestOverlapTeaser.swift`, and related overlays use Scout color and layout tokens heavily.
- `SwipeCardOverlayScrollLayout.swift` uses `ScoutMotion.selection`.

Gaps:

- `SwipeTagPill.swift`, `SwipeMetricTileView.swift`, `AvailabilityGridView.swift`, and parts of the swipe overlay system define local pill, stat tile, and glass surface variants that may overlap with `GlassChip`, `ScoutStatPill`, `ScoutStatTile`, or `ScoutSignalCard`.
- `SwipeDeckScreen.swift`, `PlayerBackgroundView.swift`, and `MatchView.swift` use raw `ProgressView` loading states.
- `MatchView.swift` has many direct `.system(...)` fonts and hard-coded padding/radius values because it is a custom celebration modal.
- Swipe gesture physics and card motion use direct SwiftUI animations in the interaction model and deck view; these may remain feature-local unless repeated elsewhere.
- `RatingsView.swift`, `SwipeHeroTopBar.swift`, and `SwipeArcOverlay.swift` still contain direct system icon/text fonts.

### Feed

Strong adoption:

- `FeedScreen.swift` uses `ScoutStateCard` for empty and error states, `ScoutTheme.screenBackground`, `ScoutLayout`, semantic colors, and `ScoutMotion.press`.
- Feed post views import `ScoutDesign` and use semantic colors, typography, layout, and strokes.
- Feed posts consistently lean on Scout glass colors and gradient tokens.

Gaps:

- The feed loading state remains a raw `ProgressView`.
- `FeedCollapsibleHeaderView` is a feature-local glass header with hard-coded corner radius `30`, direct system fonts, local collapse metrics, and local category chip styling.
- Feed category filters duplicate pill/chip behavior instead of using or extending `GlassChip`.
- `FeedPostShell.swift` and post-specific files define repeated card/post chrome that should be inventoried before any package extraction.
- Several feed post accessory icons and labels use direct `.system(...)` fonts.

### Shared

Strong adoption:

- `StarStatView.swift` uses semantic Scout fonts and text colors.

Gaps:

- Shared still has very few reusable views, so repeated feature patterns are mostly living inside feature folders rather than `Shared` or `ScoutDesign`.
- Future shared UI should prefer `ScoutDesign` unless it is truly app-domain composition.

## Cross-Cutting Adoption Gaps

| Gap | Current examples | Suggested follow-up focus |
| --- | --- | --- |
| Raw loading states | `RootView`, `LoginView`, `SignupView`, `OnboardingView`, `ProfileBuilderView`, `FeedScreen`, `SwipeDeckScreen`, `PlayerBackgroundView`, `MatchView` | Define whether loading should be covered by `ScoutStateCard` or a new package loading component. |
| Direct system fonts | Feed header/posts, swipe modal/overlays, bottom navigation, onboarding/photo icons, profile icon treatments | Replace opportunistically with semantic Scout fonts, or propose new semantic roles where existing roles do not fit. |
| Local chip/pill recipes | Feed category filters, feed metadata pills, `SwipeTagPill`, availability cells, intent chips | Compare against `GlassChip` and `ScoutStatPill`; extend package only when the same variant has multiple consumers. |
| Local card/surface recipes | Feed header/post shells, swipe metric tiles, compact header, match modal panels, profile media placeholders | Keep feature composition local, but promote reusable shells after CORE-10 inventory identifies stable duplication. |
| Local animation roles | Onboarding/profile step transitions, swipe deck physics, match modal interactions | Gesture physics can stay local; repeated press/selection/state motion should use or extend `ScoutMotion`. |
| App-owned navigation chrome | `ScoutBottomNavigationBar` | Keep app-owned until CORE-17 or a later navigation API decision defines package boundaries. |

## Strong Adoption Areas

- Onboarding and Profile already demonstrate the intended reuse-first workflow for form-like experiences.
- Feed already uses `ScoutStateCard` for empty/error states.
- Swipe uses Scout tokens pervasively even where feature-specific composition remains local.
- The package already has previews for foundations, glass components, layout, state, and motion, which gives future Design Factory work a concrete source.

## Recommended Next Areas

1. Use CORE-10 to inventory duplicated UI patterns in Feed, Swipe, Profile, Auth/Onboarding, Shared, and App navigation.
2. Treat loading states as the most obvious cross-feature state gap.
3. Evaluate local chip/pill variants before extending `GlassChip` or `ScoutStatPill`.
4. Keep bottom navigation app-owned until its routing and state dependencies are deliberately separated.
5. Avoid token changes during migration unless a design plan explicitly approves the new semantic token.

## Validation

This audit is documentation-only. No production Swift files were changed.
