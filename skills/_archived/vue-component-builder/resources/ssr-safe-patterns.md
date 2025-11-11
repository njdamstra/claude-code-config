# SSR-Safe Patterns

## Core Rule
Never access browser APIs (window, document, localStorage) during SSR.

**Pattern 1: useMounted for Conditional Rendering**
```vue
<script setup lang="ts">
import { useMounted } from '@vueuse/core'
import { ref, watch } from 'vue'

const mounted = useMounted()
const theme = ref('light')

// CORRECT: Access browser APIs after mount
watch(mounted, (isMounted) => {
  if (isMounted) {
    // Safe to access localStorage
    theme.value = localStorage.getItem('theme') ?? 'light'
  }
})

// INCORRECT: ❌ Direct access
// const theme = localStorage.getItem('theme') // Crashes on SSR
</script>

<template>
  <!-- Pattern A: Conditional content -->
  <div v-if="mounted">
    <Icon icon="mdi:home" /> <!-- Safe: Icon only renders client-side -->
  </div>

  <!-- Pattern B: Wrap entire component -->
  <template v-if="mounted">
    <!-- All client-only content -->
  </template>
</template>
```

**Pattern 2: useSupported for Feature Detection**
```vue
<script setup lang="ts">
import { useSupported } from '@vueuse/core'

// Returns false on server, true/false on client
const isGeolocationSupported = useSupported(() => 'geolocation' in navigator)
const isWebGLSupported = useSupported(() => 'WebGLRenderingContext' in window)
</script>

<template>
  <div v-if="isGeolocationSupported">
    <!-- Show map component -->
  </div>
  <div v-else>
    Geolocation not supported
  </div>
</template>
```

**Pattern 3: SSR-Safe Initialization**
```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'

const data = ref<string | null>(null)

// CORRECT: Initialize in onMounted
onMounted(() => {
  data.value = localStorage.getItem('key')
})

// INCORRECT: ❌ Direct initialization
// const data = ref(localStorage.getItem('key')) // Crashes on SSR
</script>
```

## Astro Client Directives

- `client:load` - Hydrate immediately
- `client:visible` - Hydrate when visible
- `client:idle` - Hydrate when browser idle
- `client:only="vue"` - Skip SSR entirely