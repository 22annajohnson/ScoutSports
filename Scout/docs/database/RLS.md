# Row Level Security

## Purpose

Row Level Security is a first-class product and safety boundary for Scout. This document defines planning expectations for RLS before tables are implemented.

Related documents:

- `docs/database/DATABASE.md`: database planning overview and domain ownership.
- `docs/database/SUPABASE.md`: Supabase operating model.
- `docs/database/MIGRATIONS.md`: proposed migration workflow.
- `implementation/proposed/INFRA-001-database-foundation.md`: proposed database foundation plan.
- `implementation/proposed/PROFILE-002-v1-identity-field-set.md`: proposed v1 profile field set.
- `implementation/proposed/PROFILE-003-profile-schema-and-rls.md`: future/proposed profile schema and RLS plan.

## Philosophy

- Privacy rules override feature convenience.
- Every user-owned or user-visible table needs RLS planning.
- Public reads should be rare and explicitly justified.
- Service role access should be explicit and limited.
- Blocked, hidden, restricted, deleted, and private states must be considered.
- Consumers should receive approved contracts rather than unrestricted rows.

## Required Policy Planning

Every future table plan should define:

- Owner.
- Who can read rows.
- Who can insert rows.
- Who can update rows.
- Who can delete rows.
- Service role behavior.
- Blocked user behavior.
- Hidden/private behavior.
- Deleted/restricted account behavior.
- Audit or moderation expectations.

## Table Policy Template

Future schema plans should copy this table for each proposed table before writing SQL.

| Table | Owner | Read Policy | Insert Policy | Update Policy | Delete Policy | Service Role Behavior | Blocked/Hidden Behavior | Testing Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `example_table` | Owning domain | Who can select rows and under what relationship/visibility conditions. | Who can create rows and which fields are allowed. | Who can modify rows and which state transitions are allowed. | Who can delete rows, soft-delete rows, or request deletion. | Whether service role access is allowed and for what use cases. | How blocked users, hidden users, private state, restricted accounts, and deleted accounts affect access. | Positive cases, negative cases, owner/non-owner cases, and manual verification notes. |

## Profile RLS Considerations

Profile data should distinguish:

- Owner-editable fields.
- Public summary fields.
- Discovery-visible fields.
- Event-visible fields.
- Chat-visible fields.
- System-only fields.
- Private preference fields.

Profile consumers should use profile contracts rather than full profile rows.

## Events RLS Considerations

Event data should distinguish:

- Organizer-owned event data.
- Participant-visible event detail.
- Public event preview.
- Exact versus approximate location.
- Participant state.
- Cancelled/archived events.

## Testing Expectations

Future RLS implementation plans should include:

- Positive access cases.
- Negative access cases.
- Owner versus non-owner behavior.
- Blocked/hidden state checks.
- Service role use cases.
- Manual verification steps if automated tests are not yet available.

## Approval Boundary

This document does not approve any RLS policy or table.
