# Advanced Patterns

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

### Composable with Options

```typescript
interface UseAsyncOptions<T> {
  immediate?: boolean
  onSuccess?: (data: T) => void
  onError?: (error: Error) => void
  resetOnExecute?: boolean
}

export function useAsync<T>(
  asyncFn: () => Promise<T>,
  options: UseAsyncOptions<T> = {}
) {
  const {
    immediate = false,
    onSuccess,
    onError,
    resetOnExecute = true
  } = options

  const data = ref<T | null>(null)
  const loading = ref(false)
  const error = ref<Error | null>(null)

  async function execute() {
    if (resetOnExecute) {
      data.value = null
      error.value = null
    }

    loading.value = true

    try {
      const result = await asyncFn()
      data.value = result
      onSuccess?.(result)
    } catch (e) {
      error.value = e as Error
      onError?.(e as Error)
    } finally {
      loading.value = false
    }
  }

  if (immediate) {
    execute()
  }

  return { data, loading, error, execute }
}
```

### Lazy Initialization

```typescript
export function useExpensiveData() {
  const data = ref<ExpensiveData | null>(null)
  const isInitialized = ref(false)

  function initialize() {
    if (isInitialized.value) return

    // Expensive operation only when needed
    data.value = performExpensiveCalculation()
    isInitialized.value = true
  }

  return { data, initialize, isInitialized }
}

// Usage - only initialize when needed
const { data, initialize } = useExpensiveData()

onMounted(() => {
  if (someCondition) {
    initialize()
  }
})
```
