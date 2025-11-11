# Common Anti-Patterns

### ❌ Anti-Pattern 1: Mutating Props Directly

**Problem:**
```vue
<script setup>
const props = defineProps(['count'])
props.count++ // ❌ ERROR: Attempting to mutate prop
</script>
```

**Solution:**
```vue
<script setup>
const props = defineProps(['count'])
const emit = defineEmits(['update:count'])

function increment() {
  emit('update:count', props.count + 1)
}
</script>
```

**Or use v-model:**
```vue
<script setup>
const count = defineModel<number>()

function increment() {
  count.value++ // ✅ Works
}
</script>
```

### ❌ Anti-Pattern 2: Expecting Composables to Share State

**Problem:**
```typescript
// Composable
export function useCounter() {
  const count = ref(0) // New instance per call
  return { count }
}

// Component A
const counterA = useCounter() // count = 0

// Component B
const counterB = useCounter() // NEW count = 0 (not shared!)
```

**Solution:** Use Nanostore for shared state:
```typescript
import { atom } from 'nanostores'

export const $count = atom(0) // Singleton

// Both components share same count
import { useStore } from '@nanostores/vue'
const count = useStore($count)
```

### ❌ Anti-Pattern 3: Over-Using Stores

**Problem:** Every piece of state becomes an atom.

**Solution:** Follow the hierarchy. Start local, lift when needed.

**Example:**
```typescript
// ❌ BAD: Modal state in store
export const $isModalOpen = atom(false)

// ✅ GOOD: Local component state
const isModalOpen = ref(false)
```

### ❌ Anti-Pattern 4: Destructuring Reactive State

**Problem:**
```vue
<script setup>
const { count } = defineProps(['count'])
// Lost reactivity - count is now static value
</script>
```

**Solution:**
```vue
<script setup>
const props = defineProps(['count'])
// Use props.count to maintain reactivity
</script>
```

### ❌ Anti-Pattern 5: Non-Reactive Provide

**Problem:**
```typescript
provide('count', 0) // ❌ Not reactive
```

**Solution:**
```typescript
provide('count', ref(0)) // ✅ Reactive
```
