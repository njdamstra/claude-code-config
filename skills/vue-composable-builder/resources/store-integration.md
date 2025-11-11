# Store Integration Patterns

### Pattern 1: Direct Store Access (Simple Cases)

**When:** Component needs simple store data with no orchestration

```typescript
// Component directly uses store
import { useStore } from '@nanostores/vue'
import { $user } from '@/stores/authStore'

const user = useStore($user)
```

**No composable needed** - keep it simple!

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

  return { state, isLoading, error, fileCount, folderCount, fetchItems }
}
```

**Key Points:**
- ✅ Uses `persistentAtom` for client state
- ✅ Composable provides enhanced interface
- ✅ Handles custom APIs (not Appwrite collections)
- ❌ Does NOT use BaseStore (no Appwrite collection backing)
