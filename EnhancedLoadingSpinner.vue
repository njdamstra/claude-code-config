<script setup lang="ts">
import { computed } from 'vue'

// Props with TypeScript interface
const props = withDefaults(
  defineProps<{
    size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
    variant?: 'primary' | 'secondary' | 'white' | 'current'
    text?: string
    inline?: boolean
  }>(),
  {
    size: 'md',
    variant: 'primary',
    text: undefined,
    inline: false
  }
)

// Size mappings (width/height + border width)
const sizeClasses = computed(() => {
  const sizes = {
    xs: 'w-4 h-4 border-2',
    sm: 'w-6 h-6 border-2',
    md: 'w-8 h-8 border-2',
    lg: 'w-12 h-12 border-3',
    xl: 'w-16 h-16 border-4'
  }
  return sizes[props.size]
})

// Variant color mappings
const variantClasses = computed(() => {
  const variants = {
    primary: 'border-blue-600 dark:border-blue-400',
    secondary: 'border-gray-600 dark:border-gray-400',
    white: 'border-white dark:border-gray-100',
    current: 'border-current'
  }
  return variants[props.variant]
})

// Text size based on spinner size
const textSizeClasses = computed(() => {
  const sizes = {
    xs: 'text-xs',
    sm: 'text-sm',
    md: 'text-base',
    lg: 'text-lg',
    xl: 'text-xl'
  }
  return sizes[props.size]
})

// Container classes
const containerClasses = computed(() => {
  if (props.inline) {
    return 'inline-flex items-center space-x-2'
  }
  return 'flex flex-col items-center justify-center space-y-3'
})
</script>

<template>
  <div :class="containerClasses" role="status" aria-live="polite" aria-label="Loading">
    <!-- Spinner -->
    <div
      :class="[sizeClasses, variantClasses]"
      class="rounded-full border-t-transparent animate-spin"
      aria-hidden="true"
    />

    <!-- Optional loading text -->
    <span
      v-if="props.text"
      :class="textSizeClasses"
      class="text-gray-700 dark:text-gray-300 font-medium"
    >
      {{ props.text }}
    </span>

    <!-- Screen reader only text -->
    <span class="sr-only">Loading content, please wait...</span>
  </div>
</template>

<style scoped>
/* Optional: Ensure border-width utilities work if not in Tailwind config */
.border-3 {
  border-width: 3px;
}
</style>
