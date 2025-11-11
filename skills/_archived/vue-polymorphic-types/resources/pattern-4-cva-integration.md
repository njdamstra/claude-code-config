# Pattern 4: CVA Integration with Generics

Combine Class Variance Authority with generic components:

```vue
<script setup lang="ts" generic="T">
import { cva, type VariantProps } from 'class-variance-authority'
import { computed } from 'vue'

const buttonVariants = cva({
  base: 'inline-flex items-center rounded-lg font-medium',
  variants: {
    variant: {
      primary: 'bg-primary-500 text-white',
      secondary: 'bg-gray-500 text-white',
      outline: 'border-2 border-primary-500 text-primary-600'
    },
    size: {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2 text-base',
      lg: 'px-6 py-3 text-lg'
    }
  },
  defaultVariants: {
    variant: 'primary',
    size: 'md'
  }
})

type ButtonVariantProps = VariantProps<typeof buttonVariants>

interface Props extends ButtonVariantProps {
  data: T
}

const props = defineProps<Props>()
const emit = defineEmits<{
  (e: 'click', data: T): void
}>()

const classes = computed(() =>
  buttonVariants({
    variant: props.variant,
    size: props.size
  })
)
</script>

<template>
  <button :class="classes" @click="emit('click', data)">
    <slot />
  </button>
</template>
```
