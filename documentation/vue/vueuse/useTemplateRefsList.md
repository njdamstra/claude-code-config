# useTemplateRefsList

**Category:** Component
**Export Size:** 133 B

Shorthand for binding refs to template elements and components inside `v-for`.

## Usage

```vue
<script setup lang="ts">
import { useTemplateRefsList } from '@vueuse/core'
import { onUpdated } from 'vue'

const refs = useTemplateRefsList<HTMLDivElement>()

onUpdated(() => {
  console.log(refs)
})
</script>

<template>
  <div v-for="i of 5" :key="i" :ref="refs.set" />
</template>
```

## Type Declarations

```ts
export type UseTemplateRefsListReturn<T> = T[] & {
  set: (el: object | null) => void
}

export declare function useTemplateRefsList<T = Element>(): UseTemplateRefsListReturn<
  Readonly<Ref<Readonly<T>>>
>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useTemplateRefsList/index.ts)
- [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useTemplateRefsList/demo.vue)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useTemplateRefsList/index.md)
