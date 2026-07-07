# INFRA Roadmap

## Active Domain Health

- 🟢 Foundation: Repository planning scaffold and architecture foundation are defined.
- 🟡 In Progress: Planning PR stack is open.
- 🔵 Ready Next: Database and security foundation plans.
- ⚪ Planned: Supabase documentation, CI expansion, environment strategy.
- 💡 Ideas: Observability, generated types, local dev orchestration.

## 🔵 Next

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| INFRA-001 | Database Foundation | Define database ownership, migration workflow, schema documentation rules, generated types, and RLS planning requirements. | ARCH-001, docs/database/DATABASE.md | High | L |
| INFRA-002 | Security Foundation | Define security principles for auth, privacy, RLS, storage, secrets, abuse reporting, and data visibility. | ARCH-001, PROFILE-001, EVENT-001 | High | L |

## ⚪ Soon

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| INFRA-003 | Supabase Documentation Structure | Define where SQL, migrations, Edge Functions, storage policies, and generated types live in the future monorepo. | INFRA-001 | Medium | M |
| INFRA-004 | CI Strategy for Monorepo Readiness | Define how iOS, future web, docs, and backend validation should run as the repo grows. | ARCH-001 | Medium | L |

## ⚪ Later

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| INFRA-005 | Environment Strategy | Define local, staging, preview, and production environment expectations for iOS, web, and Supabase. | INFRA-001, INFRA-003 | Medium | L |
| INFRA-006 | Generated Types Strategy | Define how Supabase-generated types are produced, reviewed, and consumed by clients. | INFRA-001 | Low | M |

## 💡 Someday / Ideas

| Proposed Tech Plan ID | Title | Description | Dependencies | Priority | Complexity |
| --- | --- | --- | --- | --- | --- |
| INFRA-IDEA-001 | Observability Foundation | Explore logging, analytics, alerts, and operational dashboards. | INFRA-001 | Idea | XL |
| INFRA-IDEA-002 | Local Dev Orchestration | Explore local Supabase and app workflow automation for future monorepo development. | INFRA-003 | Idea | L |
