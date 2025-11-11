# Examples by Use Case

### Example 1: usePagination

```typescript
import { ref, computed } from 'vue'

export function usePagination(itemsPerPage = 10) {
  // State
  const currentPage = ref(1)
  const totalItems = ref(0)

  // Computed
  const totalPages = computed(() =>
    Math.ceil(totalItems.value / itemsPerPage)
  )

  const offset = computed(() =>
    (currentPage.value - 1) * itemsPerPage
  )

  const hasNextPage = computed(() =>
    currentPage.value < totalPages.value
  )

  const hasPreviousPage = computed(() =>
    currentPage.value > 1
  )

  // Methods
  function nextPage() {
    if (hasNextPage.value) {
      currentPage.value++
    }
  }

  function previousPage() {
    if (hasPreviousPage.value) {
      currentPage.value--
    }
  }

  function goToPage(page: number) {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page
    }
  }

  function reset() {
    currentPage.value = 1
  }

  return {
    currentPage,
    totalItems,
    totalPages,
    offset,
    hasNextPage,
    hasPreviousPage,
    nextPage,
    previousPage,
    goToPage,
    reset
  }
}

// Usage
const pagination = usePagination(20)
pagination.totalItems.value = 100
pagination.nextPage()
```

### Example 2: useFormValidation

```typescript
import { ref, computed } from 'vue'

interface ValidationRule {
  test: (value: string) => boolean
  message: string
}

export function useFormValidation(initialValue = '') {
  const value = ref(initialValue)
  const errors = ref<string[]>([])
  const touched = ref(false)

  const isValid = computed(() => errors.value.length === 0)

  function validate(rules: ValidationRule[]) {
    errors.value = rules
      .filter(rule => !rule.test(value.value))
      .map(rule => rule.message)
  }

  function reset() {
    value.value = initialValue
    errors.value = []
    touched.value = false
  }

  return { value, errors, touched, isValid, validate, reset }
}

// Usage
const email = useFormValidation('')

const emailRules: ValidationRule[] = [
  {
    test: (v) => v.length > 0,
    message: 'Email is required'
  },
  {
    test: (v) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v),
    message: 'Email must be valid'
  }
]

email.validate(emailRules)
```

### Example 3: useRealtime (Appwrite)

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

  return { isConnected: readonly(isConnected), events: readonly(events), subscribe }
}
```
