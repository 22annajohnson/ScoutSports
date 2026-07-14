# Design Factory Access Requirements

## Purpose

Design Factory is Scout's internal design-system workbench. It gives maintainers a way to inspect ScoutDesign tokens, typography, spacing, components, and states before those elements are used or extended in production screens.

Design Factory is not a public Scout feature. It must remain unavailable to non-employees even if the app build contains the internal tooling.

## Approved Access Direction

Design Factory may be available to authenticated Scout Sports employees whose signed-in account uses an `@scoutsports.app` email address.

This is an internal-tool access rule only. It does not create a broader admin system, user role model, permission table, or production moderation surface.

## Entry Requirements

The first Design Factory implementation should meet these requirements:

- Require an authenticated session before evaluating employee access.
- Allow access only when the authenticated email address ends with `@scoutsports.app`.
- Keep the entry point out of ordinary user navigation.
- Protect the route itself, not only the visible entry link.
- Centralize the employee-email access check so views do not duplicate email-domain logic.
- Use only local demo data for galleries and examples.
- Avoid production user data, Supabase writes, storage changes, schema changes, or broader auth changes.

## Production Visibility Controls

Design Factory may exist in builds that employees use, but it must not become visible or reachable for ordinary users by accident.

Implementation should therefore:

- Hide the entry point for non-employee accounts.
- Reject direct route access for non-employee accounts.
- Fail closed when no authenticated email is available.
- Avoid adding Design Factory to the normal tab bar, onboarding, profile, feed, swipe, or settings flows.
- Avoid introducing a general admin surface as a shortcut for access.

## Minimum First Shell Content

The first shell should be useful before galleries are complete. At minimum, it should include:

- A clear Design Factory title.
- Category placeholders for foundations, components, and states.
- A short empty state for categories that are not populated yet.
- A visible indication that the surface is internal tooling.
- No dependency on backend data.

## Validation Expectations

Implementation PRs should verify:

- Authenticated employee accounts can reach the shell through the approved entry point.
- Authenticated non-employee accounts cannot see or open the shell.
- Missing or unavailable email state blocks access.
- The shell does not appear in normal user navigation.
- No production data, Supabase schema, storage, or CI/CD configuration changes are included.

Documentation-only changes should be reviewed for clarity against these access requirements.
