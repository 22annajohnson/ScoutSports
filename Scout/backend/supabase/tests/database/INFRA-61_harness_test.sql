-- Jira: INFRA-61
-- Tech Plan: implementation/proposed/INFRA-004-supabase-development-pipeline.md
-- Purpose: Verify the repo-owned pgTAP database test harness runs locally.
-- Affected Area: Supabase
-- RLS Impact: None; no product schema or policies are created.

begin;

select plan(1);

select pass('INFRA-61 pgTAP database test harness is wired');

select * from finish();

rollback;
