# UI Pattern Inventory

## Purpose

This inventory documents duplicated or reusable-looking UI patterns for CORE-10. It is a planning artifact for future ScoutDesign adoption work and does not approve or implement migrations.

## Review Boundaries

Reviewed app areas:

- `Scout/Scout/Profile`
- `Scout/Scout/Swipe`
- `Scout/Scout/Feed`
- `Scout/Scout/AuthGate`
- `Scout/Scout/Shared`
- `Scout/Scout/App`
- `Scout/Scout/Design`
- `Scout/ScoutDesign/Sources/ScoutDesign`

Related plans:

- `tech-plans/approved/DESIGN-001-design-system.md`
- `implementation/proposed/DESIGN-002-design-system-adoption.md`
- `docs/design/DESIGN_SYSTEM.md`

No production UI files were changed.

## Ownership Legend

| Owner | Meaning |
| --- | --- |
| `ScoutDesign` | Candidate for a reusable package primitive or package extension after a focused implementation story. |
| Feature-local | Should remain in the feature because it carries feature content, domain logic, gesture physics, or one-off composition. |
| App-local | Should remain in app infrastructure because it depends on app navigation, routing, or shell state. |
| Temporary duplication | Acceptable for now; revisit when another consumer appears or when the feature is already being touched. |

## Pattern Candidates

| Pattern | Current examples | Owner recommendation | Next action |
| --- | --- | --- | --- |
| Loading state surface | `RootView`, `LoginView`, `SignupView`, `OnboardingView`, `ProfileBuilderView`, `FeedScreen`, `SwipeDeckScreen`, `PlayerBackgroundView`, `MatchView` use raw `ProgressView`. | `ScoutDesign` | Create a focused story for a shared loading state or extend `ScoutStateCard` with loading support. |
| Empty and error state cards | `FeedScreen` uses `ScoutStateCard`; login/signup/profile/onboarding use alerts or inline spinners instead of a shared state surface. | `ScoutDesign` with feature composition | Use `ScoutStateCard` where a full surface is needed; keep alert validation local. |
| Chip and pill styling | `FeedCategoryFilterButtonStyle`, `FeedPostShell.reactionPill`, `FeedProfileChip`, `SwipeTagPill`, `SwipeCardIdentitySection.intentChip`, `AvailabilityGridView` cells, onboarding step chip. | `ScoutDesign` extension candidate | Inventory variants before implementation; extend `GlassChip` or `ScoutStatPill` only for variants with multiple consumers. |
| Feed post card shell | `FeedPostShell`, `FeedStatPost`, `FeedImagePost`, `FeedUpcomingMatchupPost`, `FeedRivalryPost`, `FeedHotspotPost`, `FeedMatchUpdatePost`, `FeedAchievementPost`. | Feature-local now, possible `ScoutDesign` shell later | Keep feed composition local; consider a package card shell only after another feature needs the same post chrome. |
| Swipe metric/stat tiles | `SwipeMetricTileView`, `SwipeCardMatchupSection` statistic tiles, `SwipeStatHighlightsSection`, `SwipeBestOverlapTeaser`, `StarStatView`. | `ScoutDesign` extension candidate | Compare against `ScoutStatTile` and `ScoutSignalCard`; promote only domain-free stat/tile primitives. |
| Glass cards and panels | `GlassCard` is used directly in profile, onboarding, and swipe; Feed and bottom navigation define local glass recipes. | Mixed | Keep `GlassCard` default; audit repeated feed/nav glass recipes before adding more package surfaces. |
| Form rows and selection rows | `ProfileBuilderView` summary rows and field rows, onboarding fields, `LocationStatusRow`, `SportCard`. | Mixed | Use `ScoutSelectionRow` where it fits; keep form validation and domain-specific rows feature-local. |
| Photo/media placeholders | Onboarding photo picker, profile photo placeholders, `FeedRemoteImage`, `PlayerBackgroundView`. | Temporary duplication | Keep feature-local until media loading/error requirements align across features. |
| Primary and secondary buttons | Profile/onboarding use package button styles; feed has `FeedPrimaryCTAButtonStyle`; match modal defines custom action buttons. | Mixed | Package styles are the default. Keep celebratory/modal-specific buttons local unless repeated. |
| Icon buttons and icon treatments | Bottom navigation buttons, feed overflow, match modal close/actions, swipe top bar buttons, photo placeholders, star ratings. | Mixed | Use `ScoutIconButton` for standard circular icon controls; document exceptional icon sizes in Design Factory before abstraction. |
| Segmented/filter controls | Feed category filters; future profile/onboarding choices use cards/rows instead of segmented controls. | `ScoutDesign` when general | Prefer `ScoutSegmentedToggle` for true segmented choices; keep feed filter chips local until chip API supports filter state. |
| Motion roles | `ScoutMotion.press` and `ScoutMotion.selection` are used; onboarding/profile transitions and swipe deck gestures use direct SwiftUI animations. | Mixed | Keep gesture physics feature-local; package repeated press, selection, loading, and state transition motion roles. |
| Bottom navigation chrome | `ScoutBottomNavigationBar` uses Scout tokens but depends on `ScoutHomeTab`, navigation style, visibility, chrome mode, and app callbacks. | App-local | Do not move until a navigation ownership story defines a domain-free API boundary. |

## Feature Area Inventory

### Profile

Specific duplicated patterns:

- `ProfileBuilderView` uses package structure well, but still defines local summary rows, text field rows, photo placeholders, and review rows.
- The save action uses a raw `ProgressView` inside a package-styled button.
- Photo placeholder icon treatment uses direct `.system(size: 40, weight: .semibold)`.
- Step motion uses direct `.easeInOut`.

Recommended ownership:

- Keep profile field validation, profile-specific copy, photo selection behavior, and review composition feature-local.
- Consider extending `ScoutSelectionRow` or adding a domain-free form field row only after onboarding and profile agree on the same row requirements.
- Treat loading as a `ScoutDesign` candidate because the same raw spinner pattern appears across multiple features.

Acceptable temporary duplication:

- Profile photo placeholders can remain local until feed, onboarding, and profile media loading requirements are compared.

### Swipe

Specific duplicated patterns:

- `SwipeTagPill` duplicates a reusable chip/pill shape with neutral, accent, and info variants.
- `SwipeMetricTileView` duplicates reusable stat tile behavior with progress bars and glass surfaces.
- `SwipeCardMatchupSection` contains domain-specific stat tiles that resemble `ScoutStatTile` or `ScoutSignalCard`.
- `SwipeCompactHeaderCard` and overlay views define custom glass panels.
- `SwipeDeckScreen`, `PlayerBackgroundView`, and `MatchView` use raw `ProgressView`.
- `MatchView` has custom buttons, icon sizes, direct system fonts, hard-coded padding, and modal-only visual treatment.
- `SwipeDeckView` and `SwipeDeckInteractionViewModel` use direct spring/ease animations for gesture physics.

Recommended ownership:

- Keep swipe deck gestures, card physics, player background imagery, and match celebration composition feature-local.
- Promote only domain-free stat tile, chip, and loading patterns after a focused story defines stable APIs.
- Keep swipe-specific overlay surfaces local until another feature needs the same overlay behavior.

Acceptable temporary duplication:

- Swipe gesture and match-modal motion are acceptable local duplication because they communicate feature-specific state.

### Feed

Specific duplicated patterns:

- `FeedPostShell` creates a reusable-looking feed card shell with header, footer, accent stripe, overflow control, reaction pills, and shadow.
- Feed post variants repeat card and stat patterns across stat, image, matchup, rivalry, hotspot, match update, and achievement posts.
- `FeedCategoryFilterButtonStyle` duplicates a filter chip/pill state.
- `FeedProfileChip` combines an avatar, text stack, and glass fill.
- `FeedPrimaryCTAButtonStyle` duplicates a compact call-to-action button.
- `FeedRemoteImage` contains a reusable-looking remote image placeholder and corner masking helper.
- `FeedScreen` uses `ScoutStateCard` for empty/error but raw `ProgressView` for loading.

Recommended ownership:

- Keep `FeedPostShell` feature-local for now because it is tied to `FeedPreviewPost`.
- Consider a `ScoutDesign` card shell only if non-feed surfaces need the same accent stripe, footer, and glass recipe.
- Treat feed filters as a future `GlassChip`/filter-chip extension only after swipe/onboarding chip states are compared.
- Treat remote image placeholders as temporary duplication until media behavior is needed outside feed/profile/onboarding.

Acceptable temporary duplication:

- Feed post visual variety can remain feature-owned while the feed product surface is still evolving.

### Auth and Onboarding

Specific duplicated patterns:

- Onboarding field rows are locally composed inside `OnboardingView`.
- `LocationStatusRow` is a reusable-looking status row, but its icon, copy, and authorization states are location-specific.
- `SportCard` resembles a selectable card and uses `scoutGlassSelectableSurface`.
- Login, signup, and onboarding save actions use raw `ProgressView`.
- Onboarding uses direct `.default` animation and direct `withAnimation` calls in the view model.
- Photo picker and selected photo placeholders overlap conceptually with profile media placeholders.

Recommended ownership:

- Keep location and sport selection rows feature-local while their domain states are specific to onboarding.
- Prefer package form components for new onboarding/profile form work.
- Promote a domain-free form field row only if profile builder and onboarding require the same visual and validation structure.
- Move loading treatment to a shared package pattern.

Acceptable temporary duplication:

- Onboarding photo placeholders may remain local until media upload and profile photo states stabilize.

### Shared

Specific duplicated patterns:

- `StarStatView` overlaps with ratings displays in swipe and potentially profile stat presentation.
- Shared currently contains little reusable UI, so many cross-feature-looking patterns live directly in feature folders.

Recommended ownership:

- Prefer `ScoutDesign` over `Shared` for visual primitives.
- Use `Shared` only when the component depends on app domain models or product concepts that do not belong in `ScoutDesign`.

Acceptable temporary duplication:

- Keep `StarStatView` local/shared until ratings presentation requirements are compared with swipe and profile.

### App Navigation

Specific duplicated patterns:

- `ScoutBottomNavigationBar` duplicates glass chrome, icon buttons, selected state styling, compact/expanded behavior, and press motion.
- It depends on app-level navigation types and callbacks.

Recommended ownership:

- Keep as app-local until a dedicated ownership decision defines whether any domain-free navigation chrome belongs in `ScoutDesign`.
- Do not migrate it opportunistically.

Acceptable temporary duplication:

- Navigation-specific chrome can remain app-owned because moving it too early would leak app routing concepts into `ScoutDesign`.

## Prioritized Follow-Up Stories

1. Define a shared loading state pattern.
   - Candidate owner: `ScoutDesign`.
   - Current consumers: App, Auth/Onboarding, Profile, Feed, Swipe.
   - Reason: broad repetition and small API surface.

2. Audit chip and pill variants into a single taxonomy.
   - Candidate owner: `ScoutDesign`.
   - Current consumers: Feed filters/reactions/profile chips, Swipe tags/intent chips, Onboarding progress/sport chips.
   - Reason: repeated capsule recipes with selected, neutral, accent, metadata, and filter states.

3. Compare stat tile and metric tile APIs.
   - Candidate owner: `ScoutDesign` if domain-free.
   - Current consumers: Swipe metric tiles, swipe matchup tiles, feed stat posts, shared star stats.
   - Reason: stat display is a cross-feature product pattern.

4. Decide remote media placeholder ownership.
   - Candidate owner: feature-local until requirements converge.
   - Current consumers: Feed remote images, profile photos, onboarding photos, swipe backgrounds.
   - Reason: similar visuals but different loading/error/media semantics.

5. Keep bottom navigation out of ScoutDesign until ownership is decided.
   - Candidate owner: app-local.
   - Current consumers: App shell only.
   - Reason: app state and routing are not design-system concerns.

## Design Debt Versus Acceptable Duplication

Design debt:

- Raw loading spinners repeated across app launch, auth, onboarding, profile, feed, and swipe.
- Local chip/pill variants with similar shape, padding, token usage, and selected/accent states.
- Direct system fonts in reusable-looking labels, feed headers, modal actions, and icon treatments.
- Repeated glass card/surface recipes that are close to package components but not yet named.

Acceptable temporary duplication:

- Swipe gesture physics and card interaction motion.
- Match modal celebration layout and action treatment.
- Feed post shell while feed product content is still domain-specific.
- Onboarding/profile/media placeholders until upload, remote image, and empty/error requirements converge.
- Bottom navigation chrome while app navigation ownership remains unresolved.

## Validation

This inventory is documentation-only. Production Swift files were inspected but not modified.
