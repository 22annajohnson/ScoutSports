# GitHub

This directory contains GitHub workflows, templates, and repository automation for Scout.

Existing iOS CI lives under `workflows/`. Future monorepo changes should update GitHub automation through approved technical plans when build, test, packaging, or deployment behavior changes.

Future Supabase and web validation checks are documented as placeholders in `future-validation-placeholders.md`. They are not active workflows or required status checks until approved follow-up plans define the repository structure, commands, and any required secrets.

The `iOS Tests` workflow uses a lightweight change-detection job so expensive macOS test runs start only for app-relevant changes: the iOS app, Xcode project, tests, design package, Fastlane, Bundler files, or Makefile. Documentation-only changes, planning files, PR/issue templates, CODEOWNERS, Dependabot config, and GitHub workflow/config changes should rely on the docs and YAML validation workflows instead of launching iOS tests.

Required validation workflows should not use top-level `paths` filters. GitHub leaves required checks pending when a workflow is skipped before it creates a check run, so `Docs Validation` and `GitHub Actions Validation` always start on pull requests and pushes to `develop`. Each job performs its own changed-file detection and exits successfully without running the validator when no relevant files changed.

Dependabot version updates are configured in `dependabot.yml` for the package surfaces currently present in the repository: GitHub Actions at the repository root, Bundler under `Scout/`, and the Swift package under `Scout/ScoutDesign/`. Each ecosystem checks weekly on Monday morning, targets `develop`, and limits version-update pull requests to two open PRs per ecosystem so dependency work stays reviewable. No private registries or secrets are configured. Dependabot applies its standard dependency labels unless repository owners customize labels in GitHub.

## Local iOS CI Validation

For the complete local pre-PR checklist, see `local-ci-validation.md`.

PR CI is the default first full validation pass for agents. Run the full Swift tests command locally only when targeted local validation is requested or when debugging a failed CI check.

Run the Swift tests check with safe placeholder Supabase configuration from the repository root when needed:

```sh
cd Scout
SUPABASE_SCHEME=https \
SUPABASE_HOST=example.supabase.co \
SUPABASE_ANON_KEY=test-anon-key \
make test
```

The placeholder Supabase values are allowed only for build/test workflows that need the app to initialize without contacting a real backend. Unit and UI test launch should not require real Supabase calls, and real Supabase secrets must not be exposed to ordinary pull request workflows.

Do not weaken `SupabaseConfig` production validation. Outside controlled test and CI contexts, Scout should still fail loudly when required Supabase configuration is missing.

Fastlane should run from the repository-pinned bundle during CI. Do not enable `update_fastlane` in the Fastfile for pull request checks, because self-updating can replace the locked Fastlane gem during a run and break Bundler before tests execute.
