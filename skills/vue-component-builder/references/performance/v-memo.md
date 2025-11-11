# v-memo Directive

The `v-memo` directive allows you to skip updates for a sub-tree unless dependencies change, improving performance for expensive renders.

## Basic Usage

```vue
<template>
  <div v-memo="[valueA, valueB]">
    <!-- Expensive content that only re-renders when valueA or valueB changes -->
    <ExpensiveComponent :prop-a="valueA" :prop-b="valueB" />
    <AnotherExpensiveComponent :prop-a="valueA" />
  </div>
</template>
```

## When to Use

**Use `v-memo` when:**
- Rendering large lists with stable data
- Components have expensive computed properties
- Parent re-renders frequently but child props rarely change
- Virtual scrolling scenarios

**Don't use `v-memo` when:**
- Dependencies change frequently (defeats the purpose)
- Component is already fast
- Overhead of memoization exceeds benefit

## List Rendering Pattern

```vue
<script setup lang="ts">
import { ref } from 'vue'

interface Item {
  id: number
  name: string
  description: string
}

const items = ref<Item[]>([])
const searchQuery = ref('')
</script>

<template>
  <div>
    <input v-model="searchQuery" placeholder="Search..." />
    
    <!-- Only re-render when items or searchQuery changes -->
    <div v-for="item in filteredItems" 
         :key="item.id"
         v-memo="[item.id, item.name, searchQuery]">
      <ExpensiveItemCard :item="item" />
    </div>
  </div>
</template>
```

## With Computed Properties

```vue
<script setup lang="ts">
import { computed, ref } from 'vue'

const user = ref({ id: 1, name: 'John', email: 'john@example.com' })
const theme = ref('light')

// Expensive computation
const userDisplay = computed(() => {
  // Heavy processing...
  return processUserData(user.value)
})
</script>

<template>
  <!-- Only re-render when user or theme changes -->
  <div v-memo="[user, theme]">
    <UserProfile :data="userDisplay" :theme="theme" />
  </div>
</template>
```

## Performance Comparison

```vue
<!-- Without v-memo: Re-renders on every parent update -->
<div>
  <ExpensiveComponent :prop="stableValue" />
</div>

<!-- With v-memo: Skips render if stableValue unchanged -->
<div v-memo="[stableValue]">
  <ExpensiveComponent :prop="stableValue" />
</div>
```

## Important Notes

1. **Dependencies must be primitive values** or references to the same object
2. **Empty dependency array** `v-memo="[]"` means never update (use sparingly)
3. **Works with v-for** - memoize each item independently
4. **Not a replacement for proper reactivity** - use for optimization, not fixes

## References

- [Vue 3 Official: v-memo](https://vuejs.org/api/built-in-directives.html#v-memo)

