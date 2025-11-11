# VueUse Integration

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

  return { isSupported, latitude, longitude, error, getCurrentPosition }
}
```

### VueUse Composables Catalog

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

  return { stats: state, isReady, isLoading, error, refresh: execute }
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

  return { isOpen, dropdownRef, toggle }
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

  return { searchQuery, results, isSearching }
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

  return { width, height, isMobile, isTablet, isDesktop, breakpoint }
}
```
