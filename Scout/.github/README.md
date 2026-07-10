# GitHub

This directory contains GitHub workflows, templates, and repository automation for Scout.

Existing iOS CI lives under `workflows/`. Future monorepo changes should update GitHub automation through approved technical plans when build, test, packaging, or deployment behavior changes.

## Jira Automation Safety

GitHub PR titles and descriptions should mention only the Jira ticket actually being worked by that PR. Do not include other raw Jira issue keys or Jira links for next work, related stories, dependencies, follow-ups, or story ranges. Jira automation may transition every mentioned issue key when a PR opens, passes CI, or merges.

Use plain-language references for related work in PR bodies, such as "the next repository story" or "the generated types follow-up". Keep exact follow-up ticket keys in Jira comments, roadmap docs, implementation plans, or epics instead of the GitHub PR body.
