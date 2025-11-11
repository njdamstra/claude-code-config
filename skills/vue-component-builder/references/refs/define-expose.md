# defineExpose

`defineExpose` allows a child component to expose specific properties/methods to parent components via template refs.

## Basic Usage

```vue
<!-- ChildComponent.vue -->
<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)
const inputRef = ref<HTMLInputElement>()

function increment() {
  count.value++
}

function focusInput() {
  inputRef.value?.focus()
}

// Expose to parent
defineExpose({
  count,
  increment,
  focusInput
})
</script>

<template>
  <div>
    <p>Count: {{ count }}</p>
    <input ref="inputRef" />
  </div>
</template>
```

```vue
<!-- ParentComponent.vue -->
<script setup lang="ts">
import { ref, onMounted } from 'vue'
import ChildComponent from './ChildComponent.vue'

const childRef = ref<InstanceType<typeof ChildComponent> | null>(null)

onMounted(() => {
  // Access exposed properties/methods
  childRef.value?.increment()
  childRef.value?.focusInput()
  console.log(childRef.value?.count) // 1
})
</script>

<template>
  <ChildComponent ref="childRef" />
</template>
```

## Typed Template Refs

```vue
<!-- ChildComponent.vue -->
<script setup lang="ts">
import { ref } from 'vue'

interface Exposed {
  count: Ref<number>
  increment: () => void
  reset: () => void
}

const count = ref(0)

function increment() {
  count.value++
}

function reset() {
  count.value = 0
}

defineExpose<Exposed>({
  count,
  increment,
  reset
})
</script>
```

```vue
<!-- ParentComponent.vue -->
<script setup lang="ts">
import { ref } from 'vue'
import type ChildComponent from './ChildComponent.vue'

// Type the ref based on exposed interface
const childRef = ref<{
  count: Ref<number>
  increment: () => void
  reset: () => void
} | null>(null)

// Now TypeScript knows the API
childRef.value?.increment()
</script>
```

## Exposing DOM Elements

```vue
<!-- FormInput.vue -->
<script setup lang="ts">
import { ref } from 'vue'

const inputRef = ref<HTMLInputElement>()

function focus() {
  inputRef.value?.focus()
}

function blur() {
  inputRef.value?.blur()
}

function getValue() {
  return inputRef.value?.value
}

defineExpose({
  focus,
  blur,
  getValue,
  // Expose the DOM element itself
  element: inputRef
})
</script>

<template>
  <input ref="inputRef" />
</template>
```

## Exposing Computed Properties

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'

const items = ref<string[]>([])

const isEmpty = computed(() => items.value.length === 0)
const count = computed(() => items.value.length)

function addItem(item: string) {
  items.value.push(item)
}

defineExpose({
  isEmpty,
  count,
  addItem
})
</script>
```

## Conditional Exposure

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'

const props = defineProps<{
  exposeMethods?: boolean
}>()

const internalState = ref(0)

const exposed = computed(() => {
  if (props.exposeMethods) {
    return {
      getState: () => internalState.value,
      setState: (val: number) => { internalState.value = val }
    }
  }
  return {}
})

defineExpose(exposed.value)
</script>
```

## Best Practices

1. **Only expose what's necessary** - Don't expose internal implementation details
2. **Use TypeScript interfaces** - Define clear contracts for exposed API
3. **Document exposed API** - Add JSDoc comments for exposed methods
4. **Avoid exposing reactive refs directly** - Expose methods instead when possible

## References

- [Vue 3 Official: defineExpose](https://vuejs.org/api/sfc-script-setup.html#defineexpose)

