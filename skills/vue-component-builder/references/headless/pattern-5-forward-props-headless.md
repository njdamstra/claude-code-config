# Pattern 5: Forward Props Pattern

Merge props from wrapper to underlying primitive:

```vue
<script setup lang="ts">
import { DialogRoot } from 'reka-ui'

interface Props {
  open?: boolean
  modal?: boolean
}

const props = defineProps<Props>()

// useForwardProps utility (Reka UI pattern)
function useForwardProps<T extends Record<string, any>>(props: T): T {
  return new Proxy(props, {
    get(target, key) {
      return unref(target[key as keyof T])
    }
  })
}

const forwarded = useForwardProps(props)
</script>

<template>
  <DialogRoot v-bind="forwarded">
    <slot />
  </DialogRoot>
</template>
```
