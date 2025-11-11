# Modal Pattern

## Essential Features
- Teleport to body
- Click outside to close
- Escape key to close
- Focus trap
- ARIA attributes

```vue
<script setup lang="ts">
import { onClickOutside, onKeyStroke } from '@vueuse/core'
import { ref } from 'vue'

const props = defineProps<{
  modelValue: boolean
  title?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: boolean]
}>()

const modalRef = ref<HTMLElement>()

// Close on click outside
onClickOutside(modalRef, () => {
  emit('update:modelValue', false)
})

// Close on escape key
onKeyStroke('Escape', () => {
  emit('update:modelValue', false)
})

function close() {
  emit('update:modelValue', false)
}
</script>

<template>
  <Teleport to="#teleport-layer" :disabled="!mounted">
    <Transition
      enter-active-class="transition-opacity duration-200"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition-opacity duration-200"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="modelValue"
        class="fixed inset-0 bg-black/50 dark:bg-black/70 flex items-center justify-center z-50 p-4"
        @click.self="close"
        role="dialog"
        aria-modal="true"
        :aria-labelledby="title ? 'modal-title' : undefined"
      >
        <div
          ref="modalRef"
          class="bg-white dark:bg-gray-800 rounded-lg shadow-2xl max-w-md w-full p-6"
        >
          <!-- Header -->
          <div v-if="title" class="flex items-center justify-between mb-4">
            <h2
              id="modal-title"
              class="text-xl font-bold text-gray-900 dark:text-gray-100"
            >
              {{ title }}
            </h2>
            <button
              @click="close"
              class="text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200"
              aria-label="Close modal"
            >
              ✕
            </button>
          </div>

          <!-- Content slot -->
          <div class="text-gray-700 dark:text-gray-300">
            <slot />
          </div>

          <!-- Footer slot -->
          <div v-if="$slots.footer" class="mt-6 pt-4 border-t border-gray-200 dark:border-gray-700">
            <slot name="footer" :close="close" />
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>
```