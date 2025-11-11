# Lazy Loading & Code Splitting

## defineAsyncComponent

Use `defineAsyncComponent` to lazy-load components, reducing initial bundle size.

### Basic Pattern

```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

// Simple lazy loading
const HeavyComponent = defineAsyncComponent(() => 
  import('./HeavyComponent.vue')
)

// With loading component
const AsyncModal = defineAsyncComponent({
  loader: () => import('./Modal.vue'),
  loadingComponent: LoadingSpinner,
  errorComponent: ErrorDisplay,
  delay: 200, // Delay before showing loading component
  timeout: 3000 // Timeout for error display
})
</script>

<template>
  <HeavyComponent v-if="showHeavy" />
</template>
```

### With Suspense

```vue
<script setup lang="ts">
import { defineAsyncComponent } from 'vue'

const AsyncChart = defineAsyncComponent(() => 
  import('./ChartComponent.vue')
)
</script>

<template>
  <Suspense>
    <template #default>
      <AsyncChart :data="chartData" />
    </template>
    <template #fallback>
      <div class="animate-pulse">Loading chart...</div>
    </template>
  </Suspense>
</template>
```

### Conditional Loading

```vue
<script setup lang="ts">
import { defineAsyncComponent, ref } from 'vue'

const showEditor = ref(false)

// Only load when needed
const CodeEditor = defineAsyncComponent(() => {
  if (showEditor.value) {
    return import('./CodeEditor.vue')
  }
  return Promise.resolve(null)
})
</script>
```

### Route-Based Code Splitting

```typescript
// router.ts
import { defineAsyncComponent } from 'vue'

const routes = [
  {
    path: '/dashboard',
    component: defineAsyncComponent(() => 
      import('./pages/Dashboard.vue')
    )
  },
  {
    path: '/admin',
    component: defineAsyncComponent(() => 
      import('./pages/Admin.vue')
    )
  }
]
```

## Performance Benefits

- **Reduced Initial Bundle**: Components load only when needed
- **Faster Time to Interactive**: Less JavaScript to parse initially
- **Better Code Splitting**: Webpack/Vite automatically creates separate chunks

## Best Practices

1. **Lazy load heavy components** (charts, editors, large forms)
2. **Use Suspense** for better UX during loading
3. **Provide loading states** to avoid layout shift
4. **Set reasonable timeouts** for error handling
5. **Preload critical components** using `<link rel="modulepreload">`

## References

- [Vue 3 Official: Async Components](https://vuejs.org/guide/components/async.html)
- [Vite Code Splitting](https://vitejs.dev/guide/features.html#async-chunk-loading-optimization)

