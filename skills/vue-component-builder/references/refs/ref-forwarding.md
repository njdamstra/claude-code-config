# Ref Forwarding Patterns

Forward template refs from parent to child DOM elements.

## Basic Forwarding

```vue
<!-- WrapperComponent.vue -->
<script setup lang="ts">
import { ref } from 'vue'

const inputRef = ref<HTMLInputElement>()

defineExpose({
  focus: () => inputRef.value?.focus(),
  element: inputRef
})
</script>

<template>
  <div class="wrapper">
    <input ref="inputRef" />
  </div>
</template>
```

## Forwarding Through Slots

```vue
<!-- FormField.vue -->
<script setup lang="ts">
import { ref, useSlots } from 'vue'

const fieldRef = ref<HTMLElement>()

defineExpose({
  focus: () => {
    const input = fieldRef.value?.querySelector('input, textarea, select')
    if (input instanceof HTMLElement) {
      input.focus()
    }
  }
})
</script>

<template>
  <div ref="fieldRef" class="field">
    <slot />
  </div>
</template>
```

## Multiple Ref Forwarding

```vue
<script setup lang="ts">
import { ref } from 'vue'

const inputRef = ref<HTMLInputElement>()
const textareaRef = ref<HTMLTextAreaElement>()

defineExpose({
  focusInput: () => inputRef.value?.focus(),
  focusTextarea: () => textareaRef.value?.focus(),
  inputs: {
    input: inputRef,
    textarea: textareaRef
  }
})
</script>

<template>
  <div>
    <input ref="inputRef" />
    <textarea ref="textareaRef" />
  </div>
</template>
```

## References

- [Vue 3 Official: Template Refs](https://vuejs.org/guide/essentials/template-refs.html)

