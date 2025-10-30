# BaseStore Pattern

## Overview

BaseStore is the **core abstraction** for all Appwrite database operations in Socialaize. It provides:
- ✅ **Type-safe CRUD operations** with automatic Zod validation
- ✅ **Nanostores integration** for reactive state management
- ✅ **Auto-pagination** for large result sets
- ✅ **Raw operations** to bypass validation when needed
- ✅ **Upsert patterns** for idempotent operations
- ✅ **Consistent API** across all 23 stores

## BaseStore Class

**Location**: `src/stores/baseStore.ts`

### Constructor Signature

```typescript
export class BaseStore<T extends z.ZodType> {
  constructor(
    collectionId: string,       // From environment: APPWRITE_COLL_*
    schema: T,                  // Zod schema from @appwrite/schemas/*
    atomName: string,           // Unique key for localStorage persistence
    databaseId?: string         // Default: undefined (uses default DB)
  )
}
```

### Core Methods

#### Create Operations

```typescript
/**
 * Create a new document with validation
 * @param data - Document data (validated against schema)
 * @param docId - Optional document ID (uses ID.unique() if omitted)
 * @param permissions - Optional permission array
 * @returns Validated document
 */
async create(
  data: z.infer<T>,
  docId?: string,
  permissions?: string[]
): Promise<z.infer<T>>

/**
 * Create OR update document (idempotent)
 * @param docId - Document ID
 * @param data - Full document data
 * @param permissions - Optional permissions
 * @returns Validated document
 */
async upsert(
  docId: string,
  data: z.infer<T>,
  permissions?: string[]
): Promise<z.infer<T>>
```

#### Read Operations

```typescript
/**
 * Get single document by ID (with validation)
 * @param docId - Document ID
 * @returns Validated document or null if not found
 */
async get(docId: string): Promise<z.infer<T> | null>

/**
 * Get single document without validation
 * @param docId - Document ID
 * @returns Raw Appwrite document
 */
async getRaw(docId: string): Promise<Models.Document>

/**
 * List documents with pagination (25 per page by default)
 * @param queries - Appwrite Query array
 * @returns Array of validated documents
 */
async list(queries: string[]): Promise<z.infer<T>[]>

/**
 * List documents without validation
 * @param queries - Appwrite Query array
 * @returns Array of raw Appwrite documents
 */
async listRaw(queries: string[]): Promise<Models.Document[]>

/**
 * Get ALL documents with automatic pagination
 * Handles cursor-based pagination automatically
 * @param queries - Appwrite Query array
 * @returns Complete array of validated documents
 */
async getAll(queries: string[]): Promise<z.infer<T>[]>

/**
 * List with total count
 * @param queries - Appwrite Query array
 * @returns { documents: T[], total: number }
 */
async listWithTotal(queries: string[]): Promise<{
  documents: z.infer<T>[],
  total: number
}>

/**
 * Count documents matching queries
 * @param queries - Appwrite Query array
 * @returns Document count
 */
async countDocsInCollection(queries: string[]): Promise<number>
```

#### Update Operations

```typescript
/**
 * Update document with partial data
 * @param docId - Document ID
 * @param data - Partial document data
 * @param permissions - Optional permissions to update
 * @returns Validated updated document
 */
async update(
  docId: string,
  data: Partial<z.infer<T>>,
  permissions?: string[]
): Promise<z.infer<T>>
```

#### Delete Operations

```typescript
/**
 * Delete document by ID
 * @param docId - Document ID
 * @returns true if deleted, false if not found
 */
async delete(docId: string): Promise<boolean>
```

### Nanostores Integration

Each BaseStore instance includes:

```typescript
/**
 * Persistent atom stored in localStorage
 */
atom: ReturnType<typeof persistentAtom<z.infer<T> | undefined>>

/**
 * Get current stored value
 */
get current(): z.infer<T> | undefined

/**
 * Set current stored value
 */
set current(value: z.infer<T> | undefined)

/**
 * Update stored value with partial data
 */
updateStoredValue(value: Partial<z.infer<T>>): void

/**
 * Clear stored value
 */
clearStoredValue(): void
```

## Creating a Store

### Step 1: Import Schema and Constants

```typescript
import { BaseStore } from "./baseStore"
import { PostContainerSchema, type PostContainer } from "@appwrite/schemas/postContainer"
import { APPWRITE_COLL_POST_CONTAINER } from "astro:env/client"
```

### Step 2: Extend BaseStore

```typescript
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  constructor() {
    super(
      APPWRITE_COLL_POST_CONTAINER,      // Collection ID from environment
      PostContainerSchema,                // Zod schema for validation
      "currentPostContainer",             // Nanostore atom key
      "socialaize_data"                   // Database ID (see databases.md)
    )
  }

  // Add custom methods beyond CRUD
  async listUserContainers(userId: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.orderDesc("$createdAt"),
      Query.limit(50)
    ])
  }

  async getPublishedContainers() {
    return this.getAll([
      Query.equal("status", "published"),
      Query.orderDesc("publishedAt")
    ])
  }
}
```

### Step 3: Create Singleton Instance

```typescript
// Create singleton
function createPostContainerStore() {
  const store = new PostContainerStore()

  return {
    store,
    // Export atom for reactive access
    currentPostContainer: store.atom,

    // Export bound methods for convenience
    getPostContainer: store.get.bind(store),
    listPostContainers: store.list.bind(store),
    createPostContainer: store.create.bind(store),
    updatePostContainer: store.update.bind(store),
    deletePostContainer: store.delete.bind(store),
    listUserContainers: store.listUserContainers.bind(store),
    getPublishedContainers: store.getPublishedContainers.bind(store),
  }
}

// Export singleton
export const {
  store: postContainerStore,
  currentPostContainer,
  getPostContainer,
  listPostContainers,
  createPostContainer,
  updatePostContainer,
  deletePostContainer,
  listUserContainers,
  getPublishedContainers,
} = createPostContainerStore()
```

## Using Stores in Components

### Pattern 1: Basic CRUD

```vue
<script setup lang="ts">
import { postContainerStore, currentPostContainer } from '@stores/postContainerStore'
import { useStore } from '@nanostores/vue'

// Reactive store value
const post = useStore(currentPostContainer)

async function loadPost(id: string) {
  const loaded = await postContainerStore.get(id)
  if (loaded) {
    postContainerStore.current = loaded  // Updates reactive atom
  }
}

async function savePost() {
  if (!post.value) return

  await postContainerStore.update(post.value.$id, {
    title: post.value.title,
    content: post.value.content
  })
}
</script>

<template>
  <div v-if="post">
    <h1>{{ post.title }}</h1>
    <p>{{ post.content }}</p>
  </div>
</template>
```

### Pattern 2: List with Queries

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { postContainerStore } from '@stores/postContainerStore'
import { Query } from 'appwrite'

const posts = ref<PostContainer[]>([])

onMounted(async () => {
  posts.value = await postContainerStore.list([
    Query.equal("status", "published"),
    Query.orderDesc("$createdAt"),
    Query.limit(10)
  ])
})
</script>
```

### Pattern 3: Auto-Pagination for Large Sets

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { postContainerStore } from '@stores/postContainerStore'
import { Query } from 'appwrite'

const allPosts = ref<PostContainer[]>([])
const loading = ref(false)

async function loadAllUserPosts(userId: string) {
  loading.value = true
  try {
    // getAll() handles pagination automatically
    allPosts.value = await postContainerStore.getAll([
      Query.equal("userId", userId),
      Query.orderDesc("$createdAt")
    ])
  } finally {
    loading.value = false
  }
}
</script>
```

### Pattern 4: Upsert for Idempotency

```vue
<script setup lang="ts">
import { postContainerStore } from '@stores/postContainerStore'

async function saveOrUpdatePost(postId: string, data: PostContainer) {
  // Creates if doesn't exist, updates if exists
  const saved = await postContainerStore.upsert(postId, data, [
    Permission.read(Role.user(data.userId)),
    Permission.write(Role.user(data.userId))
  ])

  console.log("Saved:", saved)
}
</script>
```

## Common Patterns

### Pattern 1: Search with Filters

```typescript
async function searchPosts(keyword: string, status?: string) {
  const queries = [
    Query.search("title", keyword),
    Query.orderDesc("$createdAt"),
    Query.limit(25)
  ]

  if (status) {
    queries.push(Query.equal("status", status))
  }

  return postContainerStore.list(queries)
}
```

### Pattern 2: Pagination with Offset

```typescript
async function getPostsPage(page: number, perPage: number = 25) {
  const offset = page * perPage

  return postContainerStore.list([
    Query.offset(offset),
    Query.limit(perPage),
    Query.orderDesc("$createdAt")
  ])
}
```

### Pattern 3: Count Before Fetching

```typescript
async function getUserPostsWithCount(userId: string) {
  const queries = [Query.equal("userId", userId)]

  const total = await postContainerStore.countDocsInCollection(queries)

  if (total === 0) {
    return { posts: [], total: 0 }
  }

  const posts = await postContainerStore.list([
    ...queries,
    Query.limit(25)
  ])

  return { posts, total }
}
```

### Pattern 4: Raw Operations for Performance

```typescript
async function getPostIdsOnly(userId: string) {
  // Skip validation for better performance when only reading IDs
  const rawDocs = await postContainerStore.listRaw([
    Query.equal("userId", userId),
    Query.select(["$id", "title"])  // Only fetch ID and title
  ])

  return rawDocs.map(doc => ({ id: doc.$id, title: doc.title }))
}
```

### Pattern 5: Conditional Updates

```typescript
async function publishPost(postId: string) {
  const post = await postContainerStore.get(postId)

  if (!post) {
    throw new Error("Post not found")
  }

  if (post.status === "published") {
    console.log("Already published")
    return post
  }

  return postContainerStore.update(postId, {
    status: "published",
    publishedAt: new Date().toISOString()
  })
}
```

## All 23 Stores

Here are all stores extending BaseStore in the codebase:

### Core Application Stores
1. **postContainerStore** - Social media posts (`socialaize_data`)
2. **teamStore** - Multi-tenant teams (`socialaize_data`)
3. **billingStore** - Stripe billing data (`stripe`)
4. **billingInvoicesStore** - Invoice history (`stripe`)
5. **discountCodeStore** - Promo codes (`stripe`)
6. **userStore** - User profiles (`socialaize_data`)

### OAuth & Social Platforms
7. **oauthStore** - OAuth connections (`oauth`)
8. **blueskyPostStore** - Bluesky posts (`bluesky`)
9. **facebookPostStore** - Facebook posts (`facebook`)
10. **instagramPostStore** - Instagram posts (`instagram`)
11. **linkedInPostStore** - LinkedIn posts (`linkedin`)
12. **pinterestPostStore** - Pinterest posts (`pinterest`)
13. **threadsPostStore** - Threads posts (`threads`)
14. **tiktokPostStore** - TikTok posts (`tiktok`)
15. **youtubePostStore** - YouTube posts (`google`)
16. **mastodonPostStore** - Mastodon posts (`mastodon`)

### Chat & AI
17. **chatStore** - Chat threads (`artificial_int`)
18. **chatMessageStore** - Chat messages (`artificial_int`)
19. **aiCreditsUsedStore** - AI usage tracking (`artificial_int`)

### Analytics
20. **analyticDashboardStore** - Dashboard configs (`analytics`)
21. **analyticWidgetStore** - Widget configs (`analytics`)

### Workflows & Webhooks
22. **workflowStore** - Workflow definitions (`workflows`)
23. **webhookStore** - Webhook events (`webhooks`)

## Custom Methods Best Practices

### ✅ Domain-Specific Queries

Add methods that encapsulate common query patterns:

```typescript
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  // ✅ Good - encapsulates business logic
  async getDrafts(userId: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.equal("status", "draft"),
      Query.orderDesc("$updatedAt")
    ])
  }

  // ✅ Good - handles complex filtering
  async getScheduledPosts(userId: string, beforeDate: string) {
    return this.list([
      Query.equal("userId", userId),
      Query.equal("status", "scheduled"),
      Query.lessThan("scheduledAt", beforeDate)
    ])
  }
}
```

### ✅ Relationship Helpers

```typescript
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  async getPostsWithOAuthAccount(oauthAccountId: string) {
    return this.list([
      Query.equal("oauthAccountId", oauthAccountId),
      Query.orderDesc("$createdAt")
    ])
  }
}
```

### ✅ Aggregation Methods

```typescript
class PostContainerStore extends BaseStore<typeof PostContainerSchema> {
  async getUserPostCount(userId: string) {
    return this.countDocsInCollection([
      Query.equal("userId", userId)
    ])
  }

  async getStatusBreakdown(userId: string) {
    const statuses = ["draft", "scheduled", "published", "failed"]

    const counts = await Promise.all(
      statuses.map(status =>
        this.countDocsInCollection([
          Query.equal("userId", userId),
          Query.equal("status", status)
        ])
      )
    )

    return statuses.reduce((acc, status, i) => {
      acc[status] = counts[i]
      return acc
    }, {} as Record<string, number>)
  }
}
```

## Performance Considerations

### ✅ Use `getAll()` for Complete Sets < 1000 Items

```typescript
// ✅ Good for reasonable dataset sizes
const allUserPosts = await postContainerStore.getAll([
  Query.equal("userId", userId)
])
```

### ✅ Use `list()` + Pagination for Large Sets

```typescript
// ✅ Good for potentially large datasets
const firstPage = await postContainerStore.list([
  Query.equal("userId", userId),
  Query.limit(25),
  Query.offset(0)
])
```

### ✅ Use `countDocsInCollection()` Before Fetching

```typescript
const count = await postContainerStore.countDocsInCollection([
  Query.equal("userId", userId)
])

if (count > 1000) {
  // Use pagination
} else {
  // Can use getAll()
}
```

### ✅ Use `listRaw()` for Minimal Data

```typescript
// ✅ Skip validation overhead when only need IDs
const ids = await postContainerStore.listRaw([
  Query.select(["$id"]),
  Query.equal("status", "published")
])
```

## Validation Behavior

### Automatic Validation

All standard methods validate against the Zod schema:

```typescript
// ✅ Validated - throws if data doesn't match schema
const post = await postContainerStore.create({
  title: "My Post",
  userId: "user123",
  // Missing 'createdAt' - will throw validation error
})
```

### Bypass Validation

Use `*Raw()` methods to skip validation:

```typescript
// ✅ No validation - returns raw Appwrite document
const rawDoc = await postContainerStore.getRaw(postId)
console.log(rawDoc.customField)  // May have fields not in schema
```

## Summary

BaseStore provides:
- **Consistent CRUD API** across all 23 stores
- **Automatic Zod validation** for data integrity
- **Nanostore integration** for reactive state
- **Auto-pagination** via `getAll()` method
- **Raw operations** for performance optimization
- **Upsert support** for idempotent operations

Next: See [client-integration.md](./client-integration.md) for `useAppwriteClient` composable patterns.
