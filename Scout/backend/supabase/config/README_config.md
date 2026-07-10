# Supabase Local Config

This directory is reserved for local Supabase configuration placeholders and setup notes.

## Current Boundary

`INFRA-35` creates the config home only. It does not link this repository to a remote Supabase project, add secrets, or activate a local stack configuration.

Future config work may document variable names, local setup, and project-linking expectations after the relevant Jira story approves that workflow. Do not commit secret values.

Run `make supabase-doctor` from the repository root to check local CLI prerequisites before starting migration work.
