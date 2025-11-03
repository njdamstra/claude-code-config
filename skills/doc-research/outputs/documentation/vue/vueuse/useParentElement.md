# useParentElement

Category: [Elements](https://vueuse.org/functions#category=Elements)

Export Size: 467 B

Last Changed: 7 months ago

Get parent element of the given element

## Usage

When no argument is passed, it will return the parent element of the current component.

```vue
<script setup lang="ts">
import { useParentElement } from '@vueuse/core'

const parentElement = useParentElement()

onMounted(() => {
  console.log(parentElement.value)
})
</script>
```

It can also accept a `ref` as the first argument.

```vue
<script setup lang="ts">
import { useParentElement } from '@vueuse/core'
import { ref } from 'vue'

const element = ref<HTMLElement | undefined>()

const parentElement = useParentElement(element)

onMounted(() => {
  console.log(parentElement.value)
})
</script>

<template>
  <div>
    <div ref="element" />
  </div>
</template>
```

## Type Declarations

```ts
export declare function useParentElement(
  element?: MaybeComputedElementRef<HTMLElement | SVGElement | null | undefined>,
): ComputedRef<ReturnType<HTMLElement | SVGElement | null | undefined>>
```

## Features

- **Auto Parent Detection**: Automatically detects parent element of current component when no argument provided
- **Ref Support**: Can accept a ref to an element as the first argument
- **Computed Return**: Returns a computed ref that updates when the element changes
- **Type Safe**: Full TypeScript support with proper element type inference
- **SSR Compatible**: Works safely in server-side rendering environments

## Use Cases

- Getting parent element for positioning calculations
- Traversing DOM hierarchy in component logic
- Determining parent container properties
- Implementing portal-like behavior
- Context-aware component behavior based on parent

## Changelog

**v12.8.0** (3/5/2025)
- feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native

**v12.3.0** (1/2/2025)
- feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

**v12.0.0-beta.1** (11/21/2024)
- feat!: drop Vue 2 support, optimize bundles and clean up
