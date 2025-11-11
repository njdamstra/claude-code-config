# SSR Safety

### Pattern 1: ConfigurableWindow (VueUse Pattern)

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

### Pattern 2: useMounted Guard

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
