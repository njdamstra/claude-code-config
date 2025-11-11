# Code Splitting Strategies

Code splitting reduces initial bundle size by loading code only when needed.

## Route-Based Splitting

```typescript
// router.ts
import { defineAsyncComponent } from 'vue'

const routes = [
  {
    path: '/',
    component: () => import('./pages/Home.vue') // Auto-split
  },
  {
    path: '/dashboard',
    component: defineAsyncComponent(() => 
      import('./pages/Dashboard.vue')
    )
  }
]
```

## Component-Based Splitting

```vue
<script setup lang="ts">
import { defineAsyncComponent, ref } from 'vue'

// Split heavy components
const Chart = defineAsyncComponent(() => import('./Chart.vue'))
const Editor = defineAsyncComponent(() => import('./Editor.vue'))

const showChart = ref(false)
const showEditor = ref(false)
</script>

<template>
  <Chart v-if="showChart" />
  <Editor v-if="showEditor" />
</template>
```

## Feature-Based Splitting

```typescript
// features/admin/index.ts
export const AdminDashboard = defineAsyncComponent(() => 
  import('./AdminDashboard.vue')
)

export const AdminUsers = defineAsyncComponent(() => 
  import('./AdminUsers.vue')
)

// Only load admin features when needed
```

## Dynamic Imports with Conditions

```vue
<script setup lang="ts">
import { defineAsyncComponent, computed } from 'vue'

const userRole = ref('user')

const AdminPanel = computed(() => {
  if (userRole.value === 'admin') {
    return defineAsyncComponent(() => import('./AdminPanel.vue'))
  }
  return null
})
</script>
```

## Preloading Critical Components

```vue
<script setup lang="ts">
import { onMounted } from 'vue'

onMounted(() => {
  // Preload component before user needs it
  import('./HeavyComponent.vue')
})
</script>
```

## Vite Configuration

```typescript
// vite.config.ts
export default {
  build: {
    rollupOptions: {
      output: {
        manualChunks: {
          'vendor': ['vue', 'vue-router'],
          'charts': ['echarts', 'vue-echarts'],
          'editor': ['monaco-editor']
        }
      }
    }
  }
}
```

## Webpack Configuration

```javascript
// webpack.config.js
module.exports = {
  optimization: {
    splitChunks: {
      chunks: 'all',
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all'
        }
      }
    }
  }
}
```

## Best Practices

1. **Split by route** - Natural boundaries
2. **Split heavy libraries** - Charts, editors, etc.
3. **Use dynamic imports** - Load on demand
4. **Preload critical paths** - Improve perceived performance
5. **Monitor bundle sizes** - Use `vite-bundle-visualizer`

## References

- [Vite: Code Splitting](https://vitejs.dev/guide/features.html#async-chunk-loading-optimization)
- [Webpack: Code Splitting](https://webpack.js.org/guides/code-splitting/)

