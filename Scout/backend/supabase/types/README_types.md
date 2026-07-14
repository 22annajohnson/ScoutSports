# Supabase Generated Types

This directory is reserved for approved generated Supabase type outputs.

## Reserved Paths

- `swift/`: reserved for future Swift generated database types.
- `typescript/`: reserved for future TypeScript generated database types.

## Current Boundary

`INFRA-35` created the generated type home. `SOCIAL-90` activates the Swift
generated type output for the Profile V1 schema.

Generated files should be committed only after the owning platform strategy,
output path, review pattern, and generation command are approved. Do not
hand-edit generated type outputs.

## Command Shape

Future schema stories may use these command shapes after the target database and output path are approved:

```text
supabase gen types --local --lang swift --schema public > backend/supabase/types/swift/Database.generated.swift
supabase gen types --local --lang typescript --schema public > backend/supabase/types/typescript/database.generated.ts
```

Generated types are data-layer artifacts. Do not pass generated Supabase row types directly into SwiftUI or domain model APIs.
