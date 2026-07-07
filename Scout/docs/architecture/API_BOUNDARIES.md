# API Boundaries

## Purpose

This document defines planning guidance for boundaries between Scout clients, repositories, Supabase, storage, and future backend services.

It does not approve new APIs or service layers by itself.

## Current Integration Model

The current iOS app uses feature view models and data-layer services or repositories to interact with Supabase-backed auth, profile, and storage capabilities.

Relevant current areas:

- `Scout/AuthGate`
- `Scout/Data/Auth`
- `Scout/Data/Profiles`
- `Scout/Data/Storage`
- `Scout/Data/Supabase`
- `Scout/Profile`
- `Scout/Swipe`

Future plans should inspect the touched feature and data folders before changing integration patterns.

## Boundary Principles

- Views should not own persistence logic.
- View models should coordinate user intent and presentation state.
- Repositories or services should own Supabase calls, storage calls, decoding, and persistence details.
- Domain models should avoid leaking backend-only representation when practical.
- Backend contracts should be documented before being used by multiple clients.
- Cross-platform API decisions require approval because the web app will eventually share product concepts.

## Client Responsibilities

Clients may own:

- UI rendering.
- Navigation and local presentation state.
- Form validation needed for immediate user feedback.
- Optimistic UI when explicitly planned.
- Platform-specific media picking and upload preparation.
- Calling documented repositories or services.

Clients should not own:

- RLS assumptions that are not documented.
- Hidden data authorization decisions.
- Schema migrations.
- Cross-client contract changes without approval.

## Backend Responsibilities

Supabase or future backend services should own:

- Auth and identity.
- Database storage and constraints.
- Row Level Security.
- Storage access rules.
- Server-side validation when client validation is insufficient.
- Edge Functions for operations that require server authority, secrets, fan-out, or transactional coordination beyond client capability.

## Shared Contracts

Shared contracts may include:

- Table definitions.
- Generated Supabase types.
- Enum values.
- API request and response shapes.
- Storage path conventions.
- Error code conventions.
- Analytics event names.

Shared contracts should be versioned or documented before they are consumed by both iOS and web.

## API Change Requirements

Technical plans that change API or service boundaries should include:

- Current behavior.
- Proposed behavior.
- Affected clients.
- Data model impact.
- Backward compatibility.
- Error handling.
- Testing strategy.
- Rollout and rollback plan.

## Open API Boundary Questions

- Which operations should remain direct Supabase calls from clients?
- Which operations need Edge Functions?
- How should generated Supabase types be shared between iOS and web?
- What error model should user-facing features use?
- How should client repositories stay aligned across platforms?
