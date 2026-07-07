# GitHub

This directory contains GitHub workflows, templates, and repository automation for Scout.

Existing iOS CI lives under `workflows/`. Future monorepo changes should update GitHub automation through approved technical plans when build, test, packaging, or deployment behavior changes.

## Local iOS CI Validation

Run the Swift tests check with safe placeholder Supabase configuration from the repository root:

```sh
cd Scout
SUPABASE_SCHEME=https \
SUPABASE_HOST=example.supabase.co \
SUPABASE_ANON_KEY=test-anon-key \
make test
```

The placeholder Supabase values are allowed only for build/test workflows that need the app to initialize without contacting a real backend. Unit and UI test launch should not require real Supabase calls, and real Supabase secrets must not be exposed to ordinary pull request workflows.

Do not weaken `SupabaseConfig` production validation. Outside controlled test and CI contexts, Scout should still fail loudly when required Supabase configuration is missing.
