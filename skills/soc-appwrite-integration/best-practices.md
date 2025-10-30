# Best Practices

## Schema Management

### ✅ Always Regenerate Schemas After YAML Changes

```bash
# After modifying any .yaml file in collections/
npm run generate:schemas

# Verify type safety
npm run typecheck
```

### ✅ Commit YAML + Generated Files Together

```bash
git add src/.appwrite/collections/PostContainer.yaml
git add src/.appwrite/schemas/postContainer.ts
git add src/.appwrite/constants/appwrite-constants.ts
git commit -m "Add publishedAt field to PostContainer"
```

### ✅ Use Environment Variables for Collection IDs

```typescript
// ✅ Good - allows per-environment configuration
import { APPWRITE_COLL_POST_CONTAINER } from "astro:env/client"

// ❌ Bad - hardcoded IDs
const collectionId = "post_container_123"
```

### ✅ Document Schema Changes

```yaml
# collections/PostContainer.yaml
# CHANGELOG:
# 2025-01-15: Added publishedAt field for scheduled posts
# 2025-01-10: Increased title max length from 255 to 500
attributes:
  - key: publishedAt
    type: datetime
    required: false
```

## Store Development

### ✅ Always Extend BaseStore

```typescript
// ✅ Good - consistent pattern
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  constructor() {
    super(
      APPWRITE_COLL_POST_CONTAINER,
      PostContainerSchema,
      "currentPostContainer",
      "socialaize_data"
    )
  }
}

// ❌ Bad - manual implementation
class PostContainerStore {
  async get(id: string) {
    // Manual database calls, no validation, no consistency
  }
}
```

### ✅ Add Domain-Specific Methods

```typescript
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  // ... constructor

  // ✅ Good - encapsulates business logic
  async getPublishedPosts(userId: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.equal("status", "published"),
      Query.orderDesc("publishedAt")
    ])
  }

  // ✅ Good - handles complex filtering
  async getScheduledBefore(userId: string, date: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.equal("status", "scheduled"),
      Query.lessThan("scheduledAt", date)
    ])
  }
}
```

### ✅ Use Descriptive Atom Names

```typescript
// ✅ Good - clear what's stored
super(collectionId, schema, "currentPostContainer", databaseId)
super(collectionId, schema, "currentBilling", databaseId)
super(collectionId, schema, "selectedOAuthAccount", databaseId)

// ❌ Bad - ambiguous
super(collectionId, schema, "data", databaseId)
super(collectionId, schema, "item", databaseId)
```

## SSR Safety

### ✅ Always Guard Client-Only Code

```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core'

const mounted = useMounted()

// ✅ Good - only runs client-side
onMounted(async () => {
  if (mounted.value) {
    await checkAuthStatus()
  }
})

// ❌ Bad - runs during SSR
const user = await account.get()  // Will fail on server
</script>
```

### ✅ Prevent Hydration Mismatches

```vue
<script setup lang="ts">
const mounted = useMounted()
const { isAuthenticated } = useAppwriteClient()

// ✅ Prevents hydration mismatch
const showAuth = computed(() => mounted.value && isAuthenticated.value)
</script>

<template>
  <!-- ✅ Good -->
  <div v-if="showAuth">Authenticated content</div>

  <!-- ❌ Bad - can cause hydration mismatch -->
  <div v-if="isAuthenticated">Authenticated content</div>
</template>
```

### ✅ Use AppwriteServer in Astro Pages

```astro
---
// ✅ Good - server-side data fetching
import { AppwriteServer } from '@server/appwrite/AppwriteServer'

const appwrite = AppwriteServer.withSessionToken(Astro.cookies)
const posts = await appwrite.listDocuments({...})

// ❌ Bad - client-side in SSR context
import { useAppwriteClient } from '@composables/useAppwriteClient'
const { databases } = useAppwriteClient()  // Won't work in .astro
---
```

## Permission Management

### ✅ Use getClientSidePermissions() Helper

```typescript
import { getClientSidePermissions } from '@utils/appwriteUtils'

// ✅ Good - consistent permission logic
const permissions = getClientSidePermissions(
  ownerId,
  userRoles,
  oauthAccount
)

// ❌ Bad - manual permission construction
const permissions = [
  Permission.read(Role.user(userId)),
  Permission.write(Role.user(userId))
]  // Missing team and OAuth permissions
```

### ✅ Always Pass Existing Permissions on Update

```typescript
const existingPost = await postContainerStore.get(postId)

// ✅ Good - preserves existing permissions
const permissions = getClientSidePermissions(
  ownerId,
  roles,
  oauthAccount,
  existingPost.$permissions  // ← Important
)

await postContainerStore.update(postId, { title: "Updated" }, permissions)

// ❌ Bad - overwrites existing permissions
const permissions = getClientSidePermissions(ownerId, roles, oauthAccount)
await postContainerStore.update(postId, { title: "Updated" }, permissions)
```

### ✅ Scope OAuth Content Properly

```typescript
// ✅ Good - OAuth content includes OAuth account
if (post.oauthAccountId) {
  const oauthAccount = await oauthStore.get(post.oauthAccountId)
  permissions = getClientSidePermissions(teamId, roles, oauthAccount)
} else {
  permissions = getClientSidePermissions(teamId, roles)
}

// ❌ Bad - OAuth content without scoping
permissions = getClientSidePermissions(teamId, roles)  // Missing OAuth account
```

## Type Safety

### ✅ Let Zod Infer Types

```typescript
import { PostContainerSchema, type PostContainer } from '@appwrite/schemas/postContainer'

// ✅ Good - type inferred from schema
type PostContainer = z.infer<typeof PostContainerSchema>

// ❌ Bad - manual type definition (can drift from schema)
interface PostContainer {
  title: string
  content: string
  // ... manual typing
}
```

### ✅ Validate Before Creating/Updating

```typescript
import { PostContainerSchema } from '@appwrite/schemas/postContainer'

// ✅ Good - validates before sending to Appwrite
try {
  const validated = PostContainerSchema.parse(formData)
  await postContainerStore.create(validated)
} catch (error) {
  if (error instanceof z.ZodError) {
    console.error("Validation errors:", error.errors)
  }
}

// ❌ Bad - no validation
await postContainerStore.create(formData)  // Might fail in Appwrite
```

### ✅ Use TypeScript Strict Mode

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

## Error Handling

### ✅ Handle Specific Appwrite Errors

```typescript
try {
  await postContainerStore.create({...})
} catch (error) {
  if (error.code === 401) {
    console.error("Unauthorized: Session expired")
    // Redirect to login
  } else if (error.code === 403) {
    console.error("Forbidden: Insufficient permissions")
    // Show permission error
  } else if (error.code === 404) {
    console.error("Not found: Resource doesn't exist")
  } else {
    console.error("Unknown error:", error)
  }
}
```

### ✅ Graceful Degradation

```typescript
async function loadPosts() {
  try {
    return await postContainerStore.getAll([...])
  } catch (error) {
    console.error("Failed to load posts:", error)
    // Return empty array instead of crashing
    return []
  }
}
```

### ✅ Log Errors for Debugging

```typescript
try {
  await operation()
} catch (error) {
  console.error("Operation failed:", {
    errorCode: error.code,
    errorMessage: error.message,
    context: { userId, postId }
  })
  throw error  // Re-throw for higher-level handling
}
```

## Performance

### ✅ Use getAll() for Small Datasets

```typescript
// ✅ Good - reasonable dataset size
const userPosts = await postContainerStore.getAll([
  Query.equal("userId", userId)
])  // Handles pagination automatically

// ❌ Bad - potentially huge dataset
const allPosts = await postContainerStore.getAll([])  // No filters!
```

### ✅ Use Pagination for Large Datasets

```typescript
// ✅ Good - paginated requests
async function loadPage(page: number) {
  const limit = 25
  const offset = page * limit

  return postContainerStore.list([
    Query.limit(limit),
    Query.offset(offset),
    Query.orderDesc("$createdAt")
  ])
}
```

### ✅ Count Before Fetching

```typescript
// ✅ Good - check count first
const count = await postContainerStore.countDocsInCollection(queries)

if (count > 1000) {
  // Use pagination
  const firstPage = await postContainerStore.list([...queries, Query.limit(25)])
} else {
  // Can use getAll()
  const all = await postContainerStore.getAll(queries)
}
```

### ✅ Use listRaw() When Validation Not Needed

```typescript
// ✅ Good - skip validation for IDs only
const rawDocs = await postContainerStore.listRaw([
  Query.select(["$id", "title"]),
  Query.equal("status", "published")
])

const ids = rawDocs.map(doc => doc.$id)

// ❌ Bad - unnecessary validation overhead
const docs = await postContainerStore.list([
  Query.select(["$id", "title"]),
  Query.equal("status", "published")
])  // Validates against full schema
```

## Database Selection

### ✅ Use Appropriate Database

```typescript
// ✅ Good - OAuth in oauth database
class OAuthStore extends BaseStore<typeof OAuthAccountSchema> {
  constructor() {
    super(
      APPWRITE_COLL_OAUTH_ACCOUNT,
      OAuthAccountSchema,
      "currentOAuthAccount",
      "oauth"  // ← Correct database
    )
  }
}

// ✅ Good - Platform content in platform database
class InstagramPostStore extends BaseStore<typeof InstagramPostSchema> {
  constructor() {
    super(
      APPWRITE_COLL_INSTAGRAM_POST,
      InstagramPostSchema,
      "currentInstagramPost",
      "instagram"  // ← Platform-specific database
    )
  }
}
```

### ✅ Document Database Choice

```typescript
/**
 * Stores billing information in stripe database
 * Isolated from main app data for compliance and security
 */
class BillingStore extends BaseStore<typeof BillingSchema> {
  constructor() {
    super(
      APPWRITE_COLL_BILLING,
      BillingSchema,
      "currentBilling",
      "stripe"  // ← Documented reason
    )
  }
}
```

## Security

### ✅ Never Expose Admin Key Client-Side

```typescript
// ✅ Good - admin key only on server
const appwrite = AppwriteServer.withAdminKey()  // Server-side only

// ❌ Bad - exposing admin key
const client = new Client()
  .setEndpoint(APPWRITE_ENDPOINT)
  .setKey(ADMIN_KEY)  // ❌ Never in client code!
```

### ✅ Always Validate Input

```typescript
// ✅ Good - validate all user input
const CreatePostSchema = z.object({
  title: z.string().min(1).max(500),
  content: z.string().max(10000),
  status: z.enum(['draft', 'published'])
})

const validated = CreatePostSchema.parse(userInput)
await postContainerStore.create(validated)

// ❌ Bad - trusting user input
await postContainerStore.create(userInput)
```

### ✅ Use Session Token in API Routes

```typescript
// ✅ Good - respects user permissions
export const POST: APIRoute = async ({ cookies }) => {
  const appwrite = AppwriteServer.withSessionToken(cookies)
  // Operations use user's session
}

// ❌ Bad - bypasses permissions (admin key)
export const POST: APIRoute = async () => {
  const appwrite = AppwriteServer.withAdminKey()
  // User can access anything!
}
```

## Testing

### ✅ Test Validation Schemas

```typescript
import { PostContainerSchema } from '@appwrite/schemas/postContainer'

describe('PostContainerSchema', () => {
  it('validates valid data', () => {
    const validData = {
      title: "Test Post",
      content: "Content here",
      userId: "user123",
      createdAt: new Date().toISOString()
    }

    expect(() => PostContainerSchema.parse(validData)).not.toThrow()
  })

  it('rejects invalid data', () => {
    const invalidData = {
      title: "",  // Empty title should fail
      content: "Content"
    }

    expect(() => PostContainerSchema.parse(invalidData)).toThrow()
  })
})
```

### ✅ Test Store Methods

```typescript
import { postContainerStore } from '@stores/postContainerStore'

describe('PostContainerStore', () => {
  it('creates post with validation', async () => {
    const post = await postContainerStore.create({
      title: "Test",
      content: "Content",
      userId: "user123",
      createdAt: new Date().toISOString()
    })

    expect(post.$id).toBeDefined()
    expect(post.title).toBe("Test")
  })
})
```

## Summary

Key best practices:
- **Schema management** - Regenerate after YAML changes, commit together
- **Store development** - Always extend BaseStore, add domain methods
- **SSR safety** - Guard client code, prevent hydration mismatches
- **Permissions** - Use helper function, preserve existing permissions
- **Type safety** - Let Zod infer types, validate input
- **Error handling** - Handle specific errors, graceful degradation
- **Performance** - Use pagination, count before fetch, skip validation when possible
- **Database selection** - Use appropriate database, document choices
- **Security** - Never expose admin key, validate input, use session tokens
- **Testing** - Test schemas and stores

Next: See [troubleshooting.md](./troubleshooting.md) for common issues and solutions.
