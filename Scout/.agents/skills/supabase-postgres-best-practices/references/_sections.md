# Curated Section Index

This repository vendors a curated subset of the upstream Supabase Postgres best-practices references. The full upstream bundle also contains connection management, monitoring, locking, data-access, and advanced-feature guides. Those files are intentionally excluded from Scout for now to keep the repository focused on near-term Supabase, schema, migration, and RLS work.

## 1. Security and RLS

Impact: critical.

Use when planning or reviewing RLS policies, grants, service-role behavior, and user-data access boundaries.

Included files:

- `security-privileges.md`
- `security-rls-basics.md`
- `security-rls-performance.md`

## 2. Schema Design

Impact: high.

Use when proposing Supabase tables, constraints, primary keys, data types, naming, and foreign-key indexes.

Included files:

- `schema-constraints.md`
- `schema-data-types.md`
- `schema-foreign-key-indexes.md`
- `schema-lowercase-identifiers.md`
- `schema-primary-keys.md`

## 3. Query and Index Planning

Impact: medium-high for schema planning.

Use when schema plans introduce indexes or query patterns that should be reviewable before migration work.

Included files:

- `query-composite-indexes.md`
- `query-index-types.md`
- `query-missing-indexes.md`
- `query-partial-indexes.md`
