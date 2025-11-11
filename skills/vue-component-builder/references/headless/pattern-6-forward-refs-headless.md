# Pattern 6: Forward Refs Pattern

Expose DOM element from non-single-root components:

```vue
<script setup lang="ts">
import { ref, onMounted } from 'vue'

const forwardRef = ref<HTMLElement | null>(null)

// Expose ref for parent access
defineExpose({
  element: forwardRef
})

onMounted(() => {
  // Can focus, measure, position relative to this element
  forwardRef.value?.focus()
})
</script>

<template>
  <span>
    <!-- Expose div as the template ref -->
    <div :ref="forwardRef">
      <slot />
    </div>
  </span>
</template>
```
