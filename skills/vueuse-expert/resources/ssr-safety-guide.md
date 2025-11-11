# SSR Safety Guide

### Pattern 1: useMounted (Most Critical)

**Problem:** Browser APIs crash during SSR (window, document, navigator, localStorage, etc.)

**Solution:** Wrap with `useMounted()`

```typescript
import { useMounted } from '@vueuse/core'
import { ref, watch } from 'vue'

const mounted = useMounted()
const theme = ref('light')

// Safe: Only runs after client mount
watch(mounted, (isMounted) => {
  if (isMounted) {
    theme.value = localStorage.getItem('theme') ?? 'light'
  }
})
```

**Template Usage:**
```vue
<template>
  <!-- Render after mount -->
  <Icon v-if="mounted" icon="mdi:home" />

  <!-- Conditional entire sections -->
  <template v-if="mounted">
    <ClientOnlyFeatures />
  </template>
</template>
```

---

### Pattern 2: useSupported (Feature Detection)

**Problem:** Need to check if browser feature exists

**Solution:** Use `useSupported()` - returns false on server

```typescript
import { useSupported } from '@vueuse/core'

const isGeolocationSupported = useSupported(() =>
  'geolocation' in navigator
)

const isWebGLSupported = useSupported(() =>
  'WebGLRenderingContext' in window
)

const isClipboardSupported = useSupported(() =>
  navigator && 'clipboard' in navigator
)
```

**Benefits:**
- Returns false on server (SSR-safe)
- Returns true/false on client (actual feature detection)
- No crashes during SSR

---

### Pattern 3: SSR Width for Media Queries

**Problem:** Media queries need viewport width during SSR

**Solution:** Use `provideSSRWidth()` + `useMediaQuery()`

```typescript
// In root component or app setup
import { provideSSRWidth } from '@vueuse/core'

provideSSRWidth(768) // Assume 768px viewport on server

// In components
import { useMediaQuery } from '@vueuse/core'

const isLarge = useMediaQuery('(min-width: 1024px)')
// Server assumes 768px, so isLarge = false
// Client uses actual viewport width
```

**Alternative:** Use `ssrWidth` option directly

```typescript
const isLarge = useMediaQuery('(min-width: 1024px)', {
  ssrWidth: 768
})
```

---

### Pattern 4: Manual SSR Check

**When:** Need fine-grained control

```typescript
import { ref, onMounted } from 'vue'

const data = ref<string | null>(null)

// Check if SSR environment
if (!import.meta.env.SSR) {
  // Only runs on client
  data.value = localStorage.getItem('key')
}

// Or use onMounted (always client-side)
onMounted(() => {
  data.value = localStorage.getItem('key')
})
```

---

### SSR Safety Checklist

**Before using ANY VueUse composable:**

- [ ] Does it access `window`? → ⚠️ Needs useMounted
- [ ] Does it access `document`? → ⚠️ Needs useMounted
- [ ] Does it access `navigator`? → ⚠️ Use useSupported
- [ ] Does it use `localStorage`/`sessionStorage`? → ⚠️ Needs useMounted
- [ ] Does it use event listeners? → ⚠️ Needs useMounted
- [ ] Does it use Intersection/Resize/Mutation Observer? → ⚠️ Needs useMounted
- [ ] Is it pure reactive (computed, watch, ref)? → ✅ SSR-safe

**When in doubt:** Wrap with `useMounted()` - it's always safe!
