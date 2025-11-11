# Error Boundaries

Catch and handle errors from child components using `onErrorCaptured`.

## Basic Error Boundary

```vue
<!-- ErrorBoundary.vue -->
<script setup lang="ts">
import { ref, onErrorCaptured, h } from 'vue'

const hasError = ref(false)
const error = ref<Error | null>(null)

onErrorCaptured((err, instance, info) => {
  hasError.value = true
  error.value = err
  
  console.error('Error caught:', err)
  console.error('Component:', instance)
  console.error('Info:', info)
  
  // Return false to prevent error from propagating
  return false
})

function reset() {
  hasError.value = false
  error.value = null
}
</script>

<template>
  <div v-if="hasError" class="error-boundary">
    <h2>Something went wrong</h2>
    <p>{{ error?.message }}</p>
    <button @click="reset">Try Again</button>
  </div>
  <slot v-else />
</template>
```

## Error Boundary with Fallback Slot

```vue
<!-- ErrorBoundary.vue -->
<script setup lang="ts">
import { ref, onErrorCaptured } from 'vue'

const hasError = ref(false)
const error = ref<Error | null>(null)

onErrorCaptured((err) => {
  hasError.value = true
  error.value = err
  return false
})

function reset() {
  hasError.value = false
  error.value = null
}

defineSlots<{
  default(): any
  fallback(props: { error: Error | null; reset: () => void }): any
}>()
</script>

<template>
  <slot v-if="!hasError" />
  <slot v-else name="fallback" :error="error" :reset="reset" />
</template>
```

```vue
<!-- Usage -->
<template>
  <ErrorBoundary>
    <UnstableComponent />
    
    <template #fallback="{ error, reset }">
      <div class="error">
        <p>Error: {{ error?.message }}</p>
        <button @click="reset">Retry</button>
      </div>
    </template>
  </ErrorBoundary>
</template>
```

## Global Error Handler

```typescript
// main.ts or appEntrypoint
import { createApp } from 'vue'

const app = createApp(App)

app.config.errorHandler = (err, instance, info) => {
  console.error('Global error:', err)
  console.error('Component:', instance)
  console.error('Info:', info)
  
  // Send to error tracking service
  if (window.Sentry) {
    window.Sentry.captureException(err)
  }
}

app.mount('#app')
```

## Async Component Error Handling

```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const AsyncComponent = defineAsyncComponent({
  loader: () => import('./HeavyComponent.vue'),
  errorComponent: ErrorDisplay,
  loadingComponent: LoadingSpinner,
  onError(error, retry, fail, attempts) {
    if (attempts <= 3) {
      retry()
    } else {
      fail()
    }
  }
})
</script>
```

## References

- [Vue 3 Official: Error Handling](https://vuejs.org/api/composition-api-lifecycle.html#onerrorcaptured)

