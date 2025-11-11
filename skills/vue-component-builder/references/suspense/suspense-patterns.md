# Suspense Patterns

The `<Suspense>` component manages asynchronous dependencies in your component tree.

## Basic Suspense

```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const AsyncComponent = defineAsyncComponent(() => 
  import('./HeavyComponent.vue')
)
</script>

<template>
  <Suspense>
    <template #default>
      <AsyncComponent />
    </template>
    <template #fallback>
      <div class="loading">Loading...</div>
    </template>
  </Suspense>
</template>
```

## Suspense with Async Setup

```vue
<!-- AsyncDataComponent.vue -->
<script setup lang="ts">
import { ref } from 'vue'

// Component waits for this promise
const data = await fetch('/api/data').then(r => r.json())
const processedData = ref(data)
</script>

<template>
  <div>{{ processedData }}</div>
</template>
```

```vue
<!-- ParentComponent.vue -->
<template>
  <Suspense>
    <template #default>
      <AsyncDataComponent />
    </template>
    <template #fallback>
      <LoadingSpinner />
    </template>
  </Suspense>
</template>
```

## Nested Suspense

```vue
<template>
  <Suspense>
    <template #default>
      <ParentComponent>
        <Suspense>
          <template #default>
            <ChildComponent />
          </template>
          <template #fallback>
            <ChildLoadingSpinner />
          </template>
        </Suspense>
      </ParentComponent>
    </template>
    <template #fallback>
      <ParentLoadingSpinner />
    </template>
  </Suspense>
</template>
```

## Suspense with Error Handling

```vue
<script setup lang="ts">
import { onErrorCaptured, ref } from 'vue'

const error = ref<Error | null>(null)

onErrorCaptured((err) => {
  error.value = err
  return false // Prevent propagation
})
</script>

<template>
  <div v-if="error">
    <p>Error: {{ error.message }}</p>
    <button @click="error = null">Retry</button>
  </div>
  
  <Suspense v-else>
    <template #default>
      <AsyncComponent />
    </template>
    <template #fallback>
      <LoadingSpinner />
    </template>
  </Suspense>
</template>
```

## Suspense with Multiple Async Components

```vue
<template>
  <Suspense>
    <template #default>
      <div>
        <AsyncComponentA />
        <AsyncComponentB />
        <AsyncComponentC />
      </div>
    </template>
    <template #fallback>
      <LoadingSpinner />
    </template>
  </Suspense>
</template>
```

## References

- [Vue 3 Official: Suspense](https://vuejs.org/guide/built-ins/suspense.html)

