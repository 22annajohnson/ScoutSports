# Local CI Validation

Use these commands before opening or updating a CI-relevant pull request. Run commands from the repository root unless a command explicitly changes into `Scout/`.

## iOS Build

```sh
cd Scout
make build
```

This is the local build equivalent for app-affecting changes. It uses the repository Makefile and writes derived data under `Scout/.build/`.

## iOS Tests

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

## GitHub-Only Validation

Some CI behavior can only be verified after a pull request is open:

- required check reporting and branch protection behavior
- GitHub-hosted macOS runner behavior
- Actions cache restore/save behavior
- CODEOWNERS review routing
- Dependabot scheduling and generated update pull requests

Document any GitHub-only verification in the PR and Jira ticket after the checks run.

## Deferred Checks

Supabase migration validation, web validation, SwiftLint, release automation, and deployment checks are not part of the current v1 CI foundation unless a future approved implementation plan adds them.
