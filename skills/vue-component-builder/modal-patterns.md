# Modal Patterns

## Essential Features
- Teleport to body
- Click outside to close
- Escape key to close
- Focus trap
- ARIA attributes

## Pattern

```vue
<script setup lang="ts">
import { onClickOutside, onKeyStroke } from '@vueuse/core'
import { ref } from 'vue'

const props = defineProps<{ modelValue: boolean }>()
const emit = defineEmits<{ 'update:modelValue': [boolean] }>()

const modalRef = ref<HTMLElement>()

onClickOutside(modalRef, () => emit('update:modelValue', false))
onKeyStroke('Escape', () => emit('update:modelValue', false))
</script>

<template>
  <Teleport to="#teleport-layer">
    <div v-if="modelValue" role="dialog" aria-modal="true">
      <div ref="modalRef">
        <slot />
      </div>
    </div>
  </Teleport>
</template>
```
