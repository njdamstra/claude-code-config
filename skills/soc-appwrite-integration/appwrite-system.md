# The src/.appwrite/ System

## Overview

Socialaize uses a **code generation** approach for Appwrite integration. Instead of manually creating schemas and types, everything is auto-generated from YAML collection definitions.

## Directory Structure

```
src/.appwrite/
├── config.yaml                    # Master config (19 active databases, generation settings)
├── constants/
│   └── appwrite-constants.ts      # Auto-generated DATABASE_IDS, COLLECTION_IDS
├── schemas/                       # 110+ TypeScript schema files
│   ├── billing.ts                 # Zod schemas for each collection
│   ├── oAuthAccount.ts
│   ├── postContainer.ts
│   └── [108 more...]
├── collections/                   # 110+ YAML collection definitions
│   ├── Billing.yaml
│   ├── OAuthAccount.yaml
│   └── [108 more...]
└── data/                          # Mock/seed data
```

## How It Works

### 1. YAML Collection Definitions

Each collection is defined in a YAML file:

```yaml
# collections/PostContainer.yaml
name: PostContainer
databaseId: socialaize_data
attributes:
  - key: title
    type: string
    size: 255
    required: true
  - key: content
    type: string
    size: 10000
    required: false
  - key: status
    type: string
    size: 50
    required: true
    default: draft
  - key: userId
    type: string
    size: 36
    required: true
  - key: createdAt
    type: datetime
    required: true
indexes:
  - key: userId_idx
    type: key
    attributes: [userId]
  - key: status_idx
    type: key
    attributes: [status]
relationships:
  - relatedCollection: User
    type: manyToOne
    onDelete: cascade
permissions:
  - read: ["user:*"]
  - write: ["user:{userId}"]
```

### 2. Auto-Generated TypeScript Schemas

From the YAML, TypeScript with Zod validation is generated:

```typescript
// schemas/postContainer.ts
import { z } from "zod"

export const PostContainerSchema = z.object({
  $id: z.string().optional(),
  $createdAt: z.string().optional(),
  $updatedAt: z.string().optional(),
  $permissions: z.array(z.string()).optional(),
  $databaseId: z.string().optional(),
  $collectionId: z.string().optional(),

  title: z.string().max(255),
  content: z.string().max(10000).optional(),
  status: z.string().max(50).default("draft"),
  userId: z.string().max(36),
  createdAt: z.string(),  // ISO 8601 datetime
})

export type PostContainer = z.infer<typeof PostContainerSchema>
```

### 3. Constants File

Collection and database IDs are centralized:

```typescript
// constants/appwrite-constants.ts
export const DATABASE_IDS = {
  SOCIALAIZE_DATA: "socialaize_data",
  SYSTEM_CONTENT: "system_content",
  OAUTH: "oauth",
  // ... 16 more
} as const

export const COLLECTION_IDS = {
  POST_CONTAINER: "post_container_id_here",
  BILLING: "billing_id_here",
  // ... 108 more
} as const
```

## Import Patterns

### Importing Schemas

```typescript
// Import both schema and type
import { PostContainerSchema, type PostContainer } from '@appwrite/schemas/postContainer'

// Use for validation
const validated = PostContainerSchema.parse(rawData)

// Use type for function signatures
function processPost(post: PostContainer) {
  // ...
}
```

### Importing Constants

```typescript
// From environment (preferred - allows per-env overrides)
import { APPWRITE_COLL_POST_CONTAINER } from "astro:env/client"

// From constants file (fallback)
import { COLLECTION_IDS } from '@appwrite/constants/appwrite-constants'

const collectionId = APPWRITE_COLL_POST_CONTAINER || COLLECTION_IDS.POST_CONTAINER
```

## Schema Generation Workflow

### When to Regenerate

Regenerate schemas when:
- ✅ Adding new collections
- ✅ Modifying collection attributes
- ✅ Changing attribute types or sizes
- ✅ Adding/removing relationships
- ✅ Updating indexes

### Generation Command

```bash
# Run schema generator (project-specific command)
npm run generate:schemas

# This reads collections/*.yaml and regenerates:
# - schemas/*.ts
# - constants/appwrite-constants.ts
```

### Post-Generation Steps

1. **Verify type safety**: Run `npm run typecheck`
2. **Update stores**: If attributes changed, update BaseStore extensions
3. **Update components**: Update components using the modified types
4. **Commit changes**: Commit both YAML and generated TypeScript together

## Key Benefits

### ✅ Schema-Attribute Alignment

YAML defines both Appwrite attributes AND TypeScript types:
- **Appwrite attribute**: `type: string, size: 255`
- **TypeScript validation**: `z.string().max(255)`

No manual sync required - generation ensures perfect alignment.

### ✅ Single Source of Truth

YAML collections are the canonical source:
- Appwrite schema configuration
- TypeScript types
- Zod validation rules
- Collection IDs
- Index definitions

### ✅ Type Safety End-to-End

```typescript
// Schema defines types
import { PostContainerSchema, type PostContainer } from '@appwrite/schemas/postContainer'

// BaseStore uses schema for validation
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  // All CRUD operations are type-safe
}

// Components get full autocomplete
const post: PostContainer = await postContainerStore.get(id)
console.log(post.title)  // ✅ TypeScript knows this exists
console.log(post.invalid)  // ❌ TypeScript error
```

### ✅ Relationship Tracking

YAML documents relationships between collections:

```yaml
# collections/PostContainer.yaml
relationships:
  - relatedCollection: User
    type: manyToOne
    onDelete: cascade
  - relatedCollection: Team
    type: manyToOne
    onDelete: cascade
```

This becomes documentation AND generates helper types.

## Common Patterns

### Pattern 1: Adding a New Collection

1. Create YAML definition:
```yaml
# collections/MyNewCollection.yaml
name: MyNewCollection
databaseId: socialaize_data
attributes:
  - key: name
    type: string
    size: 100
    required: true
```

2. Run generator:
```bash
npm run generate:schemas
```

3. Create store:
```typescript
import { MyNewCollectionSchema } from '@appwrite/schemas/myNewCollection'
class MyNewCollectionStore extends BaseStore<typeof MyNewCollectionSchema> {
  // ...
}
```

### Pattern 2: Modifying Attributes

1. Update YAML:
```yaml
attributes:
  - key: title
    size: 500  # Changed from 255
```

2. Regenerate schemas
3. Check for TypeScript errors:
```bash
npm run typecheck
```

4. Update affected stores/components if needed

### Pattern 3: Cross-Database Relationships

```yaml
# collections/PostContainer.yaml (in socialaize_data database)
relationships:
  - relatedCollection: OAuthAccount
    relatedDatabase: oauth  # Different database
    type: manyToOne
```

Generated code handles cross-database queries properly.

## Configuration

### config.yaml Structure

```yaml
# .appwrite/config.yaml
databases:
  - id: socialaize_data
    name: Socialaize Data
    enabled: true
  - id: oauth
    name: OAuth
    enabled: true
  # ... 17 more

generation:
  schemasPath: ./schemas
  collectionsPath: ./collections
  constantsPath: ./constants
  validation: zod  # Use Zod for schemas
  typescript: true
  includeMetadata: true  # Include $id, $createdAt, etc.
```

### Environment Variables

Collection IDs are exposed via environment:

```env
# .env
APPWRITE_COLL_POST_CONTAINER=post_container_collection_id
APPWRITE_COLL_BILLING=billing_collection_id
# ... 108 more
```

This allows different IDs per environment (dev, staging, prod).

## Troubleshooting

### Schema Generation Fails

**Symptom**: Generator errors when running `npm run generate:schemas`

**Common Causes**:
- Invalid YAML syntax
- Missing required fields
- Conflicting attribute names
- Invalid type definitions

**Solution**: Check YAML validator output, fix syntax errors

### Type Mismatches After Generation

**Symptom**: TypeScript errors after regenerating schemas

**Cause**: Changed attribute types or removed fields

**Solution**:
1. Run `npm run typecheck` to find all errors
2. Update affected stores and components
3. Use `z.optional()` for newly optional fields
4. Use `z.default()` for new required fields with defaults

### Collection ID Not Found

**Symptom**: `Cannot find APPWRITE_COLL_*` import error

**Cause**: Environment variable not set or constants not regenerated

**Solution**:
1. Check `.env` has the collection ID
2. Regenerate constants: `npm run generate:schemas`
3. Restart dev server to reload environment

## Best Practices

### ✅ Always Commit YAML + Generated Files Together

```bash
git add src/.appwrite/collections/PostContainer.yaml
git add src/.appwrite/schemas/postContainer.ts
git add src/.appwrite/constants/appwrite-constants.ts
git commit -m "Add PostContainer collection with title and content fields"
```

### ✅ Use Environment Variables for Collection IDs

```typescript
// ✅ Good - allows per-environment configuration
import { APPWRITE_COLL_POST_CONTAINER } from "astro:env/client"

// ❌ Bad - hardcoded, can't change per environment
const collectionId = "post_container_123"
```

### ✅ Document Relationships in YAML

Even if not enforced by Appwrite, document relationships for future developers:

```yaml
relationships:
  - relatedCollection: User
    type: manyToOne
    description: "Each post belongs to one user"
```

### ✅ Use Descriptive Attribute Names

```yaml
# ✅ Good
attributes:
  - key: publishedAt
    type: datetime
  - key: authorUserId
    type: string

# ❌ Bad
attributes:
  - key: date
    type: datetime
  - key: uid
    type: string
```

### ✅ Keep YAML Organized

Group related attributes together:

```yaml
attributes:
  # Identity
  - key: id
  - key: name

  # Content
  - key: title
  - key: body

  # Metadata
  - key: createdAt
  - key: updatedAt
```

## Summary

The `.appwrite/` system provides:
- **110+ auto-generated schemas** from YAML
- **Type-safe** Zod validation
- **Single source of truth** for Appwrite attributes and TypeScript types
- **Environment-based configuration** for collection IDs
- **Zero manual sync** between Appwrite and TypeScript

Next: See [basestore-pattern.md](./basestore-pattern.md) for how these schemas power the store architecture.
