# Composable Structure Pattern

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
```
