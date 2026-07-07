# Docs Validation

The `Docs Validation` workflow performs lightweight Markdown checks for Scout planning and documentation files. It intentionally avoids broad editorial style rules and external link validation so early CI catches low-level breakage without creating noisy documentation churn.

Run the check locally from the repository root:

```sh
ruby .github/scripts/validate-markdown.rb .github/markdown-validation.yml
```

The committed config in `.github/markdown-validation.yml` lists the Markdown paths validated by CI. Current rules check that matched files are valid UTF-8, do not contain unresolved merge conflict markers, and have balanced fenced code blocks.
