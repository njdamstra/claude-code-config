# Official Documentation: Vue 3 Composable Consolidation Patterns

**Research Date:** 2025-11-04
**Source:** Context7 MCP - /vuejs/docs, /vueuse/vueuse, /llmstxt/vuejs_llms-full_txt
**Version:** Vue 3.4+, VueUse 13.3.0

## Summary

Vue 3 official documentation emphasizes composables as the primary pattern for reusable stateful logic, with clear guidance on when to consolidate vs split. VueUse demonstrates advanced patterns for large composables including state sharing, performance optimization with `shallowRef`, and composition strategies. The key principle: **single responsibility with flexible composition** rather than monolithic consolidation.

## Composable Architecture Patterns

### Core Principles from Official Docs

**Composable Definition:**
- Functions that encapsulate and reuse stateful logic
- Convention: Names start with "use" prefix
- Called within component setup context or other composables
- Return plain objects containing refs and functions

**Basic Structure:**
```javascript
import { ref, onMounted, onUnmounted } from 'vue'

export function useMouse() {
  // State encapsulated and managed by the composable
  const x = ref(0)
  const y = ref(0)

  // Update managed state over time
  function update(event) {
    x.value = event.pageX
    y.value = event.pageY
  }

  // Hook into owner component's lifecycle
  onMounted(() => window.addEventListener('mousemove', update))
  onUnmounted(() => window.removeEventListener('mousemove', update))

  // Expose managed state as return value
  return { x, y }
}
```

**Usage Pattern:**
```javascript
import { useMouse } from './mouse'
const { x, y } = useMouse()
```

### When to Consolidate vs Split

**Official Guidance - SPLIT when:**
1. **Single Responsibility Violation** - Composable handles unrelated concerns
2. **Reusability Differs** - Parts are used independently in different contexts
3. **Lifecycle Mismatch** - Different parts need different lifecycle hooks
4. **Performance Boundaries** - Parts have different reactivity needs
5. **Testing Isolation** - Parts should be testable independently

**Consolidate when:**
1. **Tightly Coupled Logic** - Features always used together
2. **Shared State** - Multiple functions operate on same reactive data
3. **Sequential Dependencies** - Logic flows through multiple steps
4. **Simplified API** - Single import reduces cognitive load

**Example from Vue Docs - Async Data Fetching:**

❌ **Over-split (too granular):**
```javascript
// Three separate composables for one concern
const data = useData()
const loading = useLoading()
const error = useError()
```

✅ **Appropriate consolidation:**
```javascript
export function useFetch(url) {
  const data = ref(null)
  const error = ref(null)

  fetch(url)
    .then((res) => res.json())
    .then((json) => (data.value = json))
    .catch((err) => (error.value = err))

  return { data, error }
}
```

✅ **Better - with loading state:**
```javascript
export function useAsyncState(promiseFn) {
  const state = ref(null)
  const isLoading = ref(true)
  const error = ref(null)

  onMounted(async () => {
    try {
      state.value = await promiseFn()
    } catch (err) {
      error.value = err
    } finally {
      isLoading.value = false
    }
  })

  return { state, isLoading, error }
}
```

## Large Composable Patterns

### Pattern 1: State Segmentation (VueUse Pattern)

**For composables 500+ lines, organize by concern:**

```javascript
export function useComplexFeature() {
  // ===== STATE SECTION =====
  const data = shallowRef() // Use shallowRef for large data
  const error = shallowRef()
  const isLoading = ref(false)
  const isFinished = ref(false)

  // ===== COMPUTED SECTION =====
  const hasError = computed(() => error.value !== null)
  const isReady = computed(() => isFinished.value && !hasError.value)

  // ===== METHODS SECTION =====
  async function fetch() { /* ... */ }
  function reset() { /* ... */ }

  // ===== LIFECYCLE SECTION =====
  onMounted(() => { /* setup */ })
  onUnmounted(() => { /* cleanup */ })

  // ===== RETURN =====
  return {
    // State
    data,
    error,
    isLoading,
    isFinished,
    // Computed
    hasError,
    isReady,
    // Methods
    fetch,
    reset
  }
}
```

### Pattern 2: Composable Composition (Official Vue Pattern)

**Compose multiple focused composables:**

```javascript
// Options API integration example
import { useMouse } from './mouse.js'
import { useFetch } from './fetch.js'

export default {
  setup() {
    const { x, y } = useMouse()
    const { data, error } = useFetch('...')
    return { x, y, data, error }
  }
}
```

**Composition API:**
```vue
<script setup>
import { useMouse } from './mouse'
import { useFetch } from './fetch'

const { x, y } = useMouse()
const { data, error } = useFetch('/api/data')
</script>
```

### Pattern 3: Return Type Flexibility (VueUse Advanced)

**For complex composables, return both plain object AND extended functionality:**

```typescript
export function useFetch<T>(url: MaybeRefOrGetter<string>): UseFetchReturn<T> & PromiseLike<UseFetchReturn<T>> {
  const data = shallowRef<T | undefined>()
  const error = shallowRef<Error | undefined>()
  const isFinished = ref(false)

  fetch(toValue(url))
    .then(r => r.json())
    .then(r => data.value = r)
    .catch(e => error.value = e)
    .finally(() => isFinished.value = true)

  const state: UseFetchReturn<T> = {
    data,
    error,
    isFinished,
  }

  return {
    ...state,
    // Make awaitable for Vue Suspense
    then(onFulfilled, onRejected) {
      return new Promise<UseFetchReturn<T>>((resolve, reject) => {
        until(isFinished)
          .toBeTruthy()
          .then(() => resolve(state))
          .then(() => reject(state))
      }).then(onFulfilled, onRejected)
    },
  }
}

// Usage with Suspense
const result = await useFetch('/api/data')
```

## State Management within Composables

### Local State (Component-Scoped)

**Default pattern - new state per component:**
```javascript
export function useCounter() {
  // Local state, created per-component
  const localCount = ref(1)

  return {
    localCount,
    increment: () => localCount.value++
  }
}
```

### Shared State (Global Scope)

**Module-level reactive state:**
```javascript
// global state, created in module scope
const globalCount = ref(1)

export function useCount() {
  const increment = () => globalCount.value++

  return {
    count: globalCount, // Shared across all components
    increment
  }
}
```

### Shared State with createSharedComposable (VueUse)

**Best practice for sharing state across components:**
```typescript
import { createSharedComposable, useMouse } from '@vueuse/core'

const useSharedMouse = createSharedComposable(useMouse)

// CompA.vue
const { x, y } = useSharedMouse()

// CompB.vue - reuses previous state, no new event listeners
const { x, y } = useSharedMouse()
```

### State with Provide/Inject Pattern

**For component tree state sharing:**
```vue
<!-- Provider component -->
<script setup>
import { provide, ref, readonly } from 'vue'

const location = ref('North Pole')

function updateLocation() {
  location.value = 'South Pole'
}

// Provide state with mutation function
provide('location', {
  location,
  updateLocation
})

// OR provide read-only state
provide('read-only-count', readonly(count))
</script>
```

```vue
<!-- Consumer component -->
<script setup>
import { inject } from 'vue'

const { location, updateLocation } = inject('location')
</script>
```

### Global State Pattern (VueUse)

**For true global state management:**
```typescript
import { createGlobalState } from '@vueuse/core'
import { ref } from 'vue'

export const useGlobalState = createGlobalState(() => {
  const count = ref(0)
  const increment = () => count.value++

  return { count, increment }
})

// Usage - same instance everywhere
const { count, increment } = useGlobalState()
```

## Performance Considerations

### Pattern 1: Use shallowRef for Large Data (VueUse Guideline)

**Critical for performance with large datasets:**
```typescript
export function useFetch<T>(url: MaybeRefOrGetter<string>) {
  // Use shallowRef to prevent deep reactivity
  const data = shallowRef<T | undefined>()
  const error = shallowRef<Error | undefined>()

  fetch(toValue(url))
    .then(r => r.json())
    .then(r => data.value = r)
    .catch(e => error.value = e)

  return { data, error }
}
```

**Why shallowRef:**
- Prevents deep reactivity tracking on large objects
- Significantly reduces memory overhead
- Improves performance for data-heavy composables
- Use for: API responses, large lists, complex nested objects

### Pattern 2: Computed for Derived State

**Always use computed for derived values:**
```javascript
export function useCounter() {
  const count = ref(0)

  // ✅ Computed - cached, only recalculates when count changes
  const doubleCount = computed(() => count.value * 2)

  // ❌ Function - recalculates every render
  // const doubleCount = () => count.value * 2

  return { count, doubleCount }
}
```

### Pattern 3: Lazy Initialization

**Defer expensive operations:**
```javascript
export function useExpensiveData() {
  const data = ref(null)
  const isInitialized = ref(false)

  function initialize() {
    if (isInitialized.value) return

    // Expensive operation only when needed
    data.value = performExpensiveCalculation()
    isInitialized.value = true
  }

  return { data, initialize }
}
```

### Pattern 4: Event Listener Cleanup

**Always clean up side effects:**
```javascript
export function useMouse() {
  const x = ref(0)
  const y = ref(0)

  function update(event) {
    x.value = event.pageX
    y.value = event.pageY
  }

  // Setup
  onMounted(() => window.addEventListener('mousemove', update))

  // ✅ Critical: Always cleanup
  onUnmounted(() => window.removeEventListener('mousemove', update))

  return { x, y }
}
```

### Pattern 5: SSR-Safe Composables (VueUse Pattern)

**Support server-side rendering:**
```typescript
import type { ConfigurableWindow } from '../_configurable'
import { defaultWindow } from '../_configurable'

export function useActiveElement<T extends HTMLElement>(
  options: ConfigurableWindow = {},
) {
  const {
    // defaultWindow = isClient ? window : undefined
    window = defaultWindow,
  } = options

  let el: T

  // Skip when in Node.js environment (SSR)
  if (window) {
    useEventListener(window, 'blur', () => {
      el = window?.document.activeElement
    }, true)
  }

  return el
}
```

## Decision Framework

### Size-Based Guidelines

**Small Composable (< 100 lines):**
- Single concern, highly focused
- Example: `useMouse`, `useCounter`
- Pattern: Keep as single file

**Medium Composable (100-300 lines):**
- Multiple related functions
- Example: `useFetch`, `useLocalStorage`
- Pattern: Organize by sections (state, computed, methods, lifecycle)

**Large Composable (300-500 lines):**
- Complex feature with multiple sub-concerns
- Example: `useVirtualList`, `useInfiniteScroll`
- Pattern: Consider splitting OR use clear sectioning

**Very Large Composable (500+ lines):**
- Multiple features that could be independent
- Pattern: **SPLIT into multiple composables** with composition

### Split Decision Tree

```
Does the composable handle multiple unrelated concerns?
├─ YES → SPLIT into separate composables
└─ NO → Can parts be used independently?
   ├─ YES → SPLIT for reusability
   └─ NO → Is state tightly coupled?
      ├─ YES → KEEP consolidated
      └─ NO → Consider splitting for testing/maintenance
```

### Composition Strategy

**For related but separable concerns:**

```javascript
// Base composables
export function useAuth() { /* authentication logic */ }
export function useUserData() { /* user data fetching */ }
export function usePermissions() { /* permission checking */ }

// Composed high-level composable
export function useCurrentUser() {
  const { isAuthenticated, userId } = useAuth()
  const { userData, fetchUser } = useUserData()
  const { can } = usePermissions()

  // Orchestration logic
  watchEffect(() => {
    if (isAuthenticated.value && userId.value) {
      fetchUser(userId.value)
    }
  })

  return {
    isAuthenticated,
    userData,
    can
  }
}
```

## Anti-Patterns to Avoid

### ❌ Async Lifecycle Hooks

**NEVER register lifecycle hooks asynchronously:**
```javascript
// ❌ WRONG - won't work
setTimeout(() => {
  onMounted(() => {
    // This won't be associated with the component
  })
}, 100)

// ✅ CORRECT - synchronous registration
onMounted(() => {
  // Can have async operations inside
  setTimeout(() => {
    // This is fine
  }, 100)
})
```

### ❌ Watching Reactive Objects Without deep Option

**Be explicit about deep watching:**
```javascript
const obj = reactive({ count: 0 })

// ⚠️ Implicit deep watch - newValue === oldValue
watch(obj, (newValue, oldValue) => {
  // Both point to same object
})

// ✅ Explicit deep watch on getter
watch(
  () => state.someObject,
  (newValue, oldValue) => {
    // More predictable behavior
  },
  { deep: true }
)
```

### ❌ Not Returning Destructurable Objects

**Always return plain objects for easy destructuring:**
```javascript
// ❌ WRONG - hard to use
export function useMouse() {
  return { position: { x: ref(0), y: ref(0) } }
}

// ✅ CORRECT - easy destructuring
export function useMouse() {
  const x = ref(0)
  const y = ref(0)
  return { x, y }
}
```

## Code Examples from Official Docs

### Example 1: Progressive Enhancement Pattern

**Start simple, add complexity as needed:**

```javascript
// v1 - Basic fetch
export function useFetch(url) {
  const data = ref(null)
  const error = ref(null)

  fetch(url)
    .then((res) => res.json())
    .then((json) => (data.value = json))
    .catch((err) => (error.value = err))

  return { data, error }
}

// v2 - Add reactive URL support
export function useFetch(url) {
  const data = ref(null)
  const error = ref(null)

  watchEffect(() => {
    // Reset state on URL change
    data.value = null
    error.value = null

    fetch(toValue(url))
      .then((res) => res.json())
      .then((json) => (data.value = json))
      .catch((err) => (error.value = err))
  })

  return { data, error }
}

// v3 - Add loading state and refetch
export function useFetch(url) {
  const data = ref(null)
  const error = ref(null)
  const isLoading = ref(false)

  async function doFetch() {
    isLoading.value = true
    data.value = null
    error.value = null

    try {
      const res = await fetch(toValue(url))
      data.value = await res.json()
    } catch (err) {
      error.value = err
    } finally {
      isLoading.value = false
    }
  }

  watchEffect(() => {
    doFetch()
  })

  return { data, error, isLoading, refetch: doFetch }
}
```

### Example 2: Component Integration

**Using multiple composables together:**

```vue
<script setup>
import { watch } from 'vue'
import { useMouse } from './composables/useMouse'
import { useFetch } from './composables/useFetch'

// Mouse tracking
const { x, y } = useMouse()

// Data fetching with watcher
const { data, error, isLoading } = useFetch('/api/data')

watch([x, y], ([newX, newY]) => {
  console.log(`Mouse moved to ${newX}, ${newY}`)
})
</script>

<template>
  <div>
    <p>Mouse: {{ x }}, {{ y }}</p>
    <div v-if="isLoading">Loading...</div>
    <div v-else-if="error">Error: {{ error }}</div>
    <div v-else>{{ data }}</div>
  </div>
</template>
```

### Example 3: VueUse Advanced - Virtual List

**Large composable with clear organization:**

```typescript
import { useVirtualList } from '@vueuse/core'

const allItems = Array.from({ length: 99999 }).keys()

const { list, containerProps, wrapperProps } = useVirtualList(
  allItems,
  {
    // Vertical scrolling
    itemHeight: 22,

    // OR Horizontal scrolling
    itemWidth: 200,

    // Overscan for smoother scrolling
    overscan: 10
  }
)
```

```html
<template>
  <div v-bind="containerProps" style="height: 300px">
    <div v-bind="wrapperProps">
      <div v-for="item in list" :key="item.index">
        Row: {{ item.data }}
      </div>
    </div>
  </div>
</template>
```

## Best Practices Summary

### ✅ DO:
1. **Name composables with "use" prefix** - `useMouse`, `useFetch`
2. **Return plain objects** - Enable easy destructuring
3. **Use shallowRef for large data** - Performance optimization
4. **Clean up side effects** - onUnmounted for event listeners
5. **Make composables SSR-safe** - Check for window/document
6. **Use computed for derived state** - Automatic caching
7. **Compose focused composables** - Better than one monolithic composable
8. **Document complex composables** - Explain state, methods, lifecycle

### ❌ DON'T:
1. **Don't register lifecycle hooks async** - Won't work
2. **Don't return nested reactive objects** - Hard to use
3. **Don't use ref for large objects** - Use shallowRef
4. **Don't forget cleanup** - Memory leaks
5. **Don't consolidate unrelated logic** - Violates single responsibility
6. **Don't access this** - Use Composition API patterns
7. **Don't mutate props** - Use events or provide/inject
8. **Don't skip TypeScript types** - Better DX and safety

## References

**Official Vue Documentation:**
- https://vuejs.org/guide/reusability/composables.html - Complete composables guide
- https://vuejs.org/api/composition-api-lifecycle.html - Lifecycle hooks
- https://vuejs.org/api/composition-api-dependency-injection.html - Provide/Inject
- https://vuejs.org/guide/components/provide-inject.html - Component state sharing

**VueUse Documentation:**
- https://vueuse.org/ - Collection of 200+ composables
- https://github.com/vueuse/vueuse/blob/main/packages/guidelines.md - Official guidelines
- https://vueuse.org/guide/config.html - Configuration patterns

**Key Insights:**
- Vue's philosophy: **Single responsibility + flexible composition > monolithic consolidation**
- VueUse demonstrates: **Large composables are OK if well-organized by concern**
- Official guidance: **Split when reusability differs, consolidate when tightly coupled**
- Performance: **shallowRef for large data, computed for derived state, cleanup for side effects**
- State management: **Local by default, use createSharedComposable or global state when needed**
