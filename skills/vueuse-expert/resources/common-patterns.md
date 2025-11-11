# Common Patterns

### Pattern 1: Combining Composables

**Responsive + Debounced + Storage:**
```typescript
import { useWindowSize, useLocalStorage, watchDebounced } from '@vueuse/core'

const { width, height } = useWindowSize()
const savedDimensions = useLocalStorage('window-dimensions', { width: 0, height: 0 })

// Save dimensions with debounce
watchDebounced(
  [width, height],
  ([w, h]) => {
    savedDimensions.value = { width: w, height: h }
  },
  { debounce: 500 }
)
```

---

### Pattern 2: Shared Mouse Tracking

**Prevent duplicate event listeners:**
```typescript
import { createSharedComposable, useMouse } from '@vueuse/core'

// Create shared instance
export const useSharedMouse = createSharedComposable(useMouse)

// In multiple components
const { x, y } = useSharedMouse() // All share same tracking
```

---

### Pattern 3: Injection State for Component Trees

**Parent-child state sharing:**
```typescript
import { createInjectionState } from '@vueuse/core'
import { ref, computed } from 'vue'

// Define provider/consumer
const [useProvideTeam, useTeam] = createInjectionState((teamId: string) => {
  const team = ref<Team | null>(null)
  const isLoading = ref(false)

  async function loadTeam() {
    isLoading.value = true
    team.value = await fetchTeam(teamId)
    isLoading.value = false
  }

  const displayName = computed(() => team.value?.name ?? 'Unknown')

  return { team, isLoading, loadTeam, displayName }
})

export { useProvideTeam, useTeam }

// In parent component
useProvideTeam('team-123')

// In any child component
const { team, isLoading, displayName } = useTeam()!
```

---

### Pattern 4: Scroll Progress Bar

**Track scroll percentage:**
```typescript
import { useWindowScroll, useWindowSize, computed } from '@vueuse/core'

const { y } = useWindowScroll()
const { height } = useWindowSize()

const scrollPercentage = computed(() => {
  const documentHeight = document.documentElement.scrollHeight
  const windowHeight = height.value
  const scrollableHeight = documentHeight - windowHeight

  return (y.value / scrollableHeight) * 100
})
```

---

### Pattern 5: Dark Mode with Persistence

**Auto dark mode + manual toggle:**
```typescript
import { useDark, useToggle } from '@vueuse/core'

const isDark = useDark({
  storageKey: 'theme',
  valueDark: 'dark',
  valueLight: 'light'
})

const toggleDark = useToggle(isDark)

// Auto-syncs with localStorage and system preference
```
