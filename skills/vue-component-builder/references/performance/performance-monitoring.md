# Performance Monitoring

Monitor and optimize component performance in production.

## Performance API

```vue
<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'

onMounted(() => {
  // Measure component render time
  performance.mark('component-start')
  
  // Component renders...
  
  performance.mark('component-end')
  performance.measure('component-render', 'component-start', 'component-end')
  
  const measure = performance.getEntriesByName('component-render')[0]
  console.log(`Render time: ${measure.duration}ms`)
})
</script>
```

## Component Render Tracking

```vue
<script setup lang="ts">
import { onMounted, watch } from 'vue'

const renderCount = ref(0)

onMounted(() => {
  renderCount.value++
  
  if (import.meta.env.DEV) {
    console.log(`Component rendered ${renderCount.value} times`)
  }
})

// Track prop changes
watch(() => props.data, () => {
  renderCount.value++
}, { deep: true })
</script>
```

## Memory Leak Detection

```vue
<script setup lang="ts">
import { onUnmounted } from 'vue'

const timers: number[] = []
const listeners: Array<() => void> = []

onMounted(() => {
  // Track timers
  const timer = setInterval(() => {}, 1000)
  timers.push(timer)
  
  // Track event listeners
  const handler = () => {}
  window.addEventListener('resize', handler)
  listeners.push(() => window.removeEventListener('resize', handler))
})

onUnmounted(() => {
  // Cleanup
  timers.forEach(timer => clearInterval(timer))
  listeners.forEach(cleanup => cleanup())
})
</script>
```

## Bundle Size Monitoring

```typescript
// vite.config.ts
import { visualizer } from 'rollup-plugin-visualizer'

export default {
  plugins: [
    visualizer({
      open: true,
      gzipSize: true,
      brotliSize: true
    })
  ]
}
```

## Runtime Performance

```vue
<script setup lang="ts">
import { ref, watch } from 'vue'

const expensiveValue = ref(0)

// Measure expensive computation
watch(expensiveValue, () => {
  const start = performance.now()
  
  // Expensive operation
  const result = heavyComputation(expensiveValue.value)
  
  const duration = performance.now() - start
  if (duration > 16) { // > 1 frame at 60fps
    console.warn(`Slow computation: ${duration}ms`)
  }
})
</script>
```

## Production Monitoring

```typescript
// utils/performance.ts
export function trackPerformance(name: string, fn: () => void) {
  if (import.meta.env.PROD) {
    const start = performance.now()
    fn()
    const duration = performance.now() - start
    
    // Send to analytics
    if (window.gtag) {
      window.gtag('event', 'performance', {
        name,
        duration,
        value: Math.round(duration)
      })
    }
  } else {
    fn()
  }
}
```

## References

- [Web Performance API](https://developer.mozilla.org/en-US/docs/Web/API/Performance_API)
- [Vue 3 Performance Guide](https://vuejs.org/guide/best-practices/performance.html)

