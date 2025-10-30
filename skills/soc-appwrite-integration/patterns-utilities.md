# Common Patterns & Utilities

## Overview

This documents common integration patterns, utility functions, and workflows used throughout the Socialaize codebase.

## useAuth Composable

**Location**: `src/components/composables/useAuth.ts`

Wraps `authStore` and `useAppwriteClient` with higher-level auth operations.

### API

```typescript
export function useAuth() {
  const user = useStore(curUser)          // Current user from store
  const session = useStore(curUserSession)  // Current session
  const mounted = useMounted()
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  const isAuthenticated = computed(() => !!user.value)
  const isEmailVerified = computed(() => user.value?.emailVerification === true)

  return {
    user,
    session,
    isLoading,
    error,
    isAuthenticated,
    isEmailVerified,
    login,
    logout,
    getCurrentUser,
    getJwt
  }
}
```

### Login Flow

```typescript
async function login(email: string, password: string) {
  isLoading.value = true
  error.value = null

  try {
    // 1. Create email session
    const session = await account.createEmailSession(email, password)

    // 2. Update session in useAppwriteClient
    setSession(session.$id)

    // 3. Fetch user profile
    const user = await account.get()

    // 4. Store in authStore
    authStore.current = user

    // 5. Trigger realtime connection (if applicable)
    // initializeRealtimeConnection()

    return user
  } catch (err) {
    error.value = err.message
    throw err
  } finally {
    isLoading.value = false
  }
}
```

### Logout Flow (Comprehensive Cleanup)

The logout process includes sophisticated safety features and cleanup:

```typescript
async function logout() {
  try {
    // Step 1: Clear all reactive stores (10+ stores)
    clearCurUser()
    clearSelectedUserTeam()
    clearBilling()
    clearBillingBonus()
    clearOAuthCache()
    clearSelectedPricingTier()
    clearAnalyticDashboards()
    clearAnalyticWidgets()
    clearChatMessages()
    clearWorkflows()
    // ... more store cleanup

    // Step 2: Clear Appwrite session
    await account.deleteSession('current')

    // Step 3: Clear session in useAppwriteClient
    clearSession()

    // Step 4: Redirect to login
    router.push('/login')
  } catch (err) {
    // Emergency cleanup even if logout fails
    clearSession()
    error.value = "Logout failed, but session cleared locally"
  }
}
```

### Logout Protection Mechanisms

**Two-stage timeout protection**:
```typescript
let logoutInProgress = false
let lastLogoutTimestamp = 0

async function logout() {
  const now = Date.now()

  // Prevent duplicate logout within 2 seconds
  if (logoutInProgress) {
    console.warn("Logout already in progress")
    return
  }

  // Prevent duplicate logout within 5 seconds
  if (now - lastLogoutTimestamp < 5000) {
    console.warn("Logout called too recently")
    return
  }

  logoutInProgress = true
  lastLogoutTimestamp = now

  try {
    // ... logout logic
  } finally {
    setTimeout(() => {
      logoutInProgress = false
    }, 2000)
  }
}
```

**Session synchronization across tabs/windows**:
```typescript
// Listen for logout in other tabs
window.addEventListener('storage', (event) => {
  if (event.key === 'cookieFallback' && !event.newValue) {
    // Session cleared in another tab - sync logout
    clearLocalState()
  }
})
```

### Usage in Components

```vue
<script setup lang="ts">
import { useAuth } from '@composables/useAuth'

const { user, isAuthenticated, login, logout } = useAuth()

async function handleLogin() {
  try {
    await login(email.value, password.value)
    router.push('/dashboard')
  } catch (error) {
    console.error("Login failed:", error)
  }
}
</script>

<template>
  <div v-if="isAuthenticated">
    <p>Welcome, {{ user.name }}!</p>
    <button @click="logout">Logout</button>
  </div>
</template>
```

## Batch Operations

### listDocumentsInBatches()

**Location**: `src/utils/appwriteUtils.ts`

Handles Appwrite's Query.equal() limit of 100 items.

```typescript
export const listDocumentsInBatches = async <T>(\n  client: Client,
  databaseId: string,
  collectionId: string,
  idAttribute: string,
  ids: string[],
  queries?: string[]
) => {
  // Split IDs into chunks of 100
  const chunks = splitIdsIntoChunks(ids, 100)
  const documents: T[] = []

  for (const chunk of chunks) {
    const response = await databases.listDocuments(databaseId, collectionId, [
      ...(queries || []),
      Query.equal(idAttribute, chunk),
      Query.limit(chunk.length)
    ])
    documents.push(...response.documents as unknown as T[])
  }

  return documents
}
```

**Usage**:
```typescript
// Need to fetch 250 posts by ID
const postIds = [...250 IDs...]

const posts = await listDocumentsInBatches(
  client,
  'socialaize_data',
  APPWRITE_COLL_POST_CONTAINER,
  '$id',
  postIds
)

// Returns all 250 posts (automatically batched in 3 requests)
```

### splitIdsIntoChunks()

```typescript
function splitIdsIntoChunks(ids: string[], chunkSize: number = 100): string[][] {
  const chunks: string[][] = []
  for (let i = 0; i < ids.length; i += chunkSize) {
    chunks.push(ids.slice(i, i + chunkSize))
  }
  return chunks
}
```

## Session Management Patterns

### Pattern 1: Initialize Session from Cookies

```typescript
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { initializeSessionFromCookies, checkAuthStatus } = useAppwriteClient()

// On app load
onMounted(async () => {
  // Restore session from cookies/localStorage
  initializeSessionFromCookies(sessionToken, userObject)

  // Verify session is still valid
  const user = await checkAuthStatus()

  if (user) {
    console.log("Session restored:", user.name)
  } else {
    console.log("No valid session found")
  }
})
```

### Pattern 2: Refresh Session from Storage

```typescript
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { refreshClientSession, checkAuthStatus } = useAppwriteClient()

// After page reload
onMounted(async () => {
  // Read session from localStorage
  refreshClientSession()

  // Verify it's still valid
  await checkAuthStatus()
})
```

### Pattern 3: Session Expiry Handling

```typescript
import { useAppwriteClient } from '@composables/useAppwriteClient'
import { useRouter } from 'vue-router'

const { checkAuthStatus, clearSession } = useAppwriteClient()
const router = useRouter()

async function ensureAuthenticated() {
  try {
    const user = await checkAuthStatus()
    return user
  } catch (error) {
    if (error.code === 401) {
      clearSession()
      router.push('/login?expired=true')
    }
    throw error
  }
}
```

## Dual Cookie Fallback

### App-Level Fallback

```typescript
import { useLocalStorage } from '@vueuse/core'

const fallbackCookies = useLocalStorage<Record<string, string>>("fallbackCookies", {})

// Store session
fallbackCookies.value = {
  [`a_session_${APPWRITE_PROJECT_ID}`]: sessionToken
}

// Retrieve session
const sessionKey = `a_session_${APPWRITE_PROJECT_ID}`
const token = fallbackCookies.value[sessionKey]
```

### SDK-Level Fallback

```typescript
// Appwrite SDK expects localStorage.cookieFallback
if (typeof window !== 'undefined') {
  localStorage.setItem('cookieFallback', JSON.stringify({
    [`a_session_${APPWRITE_PROJECT_ID}`]: sessionToken
  }))
}

// SDK reads automatically on next request
```

### Why Both Layers?

1. **App-level** - Reactive state for Vue components
2. **SDK-level** - Appwrite SDK can read directly
3. **Hard refresh recovery** - Both layers ensure session survives page reload

## Error Handling Patterns

### Pattern 1: Permission Errors

```typescript
try {
  await postContainerStore.create({...}, permissions)
} catch (error) {
  if (error.code === 401) {
    console.error("Permission denied: Check user has proper role")
  } else if (error.code === 403) {
    console.error("Forbidden: User lacks write permission on this resource")
  } else {
    console.error("Unknown error:", error)
  }
}
```

### Pattern 2: Validation Errors

```typescript
import { z } from 'zod'

try {
  const validated = PostContainerSchema.parse(data)
  await postContainerStore.create(validated)
} catch (error) {
  if (error instanceof z.ZodError) {
    console.error("Validation errors:", error.errors)
    // Show user-friendly error messages
  } else {
    console.error("Create failed:", error)
  }
}
```

### Pattern 3: Graceful Degradation

```typescript
async function loadPosts() {
  try {
    const posts = await postContainerStore.getAll([...])
    return posts
  } catch (error) {
    console.error("Failed to load posts:", error)
    // Return empty array instead of crashing
    return []
  }
}
```

## Query Patterns

### Pattern 1: Filtered List with Pagination

```typescript
async function getFilteredPosts(userId: string, status: string, page: number = 0) {
  const limit = 25
  const offset = page * limit

  return postContainerStore.list([
    Query.equal("userId", userId),
    Query.equal("status", status),
    Query.orderDesc("$createdAt"),
    Query.limit(limit),
    Query.offset(offset)
  ])
}
```

### Pattern 2: Search with Multiple Conditions

```typescript
async function searchPosts(keyword: string, filters: {
  status?: string
  platform?: string
  dateFrom?: string
  dateTo?: string
}) {
  const queries = [Query.search("title", keyword)]

  if (filters.status) {
    queries.push(Query.equal("status", filters.status))
  }

  if (filters.platform) {
    queries.push(Query.equal("platform", filters.platform))
  }

  if (filters.dateFrom) {
    queries.push(Query.greaterThanEqual("createdAt", filters.dateFrom))
  }

  if (filters.dateTo) {
    queries.push(Query.lessThanEqual("createdAt", filters.dateTo))
  }

  queries.push(Query.orderDesc("$createdAt"))
  queries.push(Query.limit(50))

  return postContainerStore.list(queries)
}
```

### Pattern 3: Count Before Fetch

```typescript
async function loadPostsIfNotEmpty(userId: string) {
  const count = await postContainerStore.countDocsInCollection([
    Query.equal("userId", userId)
  ])

  if (count === 0) {
    console.log("No posts found")
    return { posts: [], total: 0 }
  }

  const posts = await postContainerStore.list([
    Query.equal("userId", userId),
    Query.limit(25)
  ])

  return { posts, total: count }
}
```

## File Upload Patterns

### Pattern 1: Upload with Progress

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { storage } = useAppwriteClient()
const uploadProgress = ref(0)

async function uploadFile(file: File) {
  uploadProgress.value = 0

  // Note: Appwrite SDK doesn't expose progress by default
  // Files uploaded in 5MB chunks automatically with 3-retry logic

  try {
    const uploaded = await storage.createFile(
      'global_bucket',
      ID.unique(),
      file,
      permissions
    )

    uploadProgress.value = 100
    return uploaded
  } catch (error) {
    console.error("Upload failed after 3 retries:", error)
    throw error
  }
}
</script>
```

### Pattern 2: Multiple File Upload

```typescript
async function uploadMultipleFiles(files: File[], userId: string) {
  const uploadPromises = files.map(file =>
    storage.createFile(
      'global_bucket',
      ID.unique(),
      file,
      [
        Permission.read(Role.user(userId)),
        Permission.write(Role.user(userId))
      ]
    )
  )

  // Upload all files in parallel
  const uploaded = await Promise.all(uploadPromises)
  return uploaded
}
```

### Pattern 3: File Type Validation

```typescript
async function uploadImage(file: File, userId: string) {
  // Validate file type
  const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
  if (!allowedTypes.includes(file.type)) {
    throw new Error(`Invalid file type: ${file.type}`)
  }

  // Validate file size (max 10MB for images)
  const maxSize = 10 * 1024 * 1024
  if (file.size > maxSize) {
    throw new Error(`File too large: ${file.size} bytes`)
  }

  return storage.createFile('global_bucket', ID.unique(), file, permissions)
}
```

## Realtime Subscriptions

### Pattern 1: Subscribe to Collection

```typescript
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { client } = useAppwriteClient()

const unsubscribe = client.subscribe(
  `databases.socialaize_data.collections.${APPWRITE_COLL_POST_CONTAINER}.documents`,
  (response) => {
    if (response.events.includes('databases.*.collections.*.documents.*.create')) {
      console.log("New post created:", response.payload)
      // Refresh local state
    }

    if (response.events.includes('databases.*.collections.*.documents.*.update')) {
      console.log("Post updated:", response.payload)
    }

    if (response.events.includes('databases.*.collections.*.documents.*.delete')) {
      console.log("Post deleted:", response.payload)
    }
  }
)

// Cleanup
onUnmounted(() => {
  unsubscribe()
})
```

### Pattern 2: Subscribe to Specific Document

```typescript
const unsubscribe = client.subscribe(
  `databases.socialaize_data.collections.${APPWRITE_COLL_POST_CONTAINER}.documents.${postId}`,
  (response) => {
    console.log("Post updated:", response.payload)
    // Update local reactive state
    postContainerStore.current = response.payload
  }
)
```

## Summary

Common patterns include:
- **useAuth composable** - High-level auth operations with comprehensive logout
- **Batch operations** - Handle 100+ ID queries with automatic chunking
- **Dual cookie fallback** - App-level + SDK-level session persistence
- **Logout protection** - 2-stage timeout + cross-tab synchronization
- **Error handling** - Permission, validation, graceful degradation
- **Query patterns** - Filtered lists, search, count before fetch
- **File uploads** - Validation, multiple uploads, automatic 5MB chunking
- **Realtime** - Collection and document subscriptions

Next: See [best-practices.md](./best-practices.md) for development guidelines.
