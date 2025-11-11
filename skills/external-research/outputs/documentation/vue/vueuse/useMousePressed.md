# useMousePressed

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 837 B

Last Changed: 2 weeks ago

Reactive mouse pressing state. Triggered by `mousedown` `touchstart` on target element and released by `mouseup` `mouseleave` `touchend` `touchcancel` on window.

## Demo

```
pressed: false
sourceType: null
```

Tracking on Entire page

## Basic Usage

```ts
import { useMousePressed } from '@vueuse/core'

const { pressed } = useMousePressed()
```

Touching is enabled by default. To make it only detects mouse changes, set `touch` to `false`

```ts
const { pressed } = useMousePressed({ touch: false })
```

To only capture `mousedown` and `touchstart` on specific element, you can specify `target` by passing a ref of the element.

```vue
<script setup lang="ts">
import { ref } from 'vue'

const el = ref<HTMLDivElement>('el')

const { pressed } = useMousePressed({ target: el })
</script>

<template>
  <div ref="el">
    Only clicking on this element will trigger the update.
  </div>
</template>
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseMousePressed v-slot="{ pressed }">
    Is Pressed: {{ pressed }}
  </UseMousePressed>
</template>
```

## Type Declarations

```ts
export interface MousePressedOptions extends ConfigurableWindow {
  /**
   * Listen to `touchstart` `touchend` events
   *
   * @default true
   */
  touch?: boolean
  /**
   * Listen to `dragstart` `drop` and `dragend` events
   *
   * @default true
   */
  drag?: boolean
  /**
   * Add event listeners with the `capture` option set to `true`
   * (see [MDN](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener#capture))
   *
   * @default false
   */
  capture?: boolean
  /**
   * Initial values
   *
   * @default false
   */
  initialValue?: boolean
  /**
   * Element target to be capture the click
   */
  target?: MaybeElementRef
  /**
   * Callback to be called when the mouse is pressed
   *
   * @param event
   */
  onPressed?: (event: MouseEvent | TouchEvent | DragEvent) => void
  /**
   * Callback to be called when the mouse is released
   *
   * @param event
   */
  onReleased?: (event: MouseEvent | TouchEvent | DragEvent) => void
}

/**
 * Reactive mouse pressing state.
 *
 * @see https://vueuse.org/useMousePressed
 * @param options
 */
export declare function useMousePressed(
  options?: MousePressedOptions
): {
  pressed: WritableComputedRef<boolean, boolean>
  sourceType: Ref<MouseSourceType, MouseSourceType>
}

export type UseMousePressedReturn = ReturnType<typeof useMousePressed>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMousePressed/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useMousePressed/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useMousePressed/index.md)

## Contributors

- Anthony Fu
- IlyaL
- wheat
- 丶远方
- NoiseFan
- SerKo
- Robin
- Fernando Fernández
- Meet you
- Chris-Robin Ennen
- Jonas Schade
- RAX7
- ByMykel
- vaakian X
- MinatoHikari
- Marshall Thompson
- Shinigami
- Alex Kozack

## Changelog

### v14.0.0-alpha.0 on 9/1/2025

`8c521` - feat(components)!: refactor components and make them consistent (#4912)

### v12.4.0 on 1/10/2025

`dd316` - feat: use passive event handlers everywhere is possible (#4477)

### v12.3.0 on 1/2/2025

`a123a` - feat: add `onPressed` and `onReleased` as options (#4425)

### v12.0.0-beta.1 on 11/21/2024

`0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v10.7.0 on 12/4/2023

`17f97` - fix: change type of element parameter to MaybeComputedElementRef (#3566)

### v10.5.0 on 10/7/2023

`d5c81` - feat: add capture option (#3392)

### v10.1.0 on 4/22/2023

`4bb5b` - feat(useMouse): support custom event extractor (#2991)
