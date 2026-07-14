# Swift Generated Types

This directory contains Scout's committed Swift generated Supabase database type
output.

Current output:

```text
backend/supabase/types/swift/Database.generated.swift
```

Generate and check the output from the repository root:

```text
make supabase-gen-types-swift
make supabase-check-types-swift
```

Generated Swift database types must remain below the repository/data mapping
boundary. SwiftUI views and domain models should consume approved domain
contracts instead.

Do not hand-edit generated Swift files. Regenerate from the approved local
database target after migrations have been applied and reset.
