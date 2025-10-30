# Client-Side Integration

## Overview

The `useAppwriteClient` composable provides a **global singleton** for all Appwrite client operations. It handles:
- ✅ **Global singleton pattern** - one client instance across entire app
- ✅ **SSR-safe initialization** - handles server/client hydration
- ✅ **Session persistence** - dual cookie fallback system
- ✅ **Hard refresh recovery** - sessions restored after page reloads
- ✅ **Reactive state** - authentication status tracked automatically

**Location**: `src/components/composables/useAppwriteClient.ts`

## Architecture

### Global State Pattern

Uses `@vueuse/core`'s `createGlobalState()` for singleton:

```typescript
import { createGlobalState } from '@vueuse/core'

export const useAppwriteClient = createGlobalState(() => {
  // Singleton instances
  let client: Client | null = null
  let account: Account | null = null
  let databases: Databases | null = null
  let functions: Functions | null = null
  let storage: Storage | null = null
  let teams: Teams | null = null
  let avatars: Avatars | null = null

  // Reactive state
  const isInitialized = ref(false)
  const isAuthenticated = ref(false)
  const sessionToken = ref<string | undefined>(undefined)

  // ... initialization logic

  return {
    client,
    account,
    databases,
    functions,
    storage,
    teams,
    avatars,
    isInitialized,
    isAuthenticated,
    sessionToken,
    setSession,
    clearSession,
    checkAuthStatus,
    initializeSessionFromCookies,
    refreshClientSession
  }
})
```

### Exported Services

All Appwrite services are accessible:

```typescript
const {
  client,       // Appwrite Client
  account,      // Account service (auth, user management)
  databases,    // Database service (CRUD operations)
  functions,    // Functions service (serverless execution)
  storage,      // Storage service (file upload/download)
  teams,        // Teams service (team management)
  avatars,      // Avatars service (initials, QR codes)

  // Reactive state
  isInitialized,
  isAuthenticated,
  sessionToken,

  // Session management
  setSession,
  clearSession,
  checkAuthStatus,
  initializeSessionFromCookies,
  refreshClientSession
} = useAppwriteClient()
```

## Dual Cookie Fallback System

### Why Dual Fallback?

Appwrite SDK expects session tokens in a specific format in `localStorage`. Socialaize implements a two-layer approach:

1. **App-level fallback**: `useLocalStorage("fallbackCookies", {})` for reactive state
2. **SDK-level fallback**: `localStorage.cookieFallback` in Appwrite's expected format

### Implementation

```typescript
// App-level fallback (reactive)
const fallbackCookies = useLocalStorage<Record<string, string>>("fallbackCookies", {})

// SDK-level fallback (Appwrite expects this exact key)
if (typeof window !== 'undefined') {
  const existingFallback = localStorage.getItem('cookieFallback')
  if (existingFallback) {
    const parsed = JSON.parse(existingFallback)
    // Appwrite SDK expects: { a_session_${PROJECT_ID}: token }
    const sessionKey = `a_session_${APPWRITE_PROJECT_ID}`
    if (parsed[sessionKey]) {
      client.setSession(parsed[sessionKey])
    }
  }
}
```

### Session Persistence Flow

1. **User logs in** → token stored in both fallback layers
2. **Page reload** → SDK reads `localStorage.cookieFallback` automatically
3. **Hard refresh** → App-level fallback restores reactive state
4. **Session expires** → Both layers cleared

## Session Management

### Setting a Session

```typescript
const setSession = (token: string) => {
  sessionToken.value = token

  // Update app-level fallback (reactive)
  fallbackCookies.value = {
    [`a_session_${APPWRITE_PROJECT_ID}`]: token
  }

  // Update SDK-level fallback (for Appwrite SDK)
  if (typeof window !== 'undefined') {
    localStorage.setItem('cookieFallback', JSON.stringify({
      [`a_session_${APPWRITE_PROJECT_ID}`]: token
    }))
  }

  // Set session on client
  if (client) {
    client.setSession(token)
  }

  isAuthenticated.value = true
}
```

### Clearing a Session

```typescript
const clearSession = () => {
  sessionToken.value = undefined
  isAuthenticated.value = false

  // Clear app-level fallback
  fallbackCookies.value = {}

  // Clear SDK-level fallback
  if (typeof window !== 'undefined') {
    localStorage.removeItem('cookieFallback')
  }

  // Clear cookies if available
  if (typeof document !== 'undefined') {
    document.cookie = `a_session_${APPWRITE_PROJECT_ID}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`
  }
}
```

### Checking Auth Status

```typescript
const checkAuthStatus = async (): Promise<Models.User | null> => {
  if (!account) return null

  try {
    const user = await account.get()
    isAuthenticated.value = true
    return user
  } catch (error) {
    isAuthenticated.value = false
    clearSession()
    return null
  }
}
```

### Refreshing Session from Storage

```typescript
const refreshClientSession = () => {
  // Read from app-level fallback
  const sessionKey = `a_session_${APPWRITE_PROJECT_ID}`
  const token = fallbackCookies.value[sessionKey]

  if (token && client) {
    client.setSession(token)
    sessionToken.value = token
    isAuthenticated.value = true
  }
}
```

## Usage in Vue Components

### Pattern 1: Basic Usage

```vue
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { databases, isAuthenticated, checkAuthStatus } = useAppwriteClient()

onMounted(async () => {
  await checkAuthStatus()
  // Now databases is ready to use
})
</script>

<template>
  <div v-if="isAuthenticated">
    <p>You are logged in!</p>
  </div>
</template>
```

### Pattern 2: Direct Database Operations

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { useAppwriteClient } from '@composables/useAppwriteClient'
import { Query } from 'appwrite'

const { databases } = useAppwriteClient()
const posts = ref([])

async function loadPosts() {
  const result = await databases.listDocuments(
    'socialaize_data',
    APPWRITE_COLL_POST_CONTAINER,
    [Query.limit(10)]
  )
  posts.value = result.documents
}

onMounted(() => {
  loadPosts()
})
</script>
```

### Pattern 3: Account Operations

```vue
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { account, setSession } = useAppwriteClient()

async function login(email: string, password: string) {
  try {
    const session = await account.createEmailSession(email, password)
    setSession(session.$id)
    console.log("Logged in successfully")
  } catch (error) {
    console.error("Login failed:", error)
  }
}

async function logout() {
  await account.deleteSession('current')
  clearSession()
}
</script>
```

### Pattern 4: File Upload

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { useAppwriteClient } from '@composables/useAppwriteClient'
import { ID, Permission, Role } from 'appwrite'

const { storage } = useAppwriteClient()
const uploading = ref(false)

async function uploadFile(file: File, userId: string) {
  uploading.value = true
  try {
    const uploaded = await storage.createFile(
      'global_bucket',
      ID.unique(),
      file,
      [
        Permission.read(Role.user(userId)),
        Permission.write(Role.user(userId))
      ]
    )
    console.log("File uploaded:", uploaded.$id)
    return uploaded
  } finally {
    uploading.value = false
  }
}
</script>
```

### Pattern 5: Execute Functions

```vue
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'
import { ExecutionMethod } from 'appwrite'

const { functions } = useAppwriteClient()

async function triggerWorkflow(workflowId: string, data: any) {
  const execution = await functions.createExecution(
    'WorkflowManager',
    JSON.stringify({ workflowId, data }),
    false,  // sync - wait for response
    '/execute',
    ExecutionMethod.POST
  )

  const result = JSON.parse(execution.responseBody)
  return result
}
</script>
```

## Backwards-Compatible Helpers

For existing code that imports services individually:

```typescript
// Backwards-compatible exports
export const getAppwriteClientSingleton = (): Client => {
  return useAppwriteClient().client
}

export const getDatabasesSingleton = (): Databases => {
  return useAppwriteClient().databases
}

export const getAccountSingleton = (): Account => {
  return useAppwriteClient().account
}

export const getStorageSingleton = (): Storage => {
  return useAppwriteClient().storage
}

export const getFunctionsSingleton = (): Functions => {
  return useAppwriteClient().functions
}

export const getTeamsSingleton = (): Teams => {
  return useAppwriteClient().teams
}

export const setSession = (token: string) => {
  return useAppwriteClient().setSession(token)
}

export const clearSession = () => {
  return useAppwriteClient().clearSession()
}
```

### Usage of Helpers

```typescript
// Old code pattern (still works)
import { getDatabasesSingleton } from '@composables/useAppwriteClient'

const databases = getDatabasesSingleton()
await databases.listDocuments(...)
```

## SSR Considerations

### Client-Only Code

Always guard client-only operations:

```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core'
import { useAppwriteClient } from '@composables/useAppwriteClient'

const mounted = useMounted()
const { account } = useAppwriteClient()

// ✅ Good - only runs client-side
onMounted(async () => {
  if (mounted.value) {
    await account.get()
  }
})

// ❌ Bad - runs during SSR
const user = await account.get()  // Will fail on server
</script>
```

### Hydration Safety

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { isAuthenticated } = useAppwriteClient()
const mounted = useMounted()

// ✅ Prevent hydration mismatch
const showAuth = computed(() => mounted.value && isAuthenticated.value)
</script>

<template>
  <div v-if="showAuth">
    <!-- Auth-dependent content -->
  </div>
</template>
```

## Session Recovery After Page Reload

### Automatic Recovery

When page reloads:

1. **SDK reads `localStorage.cookieFallback`** automatically
2. **App-level fallback** restores reactive state
3. **`checkAuthStatus()`** verifies session is still valid
4. **If valid** → `isAuthenticated` set to true
5. **If expired** → session cleared

### Manual Recovery Trigger

```vue
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { refreshClientSession, checkAuthStatus } = useAppwriteClient()

onMounted(async () => {
  // Restore session from storage
  refreshClientSession()

  // Verify it's still valid
  await checkAuthStatus()
})
</script>
```

## Common Patterns

### Pattern 1: Auth Guard in Component

```vue
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'
import { useRouter } from 'vue-router'

const { isAuthenticated, checkAuthStatus } = useAppwriteClient()
const router = useRouter()

onMounted(async () => {
  const user = await checkAuthStatus()
  if (!user) {
    router.push('/login')
  }
})
</script>
```

### Pattern 2: Reactive Auth State

```vue
<script setup lang="ts">
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { isAuthenticated } = useAppwriteClient()

watch(isAuthenticated, (authed) => {
  if (authed) {
    console.log("User logged in")
  } else {
    console.log("User logged out")
  }
})
</script>
```

### Pattern 3: Loading State During Init

```vue
<script setup lang="ts">
import { ref } from 'vue'
import { useAppwriteClient } from '@composables/useAppwriteClient'

const { isInitialized, checkAuthStatus } = useAppwriteClient()
const loading = ref(true)

onMounted(async () => {
  await checkAuthStatus()
  loading.value = false
})
</script>

<template>
  <div v-if="loading">Loading...</div>
  <div v-else-if="isInitialized">
    <!-- App content -->
  </div>
</template>
```

## Integration with useAuth Composable

See [patterns-utilities.md](./patterns-utilities.md#useauth-composable) for how `useAuth` wraps `useAppwriteClient` with additional auth logic.

## Summary

`useAppwriteClient` provides:
- **Global singleton** - one client instance app-wide
- **SSR-safe** - guards against server-side execution
- **Dual cookie fallback** - session persistence across reloads
- **Reactive state** - authentication status tracked automatically
- **All Appwrite services** - databases, storage, functions, teams, avatars
- **Session management** - set, clear, check, refresh
- **Backwards compatible** - helper functions for existing code

Next: See [server-integration.md](./server-integration.md) for `AppwriteServer` server-side wrapper.
