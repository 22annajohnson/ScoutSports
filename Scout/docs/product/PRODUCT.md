# Scout Product

## Purpose

Scout helps people find nearby players, games, and sports connections that lead to real-world play. The first product focus is pickleball, with the product architecture expected to support additional sports over time.

This document defines the product foundation future technical plans should use. It is not a substitute for feature-specific requirements.

## Product Vision

Scout should make it easier for people to move from intent to play:

- Discover compatible players nearby.
- Build a profile that communicates skill, availability, location, and play style.
- Match with people who are likely to be good sports partners.
- Coordinate around games, events, and recurring play.
- Support trust, safety, and respectful social interaction.

## Product Principles

- Offline connection is the outcome. In-app flows should reduce friction toward real play.
- Trust matters. Profiles, matching, visibility, and messaging should help users feel safe.
- Sports context is first-class. Skill level, availability, location, preferences, and sport-specific details should shape the experience.
- Start narrow, scale deliberately. Pickleball v1 should work well before generalized multi-sport expansion.
- Keep flows lightweight. Scout should feel useful without requiring excessive setup.

## Target Users

- New or casual players looking for people to play with.
- Intermediate players seeking compatible partners or groups.
- Regular players who want to fill games or expand their network.
- Event or game organizers who need lightweight discovery and coordination.

## Core Product Domains

- `AUTH`: Sign-in, session restoration, account lifecycle, and access control.
- `ONBOARDING`: Initial setup, preferences, location, sports selection, and profile completion.
- `PROFILE`: Player identity, sports preferences, skill level, photos, bio, and editable profile details.
- `SWIPE`: Player discovery, recommendation cards, decisions, matches, and match feedback.
- `FEED`: Updates, suggested activity, local discovery, and future social surfaces.
- `SOCIAL`: Matches, messaging, invitations, contacts, and relationship state.
- `EVENTS`: Games, events, open play, RSVPs, attendance, and organizer workflows.
- `NOTIFICATIONS`: Push, in-app prompts, reminders, and lifecycle messaging.
- `INFRA`: Supabase, storage, schema, CI, observability, and environment management.
- `ARCH`: Cross-cutting architecture, monorepo structure, shared contracts, and long-term technical decisions.

## Primary User Journeys

### First Session

1. User installs Scout.
2. User authenticates or creates an account.
3. User completes required onboarding fields.
4. User creates an initial player profile.
5. User reaches the first meaningful discovery surface.

### Build Profile

1. User edits profile details.
2. User adds sports-specific information.
3. User uploads or updates media.
4. User reviews how their profile appears to others.

### Discover Players

1. User opens the swipe or discovery surface.
2. Scout loads candidate player cards.
3. User reviews profile context.
4. User accepts, passes, or takes another supported action.
5. Scout records the decision and surfaces match feedback when relevant.

### Coordinate Play

1. User discovers a player, match, game, or event.
2. User expresses interest or joins.
3. Participants coordinate details.
4. Scout supports reminders, updates, and follow-up signals.

## Feature Prioritization

Feature ideas should move through:

1. Product problem framing.
2. Proposed technical plan.
3. Owner approval.
4. Jira epic and ticket breakdown.
5. Implementation.
6. Review and release.

Prioritize work that improves the core loop: profile quality, discovery quality, match quality, and real-world play conversion.

## Success Metrics

Initial candidate metrics:

- Profile completion rate.
- Swipe deck engagement.
- Match creation rate.
- Message or coordination initiation rate.
- Games or events joined.
- Repeat weekly active users.
- Time from signup to first meaningful connection.

Metric definitions require future analytics planning before implementation.

## Open Product Questions

- What exact profile fields are required for v1?
- What sports besides pickleball should be modeled early?
- What is the first version of events: organizer-created games, open play listings, or informal meetups?
- What trust and safety controls are required before broader launch?
- What analytics tooling and event taxonomy should Scout use?
