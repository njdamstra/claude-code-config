# useVModels

**Category**: Component
**Export Size**: 213 B
**Last Changed**: 2 weeks ago

Shorthand for props v-model binding.

## Usage

`useVModels` is a utility that simplifies handling multiple `v-model` bindings on a child component. It takes the component's `props` and `emit` function and returns a reactive object where each property corresponds to a `v-model` binding.

When you modify a property on the returned object, `useVModels` automatically emits the corresponding `update:propName` event.

### Example

**Parent Component:**
```vue
<script setup>
import { ref } from 'vue'
import MyComponent from './MyComponent.vue'

const firstName = ref('John')
const lastName = ref('Doe')
</script>

<template>
  <MyComponent v-model:first-name="firstName" v-model:last-name="lastName" />
</template>
```

**Child Component (`MyComponent.vue`):**
```vue
<script setup>
import { useVModels } from '@vueuse/core'

const props = defineProps({
  firstName: String,
  lastName: String,
})

const emit = defineEmits(['update:firstName', 'update:lastName'])

// Use useVModels to handle multiple v-model bindings
const { firstName, lastName } = useVModels(props, emit)
</script>

<template>
  <input v-model="firstName" type="text" />
  <input v-model="lastName" type="text" />
</template>
```

> **Note:** While `useVModels` is useful, Vue 3.4 introduced `defineModel`, which is now the recommended way to handle `v-model` bindings in most cases.

## Type Declarations

```ts
/**
 * Shorthand for props v-model binding.
 *
 * @see https://vueuse.org/useVModels
 * @param props
 * @param emit
 * @param options
 */
export declare function useVModels<P extends object>(
  props: P,
  emit?: (name: string, ...args: any[]) => void,
  options?: UseVModelsOptions,
): ToRefs<P>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useVModels/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useVModels/index.md)
