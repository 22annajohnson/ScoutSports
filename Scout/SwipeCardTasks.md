# Swipe Card Redesign Tasks

## Goal
- Move the swipe card toward a layered layout where the hero image remains large in the background.
- Start the primary identity card around the midpoint of the screen so the player photo remains dominant.
- Let the user scroll the glass widgets upward over the image rather than breaking the photo into separate stacked sections.
- Roll the redesign out as a sequence of PRs where each PR adds one major card segment or one structural layout change.

## Target Interaction Model
- The hero image should stay full-width and visually dominant at the top of the card.
- The first content panel should begin around 45-55% down the viewport.
- The content stack should scroll vertically over the background image.
- The image should still feel present as content scrolls, not disappear immediately behind a flat section break.
- The action dock should stay anchored and easy to reach.

## Constraints
- Keep current swipe mechanics unchanged while redesigning the card.
- Reuse the existing design-system primitives where possible.
- Prefer introducing new swipe-specific composition views over overloading generic design components too early.
- Keep each PR reviewable and visually coherent on its own.

## Proposed Build Order

### PR 1: Structural Layout Shift
- Scope:
  Change the swipe card architecture so the hero image is the persistent background and the content stack scrolls over it.
- Tasks:
  - Create a swipe-specific layout container for background image + overlay scroll content.
  - Position the first content card so it starts around mid-screen.
  - Add safe top/bottom spacing so chips, identity content, and dock don’t collide with hardware insets.
  - Preserve the current swipe gesture behavior and scroll handoff.
- Done when:
  The image remains the background and the content stack visibly starts halfway down, then scrolls upward over the image.

### PR 2: Identity Hero Segment
- Scope:
  Replace the current top-of-card content with a new identity card.
- Tasks:
  - Build the glass identity panel containing:
    `Name + Age`
    short profile summary lines
    hero intent chip such as "Looking for competitive games"
    overall score capsule
  - Support multiline summary text without clipping.
  - Tune the panel height so it feels compact but readable over the image.
- Done when:
  The first visible segment matches the inspiration more closely and anchors the card visually.

### PR 3: Tag Row Segment
- Scope:
  Add the metadata chip cluster beneath the identity content.
- Tasks:
  - Add reusable swipe tags for style, reliability, schedule, and sport.
  - Support wrapping to multiple rows when content is longer.
  - Tune spacing so the tags feel attached to the identity card rather than like a separate unrelated section.
- Done when:
  The metadata chips read clearly and don’t clip on smaller devices.

### PR 4: Scout Read Segment
- Scope:
  Add the first large analytical summary card under the hero section.
- Tasks:
  - Create a `Scout Read` card with:
    compatibility score
    short summary text
    best-fit capsule
    three compact metric tiles
    "Why Scout likes this match" explanation row
  - Reuse existing stat tile patterns where practical, but tune them for this denser card.
- Done when:
  The swipe card has a meaningful second section that looks intentionally productized, not placeholder.

### PR 5: Best Overlap Segment
- Scope:
  Add the availability/overlap visualization card.
- Tasks:
  - Build the best-overlap card with title, fit badge, and weekly bar visualization.
  - Make the chart bars visually consistent with the blue/violet accent system.
  - Keep the component resilient to sparse or partial data.
- Done when:
  The overlap card can stand on its own as a reusable swipe subcomponent.

### PR 6: Preference Notes Segment
- Scope:
  Add the lower stack of short preference and vibe statements.
- Tasks:
  - Create stacked note rows for preferences like pace, timing, social style, or post-match vibe.
  - Support missing data gracefully by omitting rows rather than rendering empty shells.
  - Keep the rows scannable and lightweight so the bottom of the card does not feel overly dense.
- Done when:
  The lower content stack feels complete and informative without becoming visually noisy.

### PR 7: Action Dock Integration
- Scope:
  Rework the bottom action area to match the new card structure.
- Tasks:
  - Tune the action dock placement relative to the scroll content and bottom safe area.
  - Decide whether the dock remains visually pinned or scroll-adjacent.
  - Ensure the dock still feels consistent with the swipe interaction model and does not obscure content.
- Done when:
  The action dock feels intentionally integrated with the new card, not tacked on afterward.

### PR 8: Data Wiring and Content Quality Pass
- Scope:
  Replace placeholder copy and hardcoded labels with better swipe-card content wiring.
- Tasks:
  - Identify which existing fields can populate age, summary lines, tags, notes, and match reasoning.
  - Add lightweight view-model shaping for swipe presentation if needed.
  - Keep backend/schema changes out of scope unless truly required.
- Done when:
  The redesigned card is backed by realistic content instead of mostly mock phrasing.

### PR 9: Polish and Accessibility
- Scope:
  Final motion, readability, and device-fit cleanup for the redesigned swipe card.
- Tasks:
  - Check dynamic type behavior for the new stacked layout.
  - Audit contrast over images and glass surfaces.
  - Tune scroll feel, panel spacing, and transitions between segments.
  - Verify no clipping on smaller devices.
- Done when:
  The card feels stable and shippable across supported device sizes.

## Suggested File Areas
- `Scout/Swipe/Views/PlayerSwipeScrollView.swift`
- `Scout/Swipe/Views/PlayerBackgroundView.swift`
- `Scout/Swipe/Views/PlayerHeroHeaderView.swift`
- New swipe-specific subviews under `Scout/Swipe/Views/` such as:
  - `SwipeCardIdentitySection.swift`
  - `SwipeCardScoutReadSection.swift`
  - `SwipeCardBestOverlapSection.swift`
  - `SwipeCardPreferenceNotesSection.swift`

## Implementation Notes
- Prefer new swipe-specific composition views over forcing everything into one giant `PlayerSwipeScrollView`.
- Keep the design-system components generic, but let the swipe card assemble them in feature-specific ways.
- Avoid mixing layout restructuring and heavy data-model work in the same PR.
- Use previews for every new segment as it lands.

## Testing Per PR
- [ ] `make build`
- [ ] Xcode preview for the newly added swipe segment
- [ ] Small-device preview to catch clipping and early scroll issues
- [ ] Manual simulator pass through the swipe screen if the layout structure changes

## Recommended Starting Sequence
1. PR 1: structural background-image + scroll-overlay layout
2. PR 2: identity hero card
3. PR 3: metadata tag cluster
4. PR 4: scout-read analytics card
5. PR 5: best-overlap card
6. PR 6: preference note rows
7. PR 7: action dock integration
8. PR 8: content/data wiring
9. PR 9: polish and accessibility
