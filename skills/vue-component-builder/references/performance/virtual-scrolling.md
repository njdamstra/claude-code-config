# Virtual Scrolling

Virtual scrolling renders only visible items, dramatically improving performance for large lists.

## When to Use Virtual Scrolling

- Lists with **1000+ items**
- Items have **variable heights**
- Performance issues with large datasets
- Mobile devices with limited memory

## Basic Implementation

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'

interface Item {
  id: number
  name: string
}

const items = ref<Item[]>([]) // Large array
const containerHeight = ref(600)
const itemHeight = 50
const scrollTop = ref(0)

const visibleItems = computed(() => {
  const start = Math.floor(scrollTop.value / itemHeight)
  const end = start + Math.ceil(containerHeight.value / itemHeight)
  return items.value.slice(start, end)
})

const totalHeight = computed(() => items.value.length * itemHeight)
const offsetY = computed(() => Math.floor(scrollTop.value / itemHeight) * itemHeight)
</script>

<template>
  <div 
    class="overflow-auto"
    :style="{ height: `${containerHeight}px` }"
    @scroll="scrollTop = $event.target.scrollTop"
  >
    <div :style="{ height: `${totalHeight}px`, position: 'relative' }">
      <div :style="{ transform: `translateY(${offsetY}px)` }">
        <div 
          v-for="item in visibleItems" 
          :key="item.id"
          :style="{ height: `${itemHeight}px` }"
        >
          {{ item.name }}
        </div>
      </div>
    </div>
  </div>
</template>
```

## Using vue-virtual-scroller

```bash
npm install vue-virtual-scroller
```

```vue
<script setup lang="ts">
import { RecycleScroller } from 'vue-virtual-scroller'
import 'vue-virtual-scroller/dist/vue-virtual-scroller.css'

interface Item {
  id: number
  name: string
}

const items = ref<Item[]>([])
</script>

<template>
  <RecycleScroller
    class="scroller"
    :items="items"
    :item-size="50"
    key-field="id"
    v-slot="{ item }"
  >
    <div class="item">
      {{ item.name }}
    </div>
  </RecycleScroller>
</template>

<style scoped>
.scroller {
  height: 600px;
}
</style>
```

## Variable Height Items

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'

interface Item {
  id: number
  name: string
  height: number // Variable height
}

const items = ref<Item[]>([])
const scrollTop = ref(0)
const containerHeight = 600

// Calculate cumulative heights
const cumulativeHeights = computed(() => {
  let sum = 0
  return items.value.map(item => {
    sum += item.height
    return sum
  })
})

const visibleRange = computed(() => {
  // Find start index
  let start = 0
  for (let i = 0; i < cumulativeHeights.value.length; i++) {
    if (cumulativeHeights.value[i] > scrollTop.value) {
      start = i
      break
    }
  }
  
  // Find end index
  const endScroll = scrollTop.value + containerHeight
  let end = items.value.length
  for (let i = start; i < cumulativeHeights.value.length; i++) {
    if (cumulativeHeights.value[i] > endScroll) {
      end = i + 1
      break
    }
  }
  
  return { start, end }
})

const visibleItems = computed(() => 
  items.value.slice(visibleRange.value.start, visibleRange.value.end)
)
</script>
```

## Performance Tips

1. **Use fixed heights** when possible (faster calculation)
2. **Debounce scroll events** for smoother performance
3. **Use `v-memo`** on item components
4. **Implement item pooling** for very large lists
5. **Measure actual item heights** for variable height lists

## References

- [vue-virtual-scroller](https://github.com/Akryum/vue-virtual-scroller)
- [Vue 3 Performance: Virtual Scrolling](https://vuejs.org/guide/best-practices/performance.html#virtual-scrolling)

