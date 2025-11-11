# Pattern 1: Primitive Component (Foundation)

Renders any HTML element dynamically:

```vue
<script setup lang="ts">
interface Props {
  as?: string
  asChild?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  as: 'div',
  asChild: false
})
</script>

<template>
  <component :is="as" v-if="!asChild" v-bind="$attrs">
    <slot />
  </component>
  <slot v-else />
</template>
```

**Usage:**
```vue
<!-- Render as button -->
<Primitive as="button" class="my-button">Click</Primitive>

<!-- Render as custom component with asChild -->
<Primitive as-child>
  <RouterLink to="/home">Link styled as button</RouterLink>
</Primitive>
```
