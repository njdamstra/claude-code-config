# Pattern 3: Generic Component with Ref Forwarding

For components that need to expose DOM element:

```vue
<script setup lang="ts" generic="T extends HTMLElement">
import { ref, onMounted } from 'vue'

interface Props {
  as?: string
}

const props = withDefaults(defineProps<Props>(), {
  as: 'div'
})

const elementRef = ref<T | null>(null)

// T extends HTMLElement, so .focus() is safe
onMounted(() => {
  elementRef.value?.focus()
})

// Expose ref for parent access
defineExpose({
  element: elementRef
})
</script>

<template>
  <component :is="as" ref="elementRef">
    <slot />
  </component>
</template>
```

**Usage:**

```vue
<script setup lang="ts">
const buttonRef = ref<{ element: HTMLButtonElement | null } | null>(null)

onMounted(() => {
  buttonRef.value?.element?.click() // ✅ Type-safe
})
</script>

<template>
  <GenericButton ref="buttonRef" as="button">
    Click Me
  </GenericButton>
</template>
```
