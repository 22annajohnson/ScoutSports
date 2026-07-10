# Implementation Tech Plan: Profile Media Storage

## Status

Proposed

## Owner

TODO

## Product Domain

PROFILE

## Source of Truth

This plan applies the storage planning template in `docs/database/STORAGE.md` to the `profile_photo` and `action_photo` fields proposed by `implementation/proposed/PROFILE-002-v1-identity-field-set.md`.

Authoritative inputs:

- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`
- `docs/database/STORAGE.md`
- `docs/database/SUPABASE.md`
- `docs/database/RLS.md`

This document remains `Proposed` until the product owner explicitly approves it. SOCIAL-28 creates this plan for review only; it does not create storage buckets, upload code, storage policies, Supabase folders, generated types, Edge Functions, UI, or database schema.

This plan is numbered `PROFILE-005` so `PROFILE-004` can remain the profile contracts plan.

## Problem Statement

Scout needs profile photos and action photos to support trust, recognition, and sports context, but media storage must be planned before uploads or buckets exist. Profile media needs clear ownership, path conventions, access rules, validation, moderation, replacement, deletion, and relationship to profile contracts before any implementation begins.

## Goals

- Define proposed storage requirements for `profile_photo`.
- Define proposed storage requirements for `action_photo`.
- Capture bucket creation, access, signed URL, path, ownership, moderation, retention, and deletion decisions for review.
- Document the relationship between storage objects and PROFILE-002 profile fields.
- Keep bucket creation blocked until this plan and a future implementation story are approved.

## Non-goals

- Creating Supabase storage buckets.
- Creating storage policies.
- Implementing uploads or downloads.
- Changing iOS UI or repositories.
- Creating generated types.
- Creating media moderation services.
- Creating cleanup jobs.
- Changing profile readiness rules.

## PROFILE-002 Relationship

| PROFILE-002 Field | Requirement Decision | Product Role | Readiness Impact | Storage Planning Impact |
| --- | --- | --- | --- | --- |
| `profile_photo` | Optional but strongly recommended for Discovery, Events, and Chat. | Primary recognition and trust image. | Recommended for Discovery Ready, Event Ready, and Chat Ready; not a hard v1 gate per SOCIAL-24. | Storage must support replacement, safe display in summaries, and moderation/takedown without blocking onboarding. |
| `action_photo` | Optional enrichment. | Sports-context image for richer profile and feed surfaces. | Fully Complete enrichment only. | Storage can be planned with the same ownership/deletion rules, but may launch after profile photo if needed. |

Photo requirements remain product decisions. This plan does not make either photo mandatory.

## Proposed Storage Shape

The final bucket layout requires approval before implementation. Two options are proposed for review:

| Option | Bucket Shape | Rationale | Tradeoff |
| --- | --- | --- | --- |
| Separate buckets | `profile-photos`, `profile-action-photos` | Clear purpose-specific policies and review. | More buckets and policy surfaces. |
| Shared bucket | `profile-media` with typed paths | Simpler bucket count and shared image handling. | Policies and cleanup must distinguish media type by path/metadata. |

Current planning recommendation: use one private `profile-media` bucket with typed paths unless review identifies a policy or moderation reason to split buckets.

## Bucket Planning Template

| Field | Proposed Planning Detail |
| --- | --- |
| Bucket name | Proposed: `profile-media`, owned by Profile. Final name requires approval. |
| Product use case | Store user-owned profile photos and action photos for profile summaries, public profile contexts, Discovery, Events, Chat, Feed, and Search where approved. |
| Access mode | Private bucket with signed URL or authenticated retrieval. Public bucket access is deferred because profile visibility, blocked users, and account state must affect exposure. |
| Path convention | Proposed shape: `profiles/{profile_id}/profile/{object_id}.{ext}` and `profiles/{profile_id}/action/{object_id}.{ext}`. Exact IDs, extensions, and replacement behavior require implementation approval. |
| Ownership rules | The profile owner can upload, replace, and request deletion for their own media through approved flows. Non-owners cannot upload or mutate another user's media. Admin/moderation access requires explicit service-role use cases. |
| RLS or policy relationship | Storage access must align with profile ownership, `profile_visibility`, `discoverable`, blocked/hidden state, account status, and profile contracts. Profile tables may store media metadata/path references, but buckets are not approved by schema planning alone. |
| Signed URL behavior | Signed URL use is proposed for non-owner display contexts. TTL, refresh behavior, cache policy, and whether owner views use direct authenticated access are open decisions. |
| Image processing | Require approved image types, max size, compression, resize/thumbnail strategy, orientation handling, and format conversion before upload implementation. No processing service is approved by this plan. |
| Moderation and abuse | Must support reporting, moderation removal, blocked-user filtering, unsafe content takedown, and replacement after takedown. Automated moderation is deferred. |
| Retention | Current object retention after replacement and account deletion is TBD. Prefer short retention for replaced objects unless moderation/audit requirements say otherwise. |
| Deletion behavior | User delete, account delete, moderation delete, and orphan cleanup must be defined before implementation. Deletion should clear or invalidate profile metadata references. |
| Migration/backfill | No existing profile media backfill is planned. If existing objects are discovered, migration/backfill requires a separate approved plan. |
| Validation | Future implementation must validate owner upload, non-owner denial, signed URL access, blocked/private/restricted filtering, replacement, deletion, orphan cleanup, and moderation takedown cases. |

## Contract and Schema Boundaries

- PROFILE-003 may plan `profile_photo_path` and `action_photo_path` metadata fields, but it does not approve storage buckets.
- Profile contracts may expose media references only when privacy, visibility, account status, and relationship rules allow them.
- Chat Summary and Notification Summary should avoid broad media exposure. Push notifications should not include media unless separately approved.
- Discovery, Event, Search, Feed, and Public Profile surfaces must receive media through approved profile contracts rather than direct bucket assumptions.

## Open Decisions Requiring Approval

- Is the final bucket layout one `profile-media` bucket or separate buckets for profile and action photos?
- Are signed URLs required for all non-owner reads, and what TTL is approved?
- What max image size, dimensions, formats, compression, and thumbnail rules are approved?
- Are original images retained after processing, or only optimized derivatives?
- Does Scout require manual or automated moderation before first display?
- What happens to media when a user replaces a photo?
- What happens to media when a user deletes a profile, is restricted, is suspended, or is deleted?
- Are profile photos ever allowed in push notification payloads?
- Should action photos launch with profile photos or remain deferred enrichment?

## Suggested Jira Stories

Do not create these until this plan is approved.

- `Profile: Approve profile media storage plan`
- `Profile: Create profile media bucket`
- `Profile: Add profile media storage policies`
- `Profile: Define profile media metadata fields`
- `Profile: Implement profile photo upload`
- `Profile: Implement action photo upload`
- `Profile: Add profile media deletion and cleanup validation`

## Testing Strategy

This proposed plan requires documentation review only.

Future implementation should validate:

- Owner upload, replacement, read, and delete behavior.
- Non-owner upload/update/delete denial.
- Signed URL generation and expiry.
- Profile contract media visibility.
- Blocked, hidden, private, restricted, deleted, and suspended account behavior.
- Invalid file type, size, dimensions, and path attempts.
- Moderation/takedown behavior.
- Orphan cleanup after metadata changes or deletion.

## Rollout Plan

1. Approve or revise PROFILE-002 photo requirement decisions.
2. Review and approve this media storage plan.
3. Approve any required schema metadata fields in PROFILE-003.
4. Create a focused bucket/policy implementation story.
5. Implement profile photo storage before action photo storage if sequencing is needed.
6. Add upload UI only after storage and metadata behavior are approved.

## Definition of Done

- Profile photo and action photo storage requirements are documented.
- Bucket creation remains blocked until approval.
- Relationship to PROFILE-002 fields is explicit.
- Open media storage decisions are identified.
- No bucket, upload code, storage policy, generated type, schema, UI, or Supabase artifact is created by this plan.
