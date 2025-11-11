# useFocus

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 802 B

Last Changed: 8 months ago

Reactive utility to track or set the focus state of a DOM element. State changes to reflect whether the target element is the focused element. Setting reactive value from the outside will trigger `focus` and `blur` events for `true` and `false` values respectively.

## Demo

Paragraph that can be focused

Button that can be focused

---

The input control has focus

Focus text  Focus input  Focus button

## Basic Usage

```ts
import { useFocus } from '@vueuse/core'

const target = ref()
const { focused } = useFocus(target)

watch(focused, (focused) => {
  if (focused)
    console.log('input element has been focused')
  else
    console.log('input element has lost focus')
})
```

## Setting initial focus

To focus the element on its first render one can provide the `initialValue` option as `true`. This will trigger a `focus` event on the target element.

```ts
import { useFocus } from '@vueuse/core'

const target = ref()
const { focused } = useFocus(target, { initialValue: true })
```

## Change focus state

Changes of the `focused` reactive ref will automatically trigger `focus` and `blur` events for `true` and `false` values respectively. You can utilize this behavior to focus the target element as a result of another action (e.g. when a button click as shown below).

```vue
<script setup lang="ts">
import { useFocus } from '@vueuse/core'
import { ref } from 'vue'

const input = ref()
const { focused } = useFocus(input)
</script>

<template>
  <div>
    <button type="button" @click="focused = true">
      Click me to focus input below
    </button>
    <input ref="input" type="text">
  </div>
</template>
```

## Type Declarations

```ts
export interface UseFocusOptions extends ConfigurableWindow {
  /**
   * Initial value. If set true, then focus will be set on the target
   *
   * @default false
   */
  initialValue?: boolean
  /**
   * Replicate the :focus-visible behavior of CSS
   *
   * @default false
   */
  focusVisible?: boolean
  /**
   * Prevent scrolling to the element when it is focused.
   *
   * @default false
   */
  preventScroll?: boolean
}

export interface UseFocusReturn {
  /**
   * If read as true, then the element has focus. If read as false, then the element does not have focus
   * If set to true, then the element will be focused. If set to false, the element will be blurred.
   */
  focused: WritableComputedRef<boolean>
}

/**
 * Track or set the focus state of a DOM element.
 *
 * @see https://vueuse.org/useFocus
 * @param target The target element for the focus and blur events.
 * @param options
 */
export declare function useFocus(
  target: MaybeElementRef,
  options?: UseFocusOptions,
): UseFocusReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useFocus/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useFocus/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useFocus/index.md)

## Contributors

- Anthony Fu
- IlyaL
- William T. Kirby
- SerKo
- Robin
- Fernando Fernández
- 陪我去看海吧
- Max
- Waleed Khaled
- Jelf
- ByMykel
- Levi Bucsis
- webfansplz
- Jakub Freisler

## Changelog

### v12.4.0 on 1/10/2025

`dd316` - feat: use passive event handlers everywhere is possible (#4477)

### v12.0.0-beta.1 on 11/21/2024

`0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v10.10.1 on 6/11/2024

`4d868` - feat: support `preventScroll` option (#3994)

### v10.3.0 on 7/30/2023

`80329` - feat: support `:focus-visible` (#3254)
