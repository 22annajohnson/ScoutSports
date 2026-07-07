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

Every future schema plan must fill out the table policy template before SQL is written. If a table intentionally does not use RLS, the plan must say why and identify the compensating access boundary.

Every future table plan should define:

- Owner.
- Who can read rows.
- Who can insert rows.
- Who can update rows.
- Who can delete rows.
- Service role behavior.
- Owner behavior.
- Non-owner behavior.
- Blocked user behavior.
- Hidden/private behavior.
- Deleted/restricted account behavior.
- Audit or moderation expectations.
- Required positive checks.
- Required negative checks.
- Manual verification notes when automated tests are not available.

## Access Scenario Checklist

Future schema plans should consider these scenarios before proposing policies:

- Authenticated owner can access only the rows and fields they are allowed to own.
- Authenticated non-owner can access only rows exposed through approved visibility or relationship rules.
- Anonymous users cannot access user-owned rows unless public access is explicitly approved.
- Blocked users cannot discover, read, write, or infer protected rows across the block boundary.
- Hidden or private profiles/events/media are excluded from unrelated discovery and listing flows.
- Restricted, deleted, or suspended accounts lose access according to the approved account-state rules.
- Service role access is limited to named operational, moderation, migration, or background-processing use cases.
- Inserts validate ownership and prevent users from creating rows on behalf of unrelated accounts.
- Updates limit both who can update and which state transitions are allowed.
- Deletes distinguish hard delete, soft delete, user request, and admin/moderation cleanup behavior.
- Cross-domain reads use approved contracts rather than unrestricted table access.
- RLS validation includes both allowed and denied examples.

## Table Policy Template

Future schema plans should copy this table for each proposed table before writing SQL.

| Table | Owner | Owner Behavior | Non-owner Behavior | Read Policy | Insert Policy | Update Policy | Delete/Retention Policy | Service Role Behavior | Blocked/Hidden/Restricted Behavior | Testing Notes |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| `example_table` | Owning domain and owning user relationship. | What the row owner can read/change/delete and which fields are owner-editable. | What authenticated non-owners can read or infer, if anything. | Who can select rows and under what relationship, visibility, or lifecycle conditions. | Who can create rows, how ownership is assigned, and which fields are allowed. | Who can modify rows and which state transitions are allowed. | Who can delete rows, soft-delete rows, request deletion, or trigger cleanup. | Whether service role access is allowed and for which operational/moderation/migration use cases. | How blocked users, hidden users, private state, restricted accounts, deleted accounts, and suspended accounts affect access. | Positive cases, negative cases, owner/non-owner cases, blocked/hidden/restricted cases, service-role cases, and manual verification notes. |

## Required Testing Notes

Future RLS implementation plans should include a test matrix or manual verification notes for:

- Owner allowed read/write cases.
- Owner denied cases for fields or state transitions they cannot control.
- Non-owner allowed cases based on approved visibility rules.
- Non-owner denied cases for private or unrelated rows.
- Anonymous denied cases unless public access is explicitly approved.
- Blocked user denied cases in both directions of the block relationship.
- Hidden/private/restricted/deleted account behavior.
- Service role use cases and boundaries.
- Cross-domain consumer access through approved contracts.

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
