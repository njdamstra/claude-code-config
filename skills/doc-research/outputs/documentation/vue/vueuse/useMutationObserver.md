# useMutationObserver

Category: [Elements](https://vueuse.org/functions#category=Elements)

Export Size: 558 B

Last Changed: 2 months ago

Watch for changes being made to the DOM tree. [MutationObserver MDN](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver)

## Usage

```vue
<script setup lang="ts">
import { useMutationObserver } from '@vueuse/core'
import { ref, shallowRef } from 'vue'

const el = ref('el')
const messages = shallowRef([])

useMutationObserver(
  el,
  (mutations) => {
    if (mutations[0])
      messages.value.push(mutations[0].attributeName)
  },
  {
    attributes: true,
  }
)
</script>

<template>
  <div ref="el">
    Hello VueUse
  </div>
</template>
```

## Type Declarations

```ts
export interface UseMutationObserverOptions
  extends MutationObserverInit,
    ConfigurableWindow {}

/**
 * Watch for changes being made to the DOM tree.
 *
 * @see https://vueuse.org/useMutationObserver
 * @see https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver MutationObserver MDN
 * @param target
 * @param callback
 * @param options
 */
export declare function useMutationObserver(
  target:
    | MaybeRef<Element>
    | MaybeRef<Element>[]
    | Ref<Element[]>,
  callback: MutationCallback,
  options?: UseMutationObserverOptions,
): {
  isSupported: Ref<boolean>
  stop: () => void
  takeRecords: () => MutationRecord[] | undefined
}

export type UseMutationObserverReturn = ReturnType<typeof useMutationObserver>
```

## Features

- **Watch DOM Changes**: Monitor changes to the DOM tree including attributes, child nodes, and subtree modifications
- **Multiple Targets**: Can accept single element, array of elements, or ref to array of elements
- **Flexible Options**: Supports all MutationObserverInit options (attributes, childList, subtree, etc.)
- **Take Records**: Access pending mutation records with `takeRecords()` function
- **Auto Cleanup**: Automatically stops observing when component unmounts
- **Browser Support Detection**: Returns `isSupported` ref to check for MutationObserver availability

## Options

The composable accepts all standard `MutationObserverInit` options:

- **attributes**: Set to true to observe attribute changes
- **attributeOldValue**: Set to true to record attribute value before change
- **characterData**: Set to true to observe node data changes
- **characterDataOldValue**: Set to true to record data value before change
- **childList**: Set to true to observe node's children additions/removals
- **subtree**: Set to true to extend observation to entire subtree
- **attributeFilter**: Array of attribute names to observe (observes all if not specified)

## Return Values

- **isSupported**: Ref<boolean> - Browser support for MutationObserver
- **stop**: () => void - Function to stop observing
- **takeRecords**: () => MutationRecord[] | undefined - Get pending mutation records

## Changelog

**v12.8.0** (3/5/2025)
- feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native

**v12.3.0** (1/2/2025)
- feat(toArray): new utility function
- feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

**v12.0.0-beta.1** (11/21/2024)
- feat!: drop Vue 2 support, optimize bundles and clean up

**v11.0.0-beta.1** (6/12/2024)
- fix: stop watching before cleaning up

**v10.8.0** (2/20/2024)
- feat: allow multiple targets

**v10.6.0** (11/9/2023)
- feat: add `takeRecords` function

**v10.5.0** (10/7/2023)
- feat: use MaybeComputedElementRef
