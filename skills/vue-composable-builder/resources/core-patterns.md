# Core Patterns

### Pattern 1: Basic Composable (Stateless Logic)

**Use case:** Extract reusable calculations or transformations

```typescript
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

  return { formatCurrency, formatDate }
}
```

### Pattern 2: Async Data Fetching

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

  return { data, loading, error, execute, refetch: execute }
}
```

### Pattern 3: Event Listener Management

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

### Pattern 4: Interval/Timer Management

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
```

### Pattern 5: Watchers with Cleanup

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
