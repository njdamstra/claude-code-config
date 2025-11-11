# Pattern 1: Generic Components with `generic` Attribute

### Basic Generic Component

**Requires Vue 3.3+**

```vue
<script setup lang="ts" generic="T">
defineProps<{
  items: T[]
  selected: T
}>()

defineEmits<{
  (e: 'select', item: T): void
}>()
</script>

<template>
  <div v-for="item in items" :key="item">
    <button @click="$emit('select', item)">Select</button>
  </div>
</template>
```

**Usage:**

```vue
<script setup lang="ts">
interface User {
  id: number
  name: string
}

const users: User[] = [/* ... */]
const selectedUser: User | null = null

// TypeScript knows item is User
function handleSelect(item: User) {
  console.log(item.name) // ✅ Type-safe
}
</script>

<template>
  <GenericList
    :items="users"
    :selected="selectedUser"
    @select="handleSelect"
  />
</template>
```

### Generic with Constraints

```vue
<script setup lang="ts" generic="T extends { id: string | number }">
defineProps<{
  items: T[]
}>()

// TypeScript knows T has id property
const itemIds = computed(() => items.map(item => item.id))
</script>
```

### Multiple Generic Parameters

```vue
<script setup lang="ts" generic="T extends string | number, U extends Item">
import type { Item } from './types'

defineProps<{
  id: T
  list: U[]
}>()
</script>
```

### Why Generics Are Better Than Unions

```typescript
// ❌ WRONG: Union-typed emits
defineEmits<{
  (e: 'button-click', data: A | B): void
}>()

// Handler must accept union (even if specific instance only emits A)
function handleClick(payload: A | B) {
  // Must narrow type manually
  if ('propFromA' in payload) {
    // Now TypeScript knows it's A
  }
}
```

```vue
<!-- ✅ CORRECT: Generic component -->
<script setup lang="ts" generic="T">
defineProps<{ data: T }>()
defineEmits<{
  (e: 'button-click', data: T): void
}>()
</script>

<!-- Usage - NO TYPE NARROWING NEEDED -->
<script setup>
const a: A = { /* ... */ }

// TypeScript knows payload is A (not A | B)
function handleClick(payload: A) {
  console.log(payload.propFromA) // ✅ Direct access
}
</script>

<template>
  <GenericComponent :data="a" @button-click="handleClick" />
</template>
```
