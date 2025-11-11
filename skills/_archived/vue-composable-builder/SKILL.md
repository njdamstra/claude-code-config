---
name: Vue Composable Builder
description: Create Vue 3 composables using Composition API with proper architecture, SSR safety, and VueUse integration. Use when extracting reusable logic, managing side effects, orchestrating stores, or integrating with Appwrite/Nanostores. CRITICAL PATTERNS: clear structure (state → computed → methods → lifecycle), SSR safety with useMounted/useSupported, store integration without creating stores, proper cleanup. Prevents common mistakes (creating stores in composables, missing cleanup, SSR hydration errors). Use for "composable", "use*", "reusable logic", "side effects", "orchestration".
version: 1.0.0
tags: [vue3, composables, composition-api, vueuse, ssr, stores, nanostores, appwrite, architecture, side-effects]
---

# Vue Composable Builder

## Core Philosophy

Composables are the **business logic layer** between Vue components and stores. They:
- **Orchestrate** multiple store operations
- **Handle** loading states and error handling
- **Manage** side effects (API calls, event listeners, timers)
- **Integrate** with external services (Appwrite, Nanostores, VueUse)
- **NEVER** create store instances (that's nanostore-builder's job)
- **NEVER** handle UI rendering (that's vue-component-builder's job)

---

## When to Create a Composable

### ✅ CREATE a Composable When:
1. Logic is reused across **3+ components**
2. Combining **multiple reactive sources** (stores, refs, computed)
3. Managing **side effects** (event listeners, API calls, timers, WebSockets)
4. Accessing **browser APIs** (localStorage, geolocation, camera, etc.)
5. **Orchestrating multiple stores** (auth + billing + teams)
6. Adding **loading/error states** on top of store operations

### ❌ DON'T Create a Composable When:
1. Logic is used in only **1-2 components** (keep inline)
2. Simple **one-liner computed properties**
3. No **side effects** to manage
4. Better suited as a **utility function** (pure transformation)

---

## Composable Structure Pattern

**ALWAYS follow this structure:**

```typescript
// composables/useFeature.ts
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useStore } from '@nanostores/vue'
import { someStore } from '@/stores/someStore'

export function useFeature(options: FeatureOptions = {}) {
  // === 1. REACTIVE STATE ===
  const isLoading = ref(false)
  const error = ref<Error | null>(null)
  const data = ref<DataType | null>(null)

  // === 2. STORE INTEGRATION ===
  const storeData = useStore(someStore)

  // === 3. COMPUTED PROPERTIES ===
  const isReady = computed(() => !isLoading.value && data.value !== null)
  const displayText = computed(() => data.value?.title ?? 'Loading...')

  // === 4. METHODS ===
  async function fetchData() {
    isLoading.value = true
    error.value = null
    try {
      const response = await fetch('/api/data')
      data.value = await response.json()
    } catch (err) {
      error.value = err instanceof Error ? err : new Error('Failed to fetch')
    } finally {
      isLoading.value = false
    }
  }

  function reset() {
    data.value = null
    error.value = null
    isLoading.value = false
  }

  // === 5. LIFECYCLE & SIDE EFFECTS ===
  onMounted(() => {
    if (options.autoFetch) {
      fetchData()
    }
  })

  onUnmounted(() => {
    // Cleanup: remove event listeners, cancel timers, etc.
    reset()
  })

  // === 6. RETURN CLEAR API ===
  return {
    // State (readonly or reactive refs)
    isLoading: readonly(isLoading),
    error: readonly(error),
    data: readonly(data),
    isReady,
    displayText,

    // Methods
    fetchData,
    reset
  }
}

interface FeatureOptions {
  autoFetch?: boolean
}

type DataType = {
  title: string
  // ... other fields
}
```

---

## Store Integration Patterns

### Pattern 1: Direct Store Access (Simple Cases)

**When:** Component needs simple store data with no orchestration

```typescript
// Component directly uses store
import { useStore } from '@nanostores/vue'
import { $user } from '@/stores/authStore'

const user = useStore($user)
```

**No composable needed** - keep it simple!

---

### Pattern 2: Composable Wraps Store (Orchestration)

**When:** Need loading states, error handling, or multi-store coordination

```typescript
// composables/useAuth.ts
import { ref, computed } from 'vue'
import { useStore } from '@nanostores/vue'
import { curUser, loginUser, logoutUser } from '@/stores/authStore'
import { selectedUserTeam, clearSelectedUserTeam } from '@/stores/teamStore'
import { clearBilling } from '@/stores/billingStore'

export function useAuth() {
  // Import store atom (don't create new store!)
  const user = useStore(curUser)

  // Add component-level state
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Computed based on store
  const isAuthenticated = computed(() => user.value !== null)
  const userName = computed(() => user.value?.name ?? 'Guest')

  // Orchestrate multiple stores
  async function login(email: string, password: string) {
    isLoading.value = true
    error.value = null
    try {
      await loginUser(email, password) // Store method
      // Orchestration: Clear related stores
      clearSelectedUserTeam()
      clearBilling()
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Login failed'
      throw err
    } finally {
      isLoading.value = false
    }
  }

  async function logout() {
    isLoading.value = true
    try {
      await logoutUser() // Store method
      clearSelectedUserTeam()
      clearBilling()
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Logout failed'
    } finally {
      isLoading.value = false
    }
  }

  return {
    user,
    isLoading,
    error,
    isAuthenticated,
    userName,
    login,
    logout
  }
}
```

**Key Points:**
- ✅ Imports store atoms and methods
- ✅ Adds loading/error states
- ✅ Orchestrates multiple stores
- ✅ Provides component-friendly API
- ❌ Does NOT create new store instances

---

### Pattern 3: Store-Like Composable (No BaseStore Backing)

**When:** Non-Appwrite data, custom APIs, client-side state only

```typescript
// composables/useMediaLibrary.ts
import { ref, computed } from 'vue'
import { persistentAtom } from 'nanostores'
import { useStore } from '@nanostores/vue'

// Persistent atom for client state (not BaseStore)
const mediaState = persistentAtom<MediaState>('media-state', {
  currentFolder: null,
  items: [],
  lastFetch: 0
}, {
  encode: JSON.stringify,
  decode: JSON.parse
})

export function useMediaLibrary() {
  const state = useStore(mediaState)
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  // Computed derived state
  const fileCount = computed(() => state.value.items.filter(i => i.type === 'file').length)
  const folderCount = computed(() => state.value.items.filter(i => i.type === 'folder').length)

  // Methods that interact with custom APIs
  async function fetchItems(teamId: string, folderId: string) {
    isLoading.value = true
    error.value = null
    try {
      const [folders, files] = await Promise.all([
        listFolders(teamId, folderId), // Custom API call
        listFiles(teamId, folderId)     // Custom API call
      ])

      mediaState.set({
        ...mediaState.get(),
        currentFolder: folderId,
        items: [...folders, ...files],
        lastFetch: Date.now()
      })
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Failed to fetch media'
    } finally {
      isLoading.value = false
    }
  }

  return {
    state,
    isLoading,
    error,
    fileCount,
    folderCount,
    fetchItems
  }
}

interface MediaState {
  currentFolder: string | null
  items: MediaItem[]
  lastFetch: number
}

interface MediaItem {
  id: string
  type: 'file' | 'folder'
  name: string
}
```

**Key Points:**
- ✅ Uses `persistentAtom` for client state
- ✅ Composable provides enhanced interface
- ✅ Handles custom APIs (not Appwrite collections)
- ❌ Does NOT use BaseStore (no Appwrite collection backing)

---

## VueUse Integration Patterns

### SSR-Safe Patterns

#### useMounted - Client-Only Code
```typescript
import { useMounted } from '@vueuse/core'
import { ref, watch } from 'vue'

export function useTheme() {
  const mounted = useMounted()
  const theme = ref<'light' | 'dark'>('light')

  // Safe: Only runs after mount
  watch(mounted, (isMounted) => {
    if (isMounted) {
      theme.value = (localStorage.getItem('theme') as any) ?? 'light'
    }
  })

  function setTheme(newTheme: 'light' | 'dark') {
    theme.value = newTheme
    if (mounted.value) {
      localStorage.setItem('theme', newTheme)
    }
  }

  return { theme, setTheme, mounted }
}
```

#### useSupported - Feature Detection
```typescript
import { useSupported } from '@vueuse/core'

export function useGeolocation() {
  // Returns false on server, true/false on client
  const isSupported = useSupported(() => 'geolocation' in navigator)

  const latitude = ref<number | null>(null)
  const longitude = ref<number | null>(null)
  const error = ref<string | null>(null)

  async function getCurrentPosition() {
    if (!isSupported.value) {
      error.value = 'Geolocation not supported'
      return
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        latitude.value = position.coords.latitude
        longitude.value = position.coords.longitude
      },
      (err) => {
        error.value = err.message
      }
    )
  }

  return {
    isSupported,
    latitude,
    longitude,
    error,
    getCurrentPosition
  }
}
```

---

### Common VueUse Composables

#### useStorage - Persistent State
```typescript
import { useStorage } from '@vueuse/core'

export function useUserPreferences() {
  // Auto-syncs with localStorage
  const preferences = useStorage('user-prefs', {
    theme: 'dark',
    notifications: true,
    language: 'en'
  }, localStorage, {
    mergeDefaults: true // Merge with defaults on updates
  })

  function reset() {
    preferences.value = {
      theme: 'dark',
      notifications: true,
      language: 'en'
    }
  }

  return { preferences, reset }
}
```

#### useAsyncState - Async Data Fetching
```typescript
import { useAsyncState } from '@vueuse/core'

export function useDashboardStats(teamId: string) {
  const { state, isReady, isLoading, error, execute } = useAsyncState(
    async () => {
      const response = await fetch(`/api/teams/${teamId}/stats`)
      return response.json()
    },
    null, // Initial value
    { immediate: false } // Don't execute immediately
  )

  return {
    stats: state,
    isReady,
    isLoading,
    error,
    refresh: execute
  }
}
```

#### useEventListener - Auto-Cleanup
```typescript
import { useEventListener } from '@vueuse/core'
import { ref } from 'vue'

export function useKeyboardShortcuts() {
  const lastKey = ref<string>('')

  // Auto-cleanup on unmount
  useEventListener(document, 'keydown', (e: KeyboardEvent) => {
    lastKey.value = e.key

    // Cmd+K for global search
    if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
      e.preventDefault()
      // Open search modal
    }
  })

  return { lastKey }
}
```

#### onClickOutside - Modal/Dropdown Closing
```typescript
import { onClickOutside } from '@vueuse/core'
import { ref } from 'vue'

export function useDropdown() {
  const isOpen = ref(false)
  const dropdownRef = ref<HTMLElement>()

  // Automatically close when clicking outside
  onClickOutside(dropdownRef, () => {
    isOpen.value = false
  })

  function toggle() {
    isOpen.value = !isOpen.value
  }

  return {
    isOpen,
    dropdownRef,
    toggle
  }
}
```

#### watchDebounced - Debounced Input Handling
```typescript
import { watchDebounced } from '@vueuse/core'
import { ref } from 'vue'

export function useSearch() {
  const searchQuery = ref('')
  const results = ref<SearchResult[]>([])
  const isSearching = ref(false)

  // Debounce search by 500ms
  watchDebounced(
    searchQuery,
    async (query) => {
      if (!query) {
        results.value = []
        return
      }

      isSearching.value = true
      try {
        const response = await fetch(`/api/search?q=${encodeURIComponent(query)}`)
        results.value = await response.json()
      } finally {
        isSearching.value = false
      }
    },
    { debounce: 500 }
  )

  return {
    searchQuery,
    results,
    isSearching
  }
}
```

#### useWindowSize - Responsive Logic
```typescript
import { useWindowSize } from '@vueuse/core'
import { computed } from 'vue'

export function useResponsive() {
  const { width, height } = useWindowSize()

  const isMobile = computed(() => width.value < 768)
  const isTablet = computed(() => width.value >= 768 && width.value < 1024)
  const isDesktop = computed(() => width.value >= 1024)

  const breakpoint = computed(() => {
    if (width.value < 640) return 'sm'
    if (width.value < 768) return 'md'
    if (width.value < 1024) return 'lg'
    if (width.value < 1280) return 'xl'
    return '2xl'
  })

  return {
    width,
    height,
    isMobile,
    isTablet,
    isDesktop,
    breakpoint
  }
}
```

---

## Appwrite Integration Patterns

**CRITICAL:** For Appwrite operations, use `useAppwriteClient` singleton from appwrite-integration skill.

### Pattern: Access Appwrite Services

```typescript
// composables/useChat.ts
import { ref } from 'vue'
import { useAppwriteClient } from '@/composables/useAppwriteClient'
import { ID } from 'appwrite'

export function useChat() {
  const { functions, databases } = useAppwriteClient()

  const messages = ref<ChatMessage[]>([])
  const isLoading = ref(false)
  const error = ref<string | null>(null)

  async function sendMessage(chatId: string, content: string) {
    isLoading.value = true
    error.value = null
    try {
      // Call Appwrite function
      const response = await functions.createExecution(
        'AI_API',
        JSON.stringify({ chatId, message: content }),
        false // Not async
      )

      const result = JSON.parse(response.responseBody)

      // Store message in database
      await databases.createDocument(
        'socialaize_data',
        'chat_messages',
        ID.unique(),
        {
          chatId,
          content: result.reply,
          role: 'assistant',
          timestamp: new Date().toISOString()
        }
      )

      messages.value.push(result)
    } catch (err) {
      error.value = err instanceof Error ? err.message : 'Failed to send message'
    } finally {
      isLoading.value = false
    }
  }

  return {
    messages,
    isLoading,
    error,
    sendMessage
  }
}

interface ChatMessage {
  chatId: string
  content: string
  role: 'user' | 'assistant'
  timestamp: string
}
```

**Key Points:**
- ✅ Uses `useAppwriteClient()` for services
- ✅ Calls functions and databases directly
- ✅ Handles loading/error states
- ❌ Does NOT create store classes

---

## Advanced Patterns

### Shared State with createSharedComposable

**When:** Multiple components need to share the same composable instance

```typescript
import { createSharedComposable, useMouse } from '@vueuse/core'

// All components will share same mouse tracking instance
export const useSharedMouse = createSharedComposable(useMouse)

// Usage in components:
const { x, y } = useSharedMouse() // Shared across all components
```

**Performance Benefit:** Prevents duplicate event listeners for expensive operations.

---

### Injection State with createInjectionState

**When:** Component-tree-scoped state (parent provides, children consume)

```typescript
import { createInjectionState } from '@vueuse/core'
import { ref } from 'vue'

// Define provider and consumer
const [useProvideTeamContext, useTeamContext] = createInjectionState((teamId: string) => {
  const team = ref<Team | null>(null)
  const isLoading = ref(false)

  async function loadTeam() {
    isLoading.value = true
    // Fetch team data
    isLoading.value = false
  }

  return { team, isLoading, loadTeam }
})

export { useProvideTeamContext, useTeamContext }

// In parent component:
useProvideTeamContext('team-123')

// In child components:
const { team, isLoading } = useTeamContext()!
```

**SSR-Safe:** Prevents cross-request pollution.

---

### Watch Utilities

```typescript
import { watchPausable, watchIgnorable, watchDebounced, watchThrottled } from '@vueuse/core'

// Pausable watch
const { pause, resume } = watchPausable(source, callback)
pause() // Stop watching temporarily
resume() // Resume watching

// Ignorable watch
const { ignoreUpdates } = watchIgnorable(source, callback)
ignoreUpdates(() => {
  source.value = 'ignored' // Won't trigger watch
})

// Debounced watch (already covered)
watchDebounced(source, callback, { debounce: 500 })

// Throttled watch
watchThrottled(source, callback, { throttle: 500 })
```

---

## Error Handling Patterns

### Standard Error Handling

```typescript
export function useDataFetcher<T>(url: string) {
  const data = ref<T | null>(null)
  const isLoading = ref(false)
  const error = ref<Error | null>(null)

  async function fetch() {
    isLoading.value = true
    error.value = null
    try {
      const response = await window.fetch(url)
      if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`)
      }
      data.value = await response.json()
    } catch (err) {
      error.value = err instanceof Error ? err : new Error('Unknown error')
      console.error('Fetch error:', err)
    } finally {
      isLoading.value = false
    }
  }

  return {
    data: readonly(data),
    isLoading: readonly(isLoading),
    error: readonly(error),
    fetch,
    retry: fetch // Alias for retry
  }
}
```

---

## Clear Boundaries

### ✅ Composables SHOULD:
- Import store atoms and methods
- Add loading/error states
- Orchestrate multiple stores
- Handle side effects (API calls, events, timers)
- Manage browser API access
- Provide component-friendly APIs
- Use VueUse for common patterns
- Clean up on unmount

### ❌ Composables SHOULD NOT:
- Create BaseStore instances (use nanostore-builder)
- Define Zod schemas (use stores or API routes)
- Render UI elements (use vue-component-builder)
- Handle Tailwind styling (use components)
- Configure Appwrite collections (use appwrite-integration)

---

## Decision Tree

### Should I create a composable or keep logic inline?

```
Is logic reused in 3+ components?
├─ YES → Create composable
└─ NO → Is there complex side-effect management?
   ├─ YES → Create composable
   └─ NO → Does it orchestrate multiple stores?
      ├─ YES → Create composable
      └─ NO → Keep inline in component
```

### Which composable pattern should I use?

```
Does this use Appwrite collections?
├─ YES → Is there a BaseStore for this collection?
│  ├─ YES → Pattern 2: Wrap store with orchestration
│  └─ NO → Create store first (nanostore-builder)
│
└─ NO → Is this client-side state only?
   ├─ YES → Pattern 3: Store-like composable with persistentAtom
   └─ NO → Pattern 1: Direct useStore() in component
```

---

## Cross-References

For related patterns, see these skills:
- **astro-vue-architect** - Astro + Vue integration, data flow patterns, when to use composables vs components in Astro context
- **vue-component-builder** - Vue component patterns and UI
- **nanostore-builder** - Create stores for Appwrite collections
- **soc-appwrite-integration** - useAppwriteClient singleton and BaseStore

---

## Composable Checklist

- [ ] Clear function name starting with `use*`
- [ ] Follows structure: state → computed → methods → lifecycle → return
- [ ] SSR-safe (uses `useMounted()` or `useSupported()` for browser APIs)
- [ ] Imports stores (doesn't create them)
- [ ] Adds loading/error states if async
- [ ] Proper cleanup in `onUnmounted()`
- [ ] Returns clear API (state + methods)
- [ ] TypeScript types defined
- [ ] Uses VueUse for common patterns
- [ ] No UI rendering logic (that's for components)
- [ ] No store creation (that's for nanostore-builder)

---

## Examples by Use Case

### Use Case 1: Form Validation
```typescript
export function useFormValidation<T>(
  initialData: T,
  validate: (data: T) => Record<string, string>
) {
  const formData = ref<T>(initialData)
  const errors = ref<Record<string, string>>({})
  const isDirty = ref(false)

  const isValid = computed(() => Object.keys(errors.value).length === 0)

  function validateField(field: keyof T) {
    const allErrors = validate(formData.value)
    if (allErrors[field as string]) {
      errors.value[field as string] = allErrors[field as string]
    } else {
      delete errors.value[field as string]
    }
  }

  function validateAll(): boolean {
    errors.value = validate(formData.value)
    isDirty.value = true
    return isValid.value
  }

  function reset() {
    formData.value = initialData
    errors.value = {}
    isDirty.value = false
  }

  return {
    formData,
    errors: readonly(errors),
    isDirty: readonly(isDirty),
    isValid,
    validateField,
    validateAll,
    reset
  }
}
```

### Use Case 2: Real-Time Updates
```typescript
import { useAppwriteClient } from '@/composables/useAppwriteClient'

export function useRealtime(channel: string) {
  const { client } = useAppwriteClient()
  const isConnected = ref(false)
  const events = ref<any[]>([])

  let unsubscribe: (() => void) | null = null

  function subscribe(callback: (event: any) => void) {
    unsubscribe = client.subscribe(channel, (response) => {
      isConnected.value = true
      events.value.push(response)
      callback(response)
    })
  }

  onUnmounted(() => {
    if (unsubscribe) {
      unsubscribe()
    }
  })

  return {
    isConnected: readonly(isConnected),
    events: readonly(events),
    subscribe
  }
}
```

### Use Case 3: Pagination
```typescript
export function usePagination<T>(
  fetchFn: (page: number, limit: number) => Promise<{ items: T[]; total: number }>
) {
  const items = ref<T[]>([])
  const currentPage = ref(1)
  const pageSize = ref(20)
  const total = ref(0)
  const isLoading = ref(false)

  const totalPages = computed(() => Math.ceil(total.value / pageSize.value))
  const hasNextPage = computed(() => currentPage.value < totalPages.value)
  const hasPrevPage = computed(() => currentPage.value > 1)

  async function loadPage(page: number) {
    if (page < 1 || page > totalPages.value) return

    isLoading.value = true
    try {
      const result = await fetchFn(page, pageSize.value)
      items.value = result.items
      total.value = result.total
      currentPage.value = page
    } finally {
      isLoading.value = false
    }
  }

  async function nextPage() {
    if (hasNextPage.value) {
      await loadPage(currentPage.value + 1)
    }
  }

  async function prevPage() {
    if (hasPrevPage.value) {
      await loadPage(currentPage.value - 1)
    }
  }

  return {
    items: readonly(items),
    currentPage: readonly(currentPage),
    pageSize,
    total: readonly(total),
    totalPages,
    hasNextPage,
    hasPrevPage,
    isLoading: readonly(isLoading),
    loadPage,
    nextPage,
    prevPage
  }
}
```

---

## Summary

**Composables are the glue layer** between components and stores:
- **Components** → UI + user interaction
- **Composables** → Business logic + orchestration + side effects
- **Stores** → Data structure + CRUD + persistence
- **Infrastructure** → Appwrite SDK + sessions + BaseStore

**Remember:** Composables enhance, they don't replace. Always check if you need a composable or if inline logic in the component is simpler.
