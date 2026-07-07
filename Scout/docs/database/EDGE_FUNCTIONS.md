# Edge Function Planning

## Purpose

This document defines Scout's proposed Edge Function planning template. It is planning guidance only until the relevant implementation tech plans are approved.

Related documents:

- `docs/database/DATABASE.md`: database planning overview and domain ownership.
- `docs/database/SUPABASE.md`: Supabase operating model.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation plan.

## Planning Requirement

Edge Functions should be introduced only when client-side, database-only, or existing Supabase behavior is insufficient.

Potential future uses:

- Recommendation scoring.
- Notification fanout.
- Media processing.
- Trust and safety workflows.
- Webhook handling.

No Edge Function is approved by this document.

## Function Planning Template

Future Edge Function plans should copy this template before implementation:

| Field | Required Planning Detail |
| --- | --- |
| Function name | Proposed name and owning domain. |
| Product use case | User-facing or operational capability the function supports. |
| Why a function | Why client-side, database-only, or existing Supabase behavior is insufficient. |
| Trigger | HTTP request, webhook, scheduled job, database event, or manual operation. |
| Inputs | Request body, query params, headers, and required validation. |
| Outputs | Response shape, status codes, and error behavior. |
| Auth | Caller identity, JWT requirements, service role use, and authorization checks. |
| Secrets | Secret categories needed and owner; no secret values. |
| Data access | Tables, storage buckets, external services, and RLS/service-role implications. |
| Idempotency | Retry-safe behavior, dedupe keys, and duplicate request handling. |
| Retry behavior | Expected retry source, backoff, and failure handling. |
| Observability | Logs, metrics, alerts, correlation IDs, and audit needs. |
| Local testing | Local run command, fixtures, mocks, and manual verification. |
| Deployment path | Environment targets and promotion expectations. |
| Rollback | Disable, redeploy, or forward-fix strategy. |

## Review Expectations

Edge Function implementation PRs should state:

- Jira story and approved implementation plan.
- Owning domain and function name.
- Auth model and service role usage.
- Secrets required by category, without values.
- Inputs, outputs, idempotency, and retry behavior.
- Observability and local testing performed.
- Deployment and rollback expectations.

## Approval Boundary

This document does not approve creating functions, deploying functions, adding secrets, creating CI jobs, changing auth strategy, or adding production server-owned behavior.
