# Storage Bucket Planning

## Purpose

This document defines Scout's proposed storage bucket planning template. It is planning guidance only until the relevant implementation tech plans are approved.

Related documents:

- `docs/database/DATABASE.md`: database planning overview and domain ownership.
- `docs/database/SUPABASE.md`: Supabase operating model.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation plan.

## Planning Requirement

Every future storage bucket plan must define access, paths, ownership, retention, and deletion behavior before a bucket is created.

Expected future storage domains:

- Profile photos.
- Action photos.
- Event media.
- Chat attachments.

No storage bucket is approved by this document.

## Bucket Planning Template

Future media plans should copy this template before implementation:

| Field | Required Planning Detail |
| --- | --- |
| Bucket name | Proposed bucket name and owning domain. |
| Product use case | What user-facing capability requires the bucket. |
| Access mode | Public, private, or signed URL access, with rationale. |
| Path convention | Folder/key pattern, user ID usage, object naming, and collision behavior. |
| Ownership rules | Who can upload, read, update metadata, replace, and delete objects. |
| RLS or policy relationship | Tables, policies, or app contracts that control storage access. |
| Signed URL behavior | Whether signed URLs are used, expected TTL, and refresh behavior. |
| Image processing | Resize, compression, format, thumbnail, and transformation expectations. |
| Moderation and abuse | Review, reporting, blocking, takedown, and unsafe content handling. |
| Retention | How long objects persist and when cleanup runs. |
| Deletion behavior | User delete, account delete, moderation delete, and orphan cleanup behavior. |
| Migration/backfill | Whether existing objects need migration or backfill. |
| Validation | Manual or automated checks required before review. |

## Review Expectations

Storage implementation PRs should state:

- Jira story and approved implementation plan.
- Bucket name and access mode.
- Whether a bucket was created or intentionally deferred.
- Path convention and ownership rules.
- Signed URL, retention, and deletion behavior.
- Moderation or abuse considerations.
- Validation performed.

## Approval Boundary

This document does not approve creating buckets, uploading media, changing storage permissions, adding storage policies, changing app upload code, or creating background cleanup jobs.
