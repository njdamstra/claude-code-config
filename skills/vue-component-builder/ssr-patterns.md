# SSR Safety Patterns

## Core Rule
Never access browser APIs (window, document, localStorage) during SSR.

## Use useMounted()

```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core'
import { ref, watch } from 'vue'

const mounted = useMounted()
const data = ref(null)

watch(mounted, (isMounted) => {
  if (isMounted) {
    // Safe to access browser APIs
    data.value = localStorage.getItem('key')
  }
})
</script>

<template>
  <div v-if="mounted">
    <!-- Rendered only on client -->
  </div>
</template>
```

## Astro Client Directives

- `client:load` - Hydrate immediately
- `client:visible` - Hydrate when visible
- `client:idle` - Hydrate when browser idle
- `client:only="vue"` - Skip SSR entirely
