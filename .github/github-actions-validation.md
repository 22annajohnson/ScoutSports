# GitHub Actions Validation

The `GitHub Actions Validation` workflow performs lightweight YAML validation for Scout GitHub Actions and related YAML config. It uses a repository-local Ruby script so the first CI foundation does not introduce an additional package manager or secrets-based workflow tests.

The workflow intentionally runs on every pull request and push to `develop` so branch protection always receives a `GitHub Actions Validation` status. The job detects changed files internally and skips the YAML validator when no YAML validation inputs changed.

Run the check locally from the repository root:

```sh
ruby .github/scripts/validate-yaml.rb .github/yaml-validation.yml
```

The committed config in `.github/yaml-validation.yml` lists the YAML paths validated by CI. Current rules check YAML syntax and basic GitHub Actions workflow shape: workflow files must define top-level `name`, `on`, and `jobs`, and each job must define `runs-on` or `uses`.

This does not validate deferred Supabase or web workflows. Add actionlint or stricter workflow validation later only after the team approves the additional tool behavior.
