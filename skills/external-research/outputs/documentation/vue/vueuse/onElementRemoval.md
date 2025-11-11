# onElementRemoval

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 735 B

Last Changed: 9 months ago

Fires when the element or any element containing it is removed.

## Demo

### demo1: recreate new element

remove me

**removed times: 0**

---

### demo2: reuse same element

remove me  target element

**removed times: 0**

## Usage

```vue
<script setup lang="ts">
import { onElementRemoval } from '@vueuse/core'
import { ref, unref } from 'vue'

const btn = ref<HTMLElement>('btn')
const recreate = ref(true)
const removedTimes = ref(0)

function toggle() {
  recreate.value = !recreate.value
}

onElementRemoval(btn, () => ++removedTimes.value)
</script>

<template>
  <button
    v-if="recreate"
    @click="toggle"
  >
    recreate me
  </button>
  <button
    v-else
    ref="btn"
    @click="toggle"
  >
    remove me
  </button>
  <p>removed times: {{ removedTimes }}</p>
</template>
```

## Type Declarations

```ts
export interface OnElementRemovalOptions
  extends ConfigurableWindow,
    ConfigurableDocumentOrShadowRoot,
    WatchOptionsBase {}

/**
 * Fires when the element or any element containing it is removed.
 *
 * @param target
 * @param callback
 * @param options
 */
export declare function onElementRemoval(
  target: MaybeRefOrGetter<Element | null | undefined>,
  callback: (records: MutationRecord[]) => void,
  options?: OnElementRemovalOptions,
): WatchStopHandle
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/onElementRemoval/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/onElementRemoval/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/onElementRemoval/index.md)

## Contributors

- Anthony Fu
- IlyaL
- Ben Lau

## Changelog

### v12.3.0 on 1/2/2025

`08cf5` - feat: new function, refactor `useActiveElement` `useElementHover` (#4410)
