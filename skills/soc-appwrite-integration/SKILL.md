---
name: Socialaize Appwrite Integration
description: Frontend Appwrite integration for Socialaize codebase. Use when working with src/.appwrite/ schemas, BaseStore pattern, useAppwriteClient composable, or AppwriteServer wrapper. Handles auto-generated schemas (110+ collections), multi-database architecture (19 databases), team-based permissions, OAuth account scoping, SSR-safe session management, and Nanostore integration. Use for "Appwrite frontend", "BaseStore", "schema", "collection", "permission", "SSR auth", "database query", "store creation", "session management".
version: 1.0.0
tags: [appwrite, frontend, basestore, schemas, collections, permissions, ssr, multi-database, oauth, nanostores, zod, socialaize]
---

# Socialaize Appwrite Integration

## Overview

This skill documents **frontend-specific** Appwrite patterns used in the Socialaize codebase. Unlike generic Appwrite integration, this covers the project's battle-tested architecture built on:

### Core Architecture Components

1. **[src/.appwrite/ System](./appwrite-system.md)** - Auto-generated schemas and constants from YAML definitions
2. **[BaseStore Pattern](./basestore-pattern.md)** - Zod-validated CRUD operations with Nanostores integration
3. **[Client Integration](./client-integration.md)** - Global `useAppwriteClient` singleton with SSR safety
4. **[Server Integration](./server-integration.md)** - `AppwriteServer` wrapper for Astro SSR/API routes
5. **[Permission Patterns](./permissions.md)** - Team-based roles + OAuth account scoping
6. **[Multi-Database Architecture](./databases.md)** - 19 active databases for data separation
7. **[Appwrite Services](./services.md)** - Account, Teams, Storage, Functions, Avatars
8. **[Common Patterns](./patterns-utilities.md)** - Batch operations, session management, auth flows
9. **[Best Practices](./best-practices.md)** - Schema sync, type safety, SSR considerations
10. **[Troubleshooting](./troubleshooting.md)** - Common errors and solutions

## Quick Reference

### When to Use This Skill

- ✅ Creating new stores extending BaseStore
- ✅ Working with auto-generated schemas from src/.appwrite/
- ✅ Implementing SSR-safe authentication flows
- ✅ Setting up permissions with team roles or OAuth scoping
- ✅ Querying across multiple databases
- ✅ Using Appwrite services (Storage, Functions, Teams)
- ✅ Debugging session management or permission issues

### Key Differentiators from Generic Appwrite

| Generic Appwrite | Socialaize Implementation |
|------------------|---------------------------|
| Manual schemas | 110+ auto-generated from YAML |
| Direct SDK usage | BaseStore abstraction with Zod validation |
| Single database | 19 databases (9 core + 10 platform-specific) |
| Basic permissions | Team roles + OAuth account scoping with `oa_` prefix |
| Manual session handling | Dual cookie fallback with SSR recovery |
| Ad-hoc CRUD | Consistent BaseStore pattern across 23 stores |

## Architecture at a Glance

```
src/
├── .appwrite/                          # Code generation system
│   ├── config.yaml                     # Master config (19 databases)
│   ├── constants/appwrite-constants.ts # Auto-generated IDs
│   ├── schemas/*.ts                    # 110+ Zod schemas
│   └── collections/*.yaml              # Collection definitions
│
├── stores/                             # 23 BaseStore extensions
│   ├── baseStore.ts                    # Core pattern
│   ├── postContainerStore.ts          # Example store
│   └── ...
│
├── components/composables/
│   ├── useAppwriteClient.ts           # Global client singleton
│   └── useAuth.ts                      # Auth wrapper
│
└── server/appwrite/
    └── AppwriteServer.ts               # Server-side wrapper
```

## Common Tasks

### Create a New Store
```typescript
// See: basestore-pattern.md
import { BaseStore } from "./baseStore"
import { YourSchema, type YourType } from "@appwrite/schemas/yourSchema"
import { APPWRITE_COLL_YOUR_COLLECTION } from "astro:env/client"

class YourStore extends BaseStore<typeof YourSchema> {
  constructor() {
    super(
      APPWRITE_COLL_YOUR_COLLECTION,
      YourSchema,
      "currentYourItem",
      "database_id"  // See databases.md
    )
  }
}
```

### Use Appwrite Client in Component
```vue
<!-- See: client-integration.md -->
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { databases, isAuthenticated } = useAppwriteClient()

onMounted(async () => {
  await checkAuthStatus()
  // Client is ready
})
</script>
```

### Server-Side Data Fetching
```astro
---
// See: server-integration.md
import { AppwriteServer } from '@server/appwrite/AppwriteServer'

const appwrite = AppwriteServer.withSessionToken(Astro.cookies)
const data = await appwrite.listDocuments({
  databaseId: 'socialaize_data',
  collectionId: APPWRITE_COLL_POSTS
})
---
```

### Set Permissions with Team Roles
```typescript
// See: permissions.md
import { getClientSidePermissions } from '@utils/appwriteUtils'

const permissions = getClientSidePermissions(
  userId,
  ['owner', 'administrator'],
  oauthAccount  // Optional OAuth scoping
)
```

## Navigation Guide

- **New to Socialaize Appwrite?** Start with [appwrite-system.md](./appwrite-system.md) and [basestore-pattern.md](./basestore-pattern.md)
- **Creating stores?** See [basestore-pattern.md](./basestore-pattern.md) for complete API
- **SSR issues?** Check [client-integration.md](./client-integration.md) and [troubleshooting.md](./troubleshooting.md)
- **Permission errors?** See [permissions.md](./permissions.md) for team roles and OAuth scoping
- **Multi-database queries?** Consult [databases.md](./databases.md) for architecture guide
- **Using Appwrite services?** Reference [services.md](./services.md) for Teams, Storage, Functions

## Cross-References

For related patterns, see these skills:
- **vue-composable-builder** - How to use `useAppwriteClient()` in composables for business logic
- **nanostore-builder** - Creating BaseStore extensions for Appwrite collections
- **vue-component-builder** - Vue component patterns (components use composables, not Appwrite directly)

## Stats

- **110+ Collections** - Auto-generated schemas and types
- **23 Stores** - All extending BaseStore pattern
- **19 Databases** - Multi-tenant architecture with platform isolation
- **26 Functions** - Serverless backend operations
- **5 Team Roles** - owner, administrator, manager, member, shared
- **100% Type Safety** - Zod validation end-to-end

---

For detailed information on each topic, click through to the individual documentation files listed above.
