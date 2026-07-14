# Supabase Database Tests

This directory contains local pgTAP database tests run by:

```text
make supabase-test-db
```

The Makefile target runs:

```text
supabase test db backend/supabase/tests/database --workdir backend
```

## Current Boundary

`INFRA-61` creates the database test harness only. It does not add product
schema, product RLS policies, production data, or repository integration tests.

## Test File Conventions

Future schema stories should add focused pgTAP files here when they create or
change user-data tables, RLS policies, database functions, triggers, constraints,
or seed data used by RLS validation.

Use this naming shape:

```text
<jira-key>_<domain>_<behavior>_test.sql
```

Examples:

```text
SOCIAL-101_profiles_owner_rls_test.sql
SOCIAL-117_events_participant_rls_test.sql
```

Each test file should:

- Reference the authorizing Jira story and approved implementation plan in a
  SQL comment header.
- Use deterministic local/dev seed data only.
- Include both allowed and denied cases for any RLS policy it validates.
- Avoid production-like private data, real user identifiers, tokens, or external
  network dependencies.
- End with pgTAP `finish()` so `supabase test db` can report the result.

## RLS Matrix

For user-owned or user-visible tables, cover the scenarios that apply:

- Anonymous user denied by default unless public access is approved.
- Authenticated owner allowed only for approved rows and fields.
- Authenticated owner denied for system-owned or moderation-only fields.
- Authenticated non-owner allowed only through approved visibility or
  relationship rules.
- Authenticated non-owner denied for private or unrelated rows.
- Related participant/member behavior for event, match, chat, team, or group
  data.
- Blocked or hidden relationship behavior in both directions.
- Restricted, deleted, or suspended account behavior.
- Service role behavior limited to named operational, moderation, migration, or
  background-processing use cases.
