# GitHub

This directory contains GitHub workflows, templates, and repository automation for Scout.

Existing iOS CI lives under `workflows/`. Future monorepo changes should update GitHub automation through approved technical plans when build, test, packaging, or deployment behavior changes.

Pull requests must follow the label workflow documented in `AGENTS.md`, `docs/agents/AGENTS.md`, and `docs/CONTRIBUTING.md`.

In short:

- Documentation PRs start with `documentation` and `needs-stephan-review`, then move to `needs-human-review` after Stephan review.
- Stephan-authored documentation PRs skip Stephan self-review and start with `documentation` plus `needs-human-review`.
- Implementation PRs start with `needs-ai-review`, then move to `ai-reviewed` and `needs-human-review` after the opposite worker agent reviews.
- Add `needs-human-qa` when manual testing is appropriate.
- Use `architecture-risk`, `scope-risk`, and `follow-up-ticket` to make review concerns visible.
- Use `author-stephan`, `author-tom`, or `author-jerry` to show who authored the PR.
- Agents do not approve, merge, or review their own PRs.
- Agents should identify themselves as Stephan, Tom, or Jerry in PR descriptions and handoffs.
- Review comments should use the template in `docs/agents/AGENTS.md`.

## Jira Automation Safety

GitHub PR titles and descriptions should mention only the Jira ticket actually being worked by that PR. Do not include other raw Jira issue keys or Jira links for next work, related stories, dependencies, follow-ups, or story ranges. Jira automation may transition every mentioned issue key when a PR opens, passes CI, or merges.

Use plain-language references for related work in PR bodies, such as "the next repository story" or "the generated types follow-up". Keep exact follow-up ticket keys in Jira comments, roadmap docs, implementation plans, or epics instead of the GitHub PR body.
