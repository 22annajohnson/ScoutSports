# Scout Agent Guide

## Project Overview
- Scout is a Swift/SwiftUI app for matching people for pickup sports, starting with pickleball.
- The app includes onboarding, profile building, swipe/match flows, and Supabase-backed data and storage.
- The product goal is to help people connect offline through sports.

## Product Context
- Prioritize shipping a working v1 without letting code quality slip.
- Preserve product intent. Do not invent major UX, flow, or feature changes unless explicitly requested.
- Favor progress on the current product direction over broad cleanup or architectural churn.

## Tech Context
- Language/UI stack: Swift + SwiftUI.
- Architecture: MVVM-style with feature-oriented organization.
- Backend: Supabase for auth, data, and storage.
- Follow the patterns already established in the touched area unless the task explicitly calls for a new pattern.

## Working Rules
- Make the smallest reasonable change that solves the problem.
- Do not refactor unrelated code while addressing a focused task.
- Do not change schema, auth flow, or storage structure unless explicitly asked.
- Do not rename files, types, functions, or public-facing concepts without a strong reason.
- If a task is unclear, prefer a narrow implementation over a broad interpretation.
- Keep diffs small, reviewable, and easy for a human to reason about.

## Navigation Guidance
- Inspect existing related files before adding new abstractions.
- Reuse current views, view models, repositories, services, and models where possible.
- Avoid duplicate components, duplicate business logic, and parallel patterns for the same feature.
- Prefer extending the relevant feature area over introducing new cross-cutting layers too early.
- Typical feature areas live under `Scout/Scout/`:
  - `App/` for app wiring and environment
  - `AuthGate/` and `Onboarding/` for entry flows
  - `Profile/` for profile builder and profile UI
  - `Swipe/` for swipe/match flows
  - `Data/` for repositories, Supabase mappings, and storage-facing code
  - `Domain/` and `Shared/` for reusable models/utilities already in use

## UI Guidance
- Match the existing visual and interaction style.
- Do not perform a broad visual redesign unless explicitly requested.
- Prefer incremental UI improvements that fit current screens and component choices.
- Preserve the product's current structure and wording unless the task specifically changes them.

## Data and Backend Guidance
- Respect actual backend field types, nullability, and relationships.
- Be careful with Supabase model mappings, coding keys, foreign keys, and storage paths.
- Do not assume a user-facing string field is the source of truth if the backend uses IDs or foreign keys.
- When touching persistence code, verify the mapping in the repository/model layer before changing UI assumptions.
- Treat schema-related changes as product decisions, not incidental code cleanup.

## Validation and Testing
- Build or validate the touched area when possible.
- Use the repository's existing validation workflow instead of inventing one. For this project, check the `Makefile` under `Scout/` before reaching for custom build commands.
- In your handoff, say what changed, which files were touched, and any risks or follow-ups.
- If something could not be verified, say so clearly and state why.

## Branch and PR Mindset
- Assume your work will be reviewed by a human.
- Nothing should depend on automatic merge or invisible context.
- Optimize for clean handoff: clear diffs, localized changes, and minimal surprise.
- Leave the next reviewer with enough context to understand why the change is correct.
