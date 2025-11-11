# Vue Composable Factory

---
name: Vue Composable Factory
description: |
  Design and create Vue 3 composables with proper lifecycle management, type safety, and SSR compatibility. Use when extracting reusable logic from components, splitting monolithic composables (500+ lines), implementing async data fetching patterns, or creating shared state without stores. Works with .ts/.vue files, TypeScript, and Composition API. Use for "composable design", "useX pattern", "lifecycle management", "async composable", "composable factory", "split composable", "SSR-safe composable", or when components share behavior (not data). Prevents memory leaks and ensures proper cleanup.
version: 1.0.0
tags: [vue3, composables, composition-api, typescript, lifecycle, ssr]
---

## Quick Start

This skill helps you:
- **Design composables** with proper API surface and lifecycle management
- **Split monolithic composables** (500+ lines) into focused units
- **Implement async patterns** (data fetching, subscriptions, timers)
- **Ensure SSR safety** (useMounted guards, window checks)
- **Handle cleanup** (event listeners, intervals, watchers)

**Use when:**
- Multiple components need same **behavior** (not same data)
- Composable exceeds 300 lines
- Need lifecycle hooks or watchers
- Building reusable logic utilities

## Core Decision Framework

### Composable vs Store

**Critical distinction:** Composables provide **behavior reuse** with **isolated state per component**. Stores provide **shared singleton state**.

```typescript
// Composable: Each call = NEW state instance
export function useCounter() {
  const count = ref(0) // New count per component
  return { count, increment: () => count.value++ }
}

// Component A
const counterA = useCounter() // count = 0

// Component B
const counterB = useCounter() // NEW count = 0 (isolated!)
```

**Use composables when:**
- Multiple components need same **logic**
- Each component needs **own state**
- Logic involves lifecycle hooks
- State is ephemeral

**Use stores when:**
- Multiple components need **shared data**
- State persists across navigation
- Global application state

### Size-Based Guidelines

| Size | Action | Pattern |
|------|--------|---------|
| **< 100 lines** | Keep as single file | Simple focused composable |
| **100-300 lines** | Organize by sections | State, computed, methods, lifecycle |
| **300-500 lines** | Consider splitting | Extract sub-concerns |
| **500+ lines** | **MUST split** | Create multiple composables with composition |

## Instructions

### Step 1: Design Composable API

#### API Design Checklist

- [ ] **Name:** Starts with "use" prefix (`useMouse`, `useFetch`)
- [ ] **Parameters:** Accept `MaybeRefOrGetter` for flexibility
- [ ] **Return:** Plain object (easy destructuring)
- [ ] **State:** Use `ref`/`reactive` for reactivity
- [ ] **Cleanup:** Register with `onUnmounted`
- [ ] **SSR:** Guard browser APIs with `window` checks
- [ ] **Types:** Full TypeScript interfaces

#### API Pattern Template

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

### Step 2: Implement Common Patterns

#### Pattern 1: Basic Composable (Stateless Logic)

**Use case:** Extract reusable calculations or transformations

```typescript
// composables/useFormatting.ts
export function useFormatting() {
  function formatCurrency(amount: number): string {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }

  function formatDate(date: Date): string {
    return new Intl.DateTimeFormat('en-US').format(date)
  }

  return {
    formatCurrency,
    formatDate
  }
}
```

**Characteristics:**
- No reactive state
- Pure functions
- No lifecycle hooks
- Minimal, focused API

#### Pattern 2: Async Data Fetching

**Use case:** Reusable API call pattern with loading/error states

```typescript
import { ref, onUnmounted, type Ref } from 'vue'
import { toValue, type MaybeRefOrGetter } from '@vueuse/core'

export function useFetch<T>(url: MaybeRefOrGetter<string>) {
  const data = ref<T | null>(null) as Ref<T | null>
  const loading = ref(false)
  const error = ref<Error | null>(null)

  let abortController: AbortController | null = null

  async function execute() {
    // Cancel previous request
    abortController?.abort()
    abortController = new AbortController()

    loading.value = true
    error.value = null

    try {
      const response = await fetch(toValue(url), {
        signal: abortController.signal
      })
      data.value = await response.json()
    } catch (e) {
      if (e.name !== 'AbortError') {
        error.value = e as Error
      }
    } finally {
      loading.value = false
    }
  }

  // Cleanup on unmount
  onUnmounted(() => {
    abortController?.abort()
  })

  return {
    data,
    loading,
    error,
    execute,
    refetch: execute
  }
}

// Usage
const { data, loading, execute } = useFetch<User>('/api/user')
await execute()
```

#### Pattern 3: Event Listener Management

**Use case:** Attach DOM event listeners with auto-cleanup

```typescript
import { ref, onMounted, onUnmounted } from 'vue'

export function useMouse() {
  const x = ref(0)
  const y = ref(0)

  function update(event: MouseEvent) {
    x.value = event.pageX
    y.value = event.pageY
  }

  onMounted(() => {
    window.addEventListener('mousemove', update)
  })

  onUnmounted(() => {
    window.removeEventListener('mousemove', update)
  })

  return { x, y }
}
```

**Critical:** Always clean up event listeners to prevent memory leaks.

#### Pattern 4: Interval/Timer Management

**Use case:** Reusable timer logic with cleanup

```typescript
import { ref, onUnmounted } from 'vue'

export function useInterval(callback: () => void, interval: number) {
  const isActive = ref(false)
  let timerId: number | null = null

  function start() {
    if (isActive.value) return

    isActive.value = true
    timerId = setInterval(callback, interval)
  }

  function stop() {
    if (timerId !== null) {
      clearInterval(timerId)
      timerId = null
    }
    isActive.value = false
  }

  // Auto-cleanup on unmount
  onUnmounted(() => {
    stop()
  })

  return { isActive, start, stop }
}

// Usage
const { start, stop } = useInterval(() => {
  console.log('Tick')
}, 1000)
```

#### Pattern 5: Watchers with Cleanup

**Use case:** React to prop/state changes

```typescript
import { watch, type Ref } from 'vue'

export function useDebounce<T>(
  value: Ref<T>,
  delay: number,
  callback: (value: T) => void
) {
  let timeoutId: number | null = null

  const stopWatch = watch(value, (newValue) => {
    if (timeoutId !== null) {
      clearTimeout(timeoutId)
    }

    timeoutId = setTimeout(() => {
      callback(newValue)
    }, delay)
  })

  // Return stop function for manual cleanup
  return {
    stop: () => {
      stopWatch() // Stop watcher
      if (timeoutId !== null) {
        clearTimeout(timeoutId)
      }
    }
  }
}
```

### Step 3: Handle SSR Safety

**Critical pattern:** Guard browser APIs with `window` checks or `useMounted`

#### Pattern 1: ConfigurableWindow (VueUse Pattern)

```typescript
import { defaultWindow } from '@vueuse/core'

export function useLocalStorage(
  key: string,
  options: { window?: Window } = {}
) {
  const { window = defaultWindow } = options

  const data = ref<string | null>(null)

  // Skip if no window (SSR)
  if (window) {
    data.value = window.localStorage.getItem(key)
  }

  function set(value: string) {
    if (window) {
      window.localStorage.setItem(key, value)
    }
    data.value = value
  }

  return { data, set }
}
```

#### Pattern 2: useMounted Guard

```typescript
import { ref, onMounted } from 'vue'

export function useBrowserAPI() {
  const isMounted = ref(false)
  const data = ref<any>(null)

  onMounted(() => {
    isMounted.value = true

    // Safe to use browser APIs here
    data.value = window.innerWidth
  })

  return { data, isMounted }
}
```

### Step 4: Split Monolithic Composables

**When to split:** Composable exceeds 300 lines or handles multiple unrelated concerns.

#### Split Strategy

**Before (Monolithic useOnboardingFlow - 1675 lines):**
```typescript
export function useOnboardingFlow() {
  // 50+ state properties
  // 30+ actions
  // 20+ getters
  // Navigation logic
  // OAuth logic
  // Billing logic
  // Validation logic
  // AI recommendations
}
```

**After (Split into focused composables):**
```typescript
// composables/onboarding/useOnboardingData.ts
export function useOnboardingData() {
  // ONLY data CRUD operations
  const data = ref<OnboardingData>({})

  function update(updates: Partial<OnboardingData>) {
    Object.assign(data.value, updates)
  }

  return { data, update }
}

// composables/onboarding/useOnboardingNavigation.ts
export function useOnboardingNavigation() {
  // ONLY next/prev/goTo logic
  const currentStep = ref(1)

  function nextStep() {
    currentStep.value++
  }

  function previousStep() {
    currentStep.value--
  }

  return { currentStep, nextStep, previousStep }
}

// composables/onboarding/useOnboardingOAuth.ts
export function useOnboardingOAuth() {
  // ONLY OAuth connection management
  const connections = ref<OAuthConnection[]>([])

  async function connect(provider: string) {
    // OAuth logic
  }

  return { connections, connect }
}

// composables/onboarding/useOnboardingFlow.ts (Orchestrator)
export function useOnboardingFlow() {
  // Compose sub-composables
  const { data, update } = useOnboardingData()
  const { currentStep, nextStep, previousStep } = useOnboardingNavigation()
  const { connections, connect } = useOnboardingOAuth()

  // Orchestration logic only
  return {
    data,
    update,
    currentStep,
    nextStep,
    previousStep,
    connections,
    connect
  }
}
```

**Benefits:**
- Each composable < 200 lines
- Single responsibility
- Easy to test in isolation
- Clear dependencies

### Step 5: Implement Advanced Patterns

#### Pattern 1: Composable with Options

```typescript
import { ref, watch, type Ref } from 'vue'
import { toValue, type MaybeRefOrGetter } from '@vueuse/core'

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

#### Pattern 2: Reactive Parameters

```typescript
import { watch, ref, toValue, type MaybeRefOrGetter } from 'vue'

export function useSearch(query: MaybeRefOrGetter<string>) {
  const results = ref<string[]>([])
  const loading = ref(false)

  // Watch reactive query
  watch(
    () => toValue(query),
    async (newQuery) => {
      if (!newQuery) {
        results.value = []
        return
      }

      loading.value = true
      results.value = await api.search(newQuery)
      loading.value = false
    },
    { immediate: true }
  )

  return { results, loading }
}

// Usage with reactive query
const searchQuery = ref('')
const { results } = useSearch(searchQuery)

// Usage with static query
const { results } = useSearch('vue')
```

#### Pattern 3: Lazy Initialization

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

// Usage
const { data, initialize } = useExpensiveData()

// Only initialize when needed
onMounted(() => {
  if (someCondition) {
    initialize()
  }
})
```

## Examples

### Example 1: usePagination

**Complete implementation:**
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

// Usage in component
const pagination = usePagination(20)
pagination.totalItems.value = 100
pagination.nextPage()
```

### Example 2: useFormValidation

**Complete implementation:**
```typescript
import { ref, computed, type Ref } from 'vue'

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

  return {
    value,
    errors,
    touched,
    isValid,
    validate,
    reset
  }
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

### Example 3: useLocalStorage (SSR-Safe)

```typescript
import { ref, watch, onMounted } from 'vue'

export function useLocalStorage<T>(key: string, defaultValue: T) {
  const data = ref<T>(defaultValue)
  const isMounted = ref(false)

  onMounted(() => {
    isMounted.value = true

    // Load from localStorage
    const stored = localStorage.getItem(key)
    if (stored) {
      try {
        data.value = JSON.parse(stored)
      } catch (e) {
        console.error('Failed to parse localStorage value', e)
      }
    }

    // Watch for changes
    watch(data, (newValue) => {
      localStorage.setItem(key, JSON.stringify(newValue))
    }, { deep: true })
  })

  function remove() {
    if (isMounted.value) {
      localStorage.removeItem(key)
    }
    data.value = defaultValue
  }

  return { data, remove, isMounted }
}
```

## Anti-Patterns to Avoid

### ❌ Anti-Pattern 1: Async Lifecycle Hooks

**Problem:** Registering lifecycle hooks asynchronously won't work

```typescript
// ❌ WRONG - Won't work
setTimeout(() => {
  onMounted(() => {
    // This won't be associated with the component
  })
}, 100)

// ✅ CORRECT - Synchronous registration
onMounted(() => {
  // Can have async operations inside
  setTimeout(() => {
    // This is fine
  }, 100)
})
```

### ❌ Anti-Pattern 2: Forgetting Cleanup

**Problem:** Memory leaks from event listeners

```typescript
// ❌ WRONG - No cleanup
export function useMouse() {
  const x = ref(0)
  onMounted(() => {
    window.addEventListener('mousemove', update)
  })
  return { x }
}

// ✅ CORRECT - With cleanup
export function useMouse() {
  const x = ref(0)
  onMounted(() => {
    window.addEventListener('mousemove', update)
  })
  onUnmounted(() => {
    window.removeEventListener('mousemove', update)
  })
  return { x }
}
```

### ❌ Anti-Pattern 3: Not Returning Destructurable Objects

```typescript
// ❌ WRONG - Nested object
export function useMouse() {
  return { position: { x: ref(0), y: ref(0) } }
}

// ✅ CORRECT - Flat object
export function useMouse() {
  const x = ref(0)
  const y = ref(0)
  return { x, y }
}
```

### ❌ Anti-Pattern 4: Using ref for Large Objects

```typescript
// ❌ SUBOPTIMAL - Deep reactivity overhead
const data = ref<Product[]>(largeArray)

// ✅ BETTER - Shallow reactivity
const data = shallowRef<Product[]>(largeArray)
```

## Troubleshooting

### Issue: Composable state shared between components

**Symptoms:** Multiple components share same state unexpectedly

**Solutions:**
1. Verify composable creates new state per call (not module-level)
2. Use store for intentional state sharing
3. Check for accidental module-level refs

### Issue: Memory leaks

**Symptoms:** Performance degrades over time

**Solutions:**
1. Add `onUnmounted` cleanup for event listeners
2. Clear intervals/timeouts
3. Stop watchers if created manually: `stopWatch()`

### Issue: SSR hydration mismatches

**Symptoms:** Warning about server/client content mismatch

**Solutions:**
1. Use `useMounted()` before accessing browser APIs
2. Guard with `if (window)` checks
3. Use `<ClientOnly>` for client-only content

### Issue: Type inference fails

**Symptoms:** TypeScript can't infer return types

**Solutions:**
1. Add explicit return type annotation
2. Use `as Ref<T>` for complex refs
3. Define interfaces for return objects

## Best Practices

### ✅ DO:

1. **Name with "use" prefix**
2. **Return plain objects** (easy destructuring)
3. **Use MaybeRefOrGetter** for flexible parameters
4. **Clean up side effects** in `onUnmounted`
5. **Make SSR-safe** with window checks
6. **Use shallowRef** for large data
7. **Compose focused composables**
8. **Document with TSDoc comments**

### ❌ DON'T:

1. **Don't register lifecycle hooks async**
2. **Don't return nested reactive objects**
3. **Don't use ref for large objects** (use shallowRef)
4. **Don't forget cleanup**
5. **Don't consolidate unrelated logic**
6. **Don't access `this`**
7. **Don't mutate props**
8. **Don't skip TypeScript types**

## Related Patterns

For complementary patterns, see:
- **vue-state-architect** - When to use composables vs stores
- **vue-composition-architect** - Component composition patterns
- **nanostore-builder** - Store patterns for shared state

## References

**Official Documentation:**
- [Vue 3 Composables](https://vuejs.org/guide/reusability/composables.html)
- [VueUse](https://vueuse.org/)
- [Composition API](https://vuejs.org/api/composition-api-lifecycle.html)

**Research Sources:**
- Composable consolidation patterns (2025-11-04)
- VueUse composable patterns and guidelines
- Community best practices for composable design
