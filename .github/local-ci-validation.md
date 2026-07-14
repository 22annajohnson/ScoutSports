# Local CI Validation

Use these commands when targeted local validation is needed. Run commands from the repository root unless a command explicitly changes into `Scout/`.

PR CI is the default first full validation pass for Scout agent work. Do not run the full local test suite automatically after every small change. Prefer local commands when debugging a failed CI check, reproducing a local issue, capturing requested visual evidence, or validating a targeted fix before pushing.

## iOS Build

```sh
cd Scout
make build
```

This is the local build equivalent for app-affecting changes. It uses the repository Makefile and writes derived data under `Scout/.build/`.

## iOS Tests

Use the full local iOS test command only when a ticket, reviewer, or CI failure calls for it. It may boot more simulator resources than a focused local debugging session needs.

```sh
cd Scout
SUPABASE_SCHEME=https \
SUPABASE_HOST=example.supabase.co \
SUPABASE_ANON_KEY=test-anon-key \
make test
```

The placeholder Supabase values are allowed for local test launch because unit and UI test startup should not require real backend access. Do not use real Supabase secrets for ordinary local or pull request validation.

## Documentation Validation

```sh
ruby .github/scripts/validate-markdown.rb .github/markdown-validation.yml
```

This matches the `Docs Validation` workflow. It checks the Markdown paths listed in `.github/markdown-validation.yml`.

## GitHub Actions Validation

```sh
ruby .github/scripts/validate-yaml.rb .github/yaml-validation.yml
```

This matches the `GitHub Actions Validation` workflow. It checks the YAML paths listed in `.github/yaml-validation.yml`, including basic workflow shape for files under `.github/workflows/`.

## Supabase Validation

Use this targeted validation for Supabase schema, seed, RLS, generated type, or
workflow changes:

```sh
cd Scout
make supabase-doctor
make supabase-start
make supabase-validate-reset-seed
make supabase-test-db
make supabase-check-types-swift
make supabase-stop
```

The `Supabase Validation` workflow runs the same local-only sequence for
Supabase-relevant pull requests. It does not use production secrets, link to a
remote project, deploy migrations, create preview branches, or deploy Edge
Functions.

## GitHub-Only Validation

Some CI behavior can only be verified after a pull request is open:

- required check reporting and branch protection behavior
- GitHub-hosted macOS runner behavior
- Actions cache restore/save behavior
- CODEOWNERS review routing
- Dependabot scheduling and generated update pull requests

Document any GitHub-only verification in the PR and Jira ticket after the checks run.

## Targeted Simulator Debugging

When local simulator work is needed, prefer a single known simulator and a focused scenario. The current Makefile default test destination is:

```sh
platform=iOS Simulator,name=iPhone 17 Pro
```

Future `INFRA-52` work should add a documented one-simulator visual debugging flow for launching a deterministic screen or fixture state, capturing a simulator screenshot, and attaching or linking evidence in the PR when requested.

## Deferred Checks

Web validation, SwiftLint, release automation, and deployment checks are not part of the current v1 CI foundation unless a future approved implementation plan adds them.
