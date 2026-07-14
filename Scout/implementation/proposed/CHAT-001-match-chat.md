# Implementation Tech Plan: Match and Event Chat V1

## Status

Proposed

## Owner

TODO

## Product Domain

CHAT / SOCIAL

## Jira Project

SOCIAL

## Source of Truth

This plan defines Scout's first messaging implementation slice. It builds on:

- `tech-plans/approved/ARCH-001-app-architecture.md`
- `tech-plans/approved/PROFILE-001-player-profile-system.md`
- `tech-plans/approved/SWIPE-001-discovery-and-recommendation.md`
- `tech-plans/approved/EVENT-001-games-and-events.md`
- `docs/architecture/API_BOUNDARIES.md`
- `docs/database/RLS.md`

Scout does not yet have a full Chat domain authority document. This plan intentionally keeps scope small and implementation-ready. If future work expands Chat beyond match/event conversations, a dedicated Chat domain plan should be created before implementation.

## Problem Statement

Matches and joined events need a lightweight communication path so players can coordinate real-world play. Scout's first chat implementation should support only conversations created from an existing Match or Event context, with simple text messages, privacy-aware participant access, and clear Supabase ownership.

## Goals

- Define V1 chat architecture.
- Define conversation lifecycle and ownership.
- Define repository pattern and message model.
- Define match and event conversation contexts.
- Define chat summaries and message list behavior.
- Define privacy, blocking, RLS, offline, and notification boundaries.
- Produce implementation stories that directly unblock iOS and Supabase agents.

## Non-goals

- Standalone direct messages without a Match or Event.
- Group chat beyond Event conversations.
- Reactions.
- GIFs.
- Media or attachments.
- Typing indicators in V1.
- Read receipts in V1.
- Message search.
- Rich moderation tooling.
- End-to-end encryption.

## Chat Architecture

```text
Chat List / Chat Thread View
  -> Chat ViewModels
  -> ChatRepository protocol
  -> Conversation and Message domain models
  -> Supabase-backed chat tables
  -> Future Notification service hook
```

SwiftUI owns presentation and user intent. ViewModels own loading/sending state. `ChatRepository` owns conversation lookup, message fetch, send, summary mapping, and domain errors. Supabase owns persistence, participant access, and RLS.

## Conversation Lifecycle

V1 lifecycle:

- `created`: conversation exists from approved Match/Event context.
- `active`: participants can send/read messages.
- `closed`: conversation is no longer writable but may remain readable.
- `hidden`: user-local hide/archive state, future.

Conversation creation rules:

- Match conversations are created only from an existing mutual Match.
- Event conversations are created only for an existing Event context.
- Users cannot create arbitrary conversations with unrelated users.
- Conversation context must remain immutable after creation.

## Conversation Ownership

Chat owns:

- Conversation records.
- Conversation participant records.
- Message records.
- Conversation summaries.
- Message send/read access rules.

Discovery owns Match state. Events owns Event state. Profile owns user identity. Chat consumes Match, Event, and Profile contracts; it does not mutate those domains.

## Repository Pattern

`ChatRepository` should:

- Fetch chat summaries for the current user.
- Fetch a conversation by ID.
- Fetch paginated messages.
- Send a text message.
- Create or get conversation for approved Match/Event context.
- Map Supabase DTOs to domain models.
- Map errors into domain errors.
- Provide mock repositories for previews/tests.

`ChatRepository` should not:

- Create Matches.
- Join Events.
- Own participant eligibility outside chat membership.
- Expose generated Supabase types to SwiftUI.
- Send push notifications directly.

## Message Model

V1 message fields:

- Message ID.
- Conversation ID.
- Sender profile summary.
- Body text.
- Created timestamp.
- Delivery/send state for local UI.
- Deleted/hidden marker, future.

V1 validation:

- Body is required.
- Body has a maximum length.
- Body is trimmed before send.
- Empty or whitespace-only messages are blocked.

## Chat Summaries

`ChatSummary` supports the conversation list:

- Conversation ID.
- Conversation type: match or event.
- Context summary: matched player or event title/summary.
- Last message preview.
- Last activity timestamp.
- Unread count, future.
- Participant display summaries.

Unread counts may be deferred until read receipts exist.

## Match Context

Match conversation:

- Requires an existing Match.
- Includes exactly the matched participants for V1.
- Uses Profile public/chat summary contracts.
- Remains separate from Discovery decision state.
- Must not expose recommendation internals.

## Event Context

Event conversation:

- Requires an existing Event.
- Includes organizer and joined participants for V1.
- Participant membership should follow Event participation state.
- Event cancellation may close or restrict sending based on approved product rules.
- No group chat outside Event conversations.

## Privacy and Blocking Behavior

Privacy rules:

- Users can only read conversations where they are participants.
- Users can only send in active conversations where they are participants.
- Message sender identity uses approved Profile chat summary fields.
- Blocked user behavior must be defined before production launch.

Initial blocking proposal:

- If a user blocks another participant, direct match chat should close or hide for the blocker.
- Event chat blocking behavior requires product approval because blocking may affect group coordination.
- RLS must prevent nonparticipants from reading messages regardless of UI state.

## Supabase Schema Ownership and RLS Planning

Candidate tables:

- `conversations`
- `conversation_participants`
- `messages`

Required RLS policies:

- Conversation participants can read their conversations.
- Conversation participants can read messages in their conversations.
- Active participants can insert messages.
- Users cannot update another user's messages.
- Nonparticipants cannot read conversation metadata or messages.
- Service role behavior for notification fan-out must be documented before push delivery.

Schema must include enough context to distinguish Match and Event conversations without Chat owning Match/Event records.

## Push Notification Integration

V1 should define notification-ready events:

- Message sent.
- Conversation created.

Push delivery is deferred to a Notifications implementation. Chat should expose hooks or domain events that Notifications can consume later.

## Future Features

Deferred:

- Read receipts.
- Typing indicators.
- Attachments/media.
- Reactions.
- GIFs.
- Message search.
- Message deletion/editing.
- Moderation workflows.
- Standalone DMs.

Deferred features should extend the Chat repository/contracts rather than creating parallel messaging systems.

## Offline Behavior

V1 offline handling:

- If offline, loading messages should show a retryable state.
- Sending while offline may be blocked or queued only if an approved local queue exists.
- The first implementation should prefer explicit failure/retry over complex offline queueing.

Future offline:

- Local message cache.
- Pending send queue.
- Conflict/retry state.

## Testing Strategy

- Unit-test message validation.
- Unit-test repository mapping.
- Unit-test conversation access state in ViewModels.
- Unit-test send loading/error/success paths.
- RLS tests for participant and nonparticipant access.
- UI screenshots for chat list, thread, empty, loading, failed, and sending states.

## Rollout Plan

1. Add Chat domain models and repository protocol.
2. Add Supabase schema and RLS.
3. Implement concrete ChatRepository.
4. Build chat list and thread UI.
5. Add send message behavior.
6. Add Match conversation creation/get behavior.
7. Add Event conversation creation/get behavior.
8. Add notification hook events.

## Risks

- Without strict context creation rules, Chat could become unapproved arbitrary DM.
- Event chat membership can drift if Event participant state changes are not synchronized.
- Blocking behavior in Event conversations needs product approval before launch.
- RLS mistakes can expose private messages.
- Push notification copy can leak message content if not designed carefully.

## Definition of Done

- Match and Event conversations can be created or retrieved from approved contexts.
- Conversation participants can read and send text messages.
- Nonparticipants cannot read or send.
- Chat UI uses repository/domain models, not generated Supabase types.
- No media, reactions, GIFs, standalone DMs, or rich moderation are implemented.
- Jira stories are complete, reviewed, and merged.

## Jira Breakdown

- Epic: `SOCIAL-76` - CHAT-001: Match and Event Chat V1
- `SOCIAL-77` - Chat: Create conversation and message domain models
- `SOCIAL-78` - Chat: Add ChatRepository protocol and mock repository
- `SOCIAL-79` - Chat: Create Supabase schema migration for match and event conversations
- `SOCIAL-80` - Chat: Add RLS policies for conversation participants and messages
- `SOCIAL-81` - Chat: Implement Supabase ChatRepository
- `SOCIAL-82` - Chat: Build chat list and thread UI
- `SOCIAL-83` - Chat: Implement send text message flow
- `SOCIAL-84` - Chat: Add Match and Event conversation entry points
- `SOCIAL-85` - Chat: Add notification hook events for new messages
- `SOCIAL-86` - Chat: Add repository, RLS, and message flow regression tests
