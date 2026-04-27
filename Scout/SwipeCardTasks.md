# Swipe Card Redesign Tasks

## Goal
- Shift the swipe screen toward a richer editorial-matchmaking feel with a cinematic hero image, stronger top-of-screen framing, and denser glass surfaces.
- Keep the card feeling like one immersive destination instead of a stack of disconnected panels.
- Roll the redesign out in reviewable PRs where each PR adds one clear visual system or one major content band.

## Updated Target Vibe
- A branded hero header lives over the image with `SCOUT`, a strong title, and location/match pills.
- The identity card feels like a premium glass panel with intent, name/age, summary, and metadata chips grouped together.
- A horizontal stat strip sits above the action dock and reads quickly.
- A large best-overlap card anchors the lower portion of the experience.
- The entire screen should feel darker, more atmospheric, and more intentional about spacing and hierarchy.

## Constraints
- Keep existing swipe mechanics intact.
- Reuse current glass/theme primitives where possible.
- Prefer swipe-specific composition views over broad design-system churn.
- Keep placeholder presentation logic local until the dedicated data-wiring pass.

## Current Status
- Done: structural background-image + overlay scroll layout
- Done: identity hero card
- In progress: metadata chip cluster / vibe shift toward the new reference

## Revised Build Order

### Interstitial Task: Swipe Architecture + Presentation Cleanup
- Scope:
  Do a feature-level cleanup pass across swipe so views are mostly responsible for UI, presentation/business shaping lives in view models, and older one-off components stop drifting out of sync.
- Tasks:
  - Move swipe-deck interaction logic out of `SwipeDeckView` into a dedicated deck interaction view model or reducer-style state object.
  - Consolidate swipe-card presentation shaping behind a single presentation builder so sections are assembled in one place instead of accumulating formatting helpers in multiple files.
  - Group loose view parameters into section models wherever a view is still taking several parallel values.
  - Replace raw state flags or tuple-based display state with small enums/models where the UI is really expressing a mode.
  - Identify older swipe views that are now preview-only or superseded and either retire them or clearly quarantine them from the active screen path.
  - Propose small services where they reduce coupling, especially for:
    - swipe-card presentation building
    - candidate scoring/ranking explanation formatting
    - availability/overlap chart data shaping
- Done when:
  The active swipe screen reads as composition-only UI, business/presentation shaping is centralized, and there is a clear boundary between live production views and legacy/preview-only swipe components.
- Specific hotspots to address:
  - `Scout/Swipe/Views/SwipeDeckView.swift`
    owns too much interaction state (`index`, `drag`, swipe direction/progress, dismissal timing, and match presentation).
  - `Scout/Swipe/ViewModels/PlayerSwipeCardViewModel.swift`
    is a good start, but it should become the single place for card presentation shaping rather than one of several formatting islands.
  - `Scout/Swipe/Views/RatingsView.swift`
    uses `@State` for injected data and should behave like a pure display view.
  - `Scout/Swipe/Views/PlayerHeroHeaderView.swift`
    and `Scout/Swipe/Models/HeroHeaderViewModel.swift`
    look superseded by the new hero/top-bar path and should either be removed from the active architecture or repurposed intentionally.
  - `Scout/Swipe/Views/SwipeCardMatchupSection.swift`
    and `Scout/Swipe/Views/SwipeStatHighlightsSection.swift`
    need a decision: active building blocks vs preview-only leftovers.
  - `Scout/Swipe/Views/AvailabilityGridView.swift`
    is moving in the right direction now that slot state is modeled, and it is a good pattern to continue elsewhere.

### PR 3: Hero Framing + Metadata Cluster
- Scope:
  Push the current UI closer to the new reference by refining the hero framing and attaching metadata chips directly to the identity card.
- Tasks:
  - Add the branded top header with title, location pill, distance pill, and matches pill.
  - Add reusable swipe metadata chips with wrapped layout.
  - Tune the identity card spacing so the summary and chips feel like one unit.
  - Keep the screen readable over the image background.
- Done when:
  The top portion of the screen immediately reads like the new reference and the metadata cluster no longer feels like a follow-on card.

### PR 4: Stat Highlights Band
- Scope:
  Replace the generic mid-screen analytical block with the horizontal highlight cards shown in the new reference.
- Tasks:
  - Build the three-card stat strip for `Skill`, `Matches`, and `Win Rate`.
  - Add lightweight progress accents inside each tile.
  - Tune card sizing so the strip works on smaller phones without clipping.
- Done when:
  The stat band reads as a quick-scan row above the dock and visually matches the new vibe.

### PR 5: Best Overlap Feature Card
- Scope:
  Add the large lower feature card centered on best overlap.
- Tasks:
  - Build the `Best Overlap` card with tags and a large score/value callout.
  - Tune hierarchy so the value is the hero element and the chips support it.
  - Keep the card visually anchored beneath the action row.
- Done when:
  The lower card feels like a destination panel rather than placeholder content.

### PR 6: Action Dock Style Integration
- Scope:
  Restyle and place the dock so it belongs to the new screen composition.
- Tasks:
  - Move from the older dock treatment toward the lighter circular-control feel in the reference.
  - Tune dock offset and spacing relative to the stat band and best-overlap card.
  - Keep swipe interaction affordances obvious and comfortable.
- Done when:
  The dock feels intentionally designed with the rest of the card instead of overlaid afterward.

### PR 7: Analytical Story Card
- Scope:
  Reintroduce a richer analytical card in the new visual language.
- Tasks:
  - Bring back the `Scout Read` concept as a darker, denser product card.
  - Include compact supporting reasoning, fit language, and small structured metrics.
  - Ensure it complements rather than competes with the stat strip and best-overlap card.
- Done when:
  The swipe experience has one strong narrative/analysis section in the updated style.

### PR 8: Preference Notes + Lower Details
- Scope:
  Add the smaller supporting notes and preference rows.
- Tasks:
  - Add rows for social vibe, scheduling habits, pace, or post-match preferences.
  - Omit missing content rather than rendering empty shells.
  - Keep these rows visually lighter than the hero and feature cards.
- Done when:
  The lower screen feels complete without becoming visually crowded.

### PR 9: Data Wiring and Content Quality Pass
- Scope:
  Replace placeholder numbers and phrases with realistic content.
- Tasks:
  - Wire real values for age, skill, matches, win rate, overlap tags, and summary copy where possible.
  - Add small presentation helpers only where needed.
  - Keep schema/backend changes out unless truly required.
- Done when:
  The redesigned screen is mostly driven by real profile/match data rather than mock values.

### PR 10: Motion, Polish, and Accessibility
- Scope:
  Final fit-and-finish pass for the new direction.
- Tasks:
  - Audit dynamic type, contrast, and text clipping.
  - Tune scroll feel and spacing transitions between sections.
  - Verify visual balance across smaller and larger phones.
  - Check image readability in bright and dark backgrounds.
- Done when:
  The redesigned swipe screen feels stable, intentional, and shippable.

## Suggested File Areas
- `Scout/Swipe/Views/PlayerSwipeScrollView.swift`
- `Scout/Swipe/Views/SwipeCardOverlayScrollLayout.swift`
- `Scout/Swipe/Views/SwipeCardIdentitySection.swift`
- `Scout/Swipe/Views/SwipeCardTagCluster.swift`
- `Scout/Swipe/Views/SwipeStatHighlightsSection.swift`
- `Scout/Swipe/Views/SwipeBestOverlapTeaser.swift`
- Future swipe-specific views under `Scout/Swipe/Views/` for the later segments

## Implementation Notes
- Keep the hero image visually dominant; cards should feel translucent and float over it.
- Prefer fewer, stronger sections instead of many small ones.
- Use previews for every new swipe-specific section.
- Let each PR own one obvious visual band or system.

## Testing Per PR
- [ ] `make build`
- [ ] Xcode preview for the touched swipe section
- [ ] Small-device preview for wrapping/clipping checks
- [ ] Manual simulator pass when layout structure changes
