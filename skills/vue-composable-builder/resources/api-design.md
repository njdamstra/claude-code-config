# API Design

### API Design Checklist

- [ ] **Name:** Starts with "use" prefix (`useMouse`, `useFetch`)
- [ ] **Parameters:** Accept `MaybeRefOrGetter` for flexibility
- [ ] **Return:** Plain object (easy destructuring)
- [ ] **State:** Use `ref`/`reactive` for reactivity
- [ ] **Cleanup:** Register with `onUnmounted`
- [ ] **SSR:** Guard browser APIs with `window` checks
- [ ] **Types:** Full TypeScript interfaces

### API Pattern Template

```typescript
import { ref, computed, watch, onMounted, onUnmounted, type Ref } from 'vue'
import { toValue, type MaybeRefOrGetter } from '@vueuse/core'

/**
 * Composable description
 * @param param1 - Parameter description
 * @param options - Optional configuration
 * @returns Object with state and methods
 */
export function useMyComposable(
  param1: MaybeRefOrGetter<string>,
  options?: {
    immediate?: boolean
    onSuccess?: (data: any) => void
  }
) {
  // ===== STATE =====
  const data = ref<any>(null)
  const loading = ref(false)
  const error = ref<Error | null>(null)

  // ===== COMPUTED =====
  const isReady = computed(() => data.value !== null && !loading.value)

  // ===== METHODS =====
  async function fetch() {
    loading.value = true
    try {
      data.value = await api.get(toValue(param1))
      options?.onSuccess?.(data.value)
    } catch (e) {
      error.value = e as Error
    } finally {
      loading.value = false
    }
  }

  // ===== LIFECYCLE =====
  onMounted(() => {
    if (options?.immediate) {
      fetch()
    }
  })

  // ===== RETURN =====
  return {
    // State
    data,
    loading,
    error,
    // Computed
    isReady,
    // Methods
    fetch
  }
}
```

### MaybeRefOrGetter Pattern

**Why:** Allows composables to accept static values, refs, or getters

```typescript
import { toValue, type MaybeRefOrGetter } from '@vueuse/core'

export function useSearch(query: MaybeRefOrGetter<string>) {
  const results = ref<string[]>([])

  watch(
    () => toValue(query), // Unwrap ref or getter
    async (newQuery) => {
      results.value = await api.search(newQuery)
    }
  )

  return { results }
}

// Usage - all valid:
const { results } = useSearch('static')          // Static string
const { results } = useSearch(ref('reactive'))   // Ref
const { results } = useSearch(() => query.value) // Getter
```
