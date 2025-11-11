# usePointer

**Category:** Sensors
**Export Size:** 1.03 kB
**Last Changed:** last month

Reactive [pointer state](https://developer.mozilla.org/en-US/docs/Web/API/Pointer_events).

## Demo

```json
{
  "x": 0,
  "y": 0,
  "pointerId": 0,
  "pressure": 0,
  "tiltX": 0,
  "tiltY": 0,
  "width": 0,
  "height": 0,
  "twist": 0,
  "pointerType": null,
  "isInside": false
}
```

## Basic Usage

```ts
import { usePointer } from '@vueuse/core'

const { x, y, pressure, pointerType } = usePointer()
```

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

By default, the component will track the pointer on `window`

```vue
<template>
  <UsePointer v-slot="{ x, y }">
    x: {{ x }}
    y: {{ y }}
  </UsePointer>
</template>
```

To track local position in the element, set `target="self"`:

```vue
<template>
  <UsePointer v-slot="{ x, y }" target="self">
    x: {{ x }} y: {{ y }}
  </UsePointer>
</template>
```

## Type Declarations

```ts
export interface UsePointerState extends Position {
  pressure: number
  pointerId: number
  tiltX: number
  tiltY: number
  width: number
  height: number
  twist: number
  pointerType: PointerType | null
}

export interface UsePointerOptions extends ConfigurableWindow {
  /**
   * Pointer types that listen to.
   *
   * @default ['mouse', 'touch', 'pen']
   */
  pointerTypes?: PointerType[]

  /**
   * Initial values
   */
  initialValue?: MaybeRefOrGetter<Partial<UsePointerState>>

  /**
   * @default window
   */
  target?: MaybeRefOrGetter<EventTarget | null | undefined> | Document | Window
}

/**
 * Reactive pointer state.
 *
 * @see https://vueuse.org/usePointer
 * @param options
 */
export declare function usePointer(options?: UsePointerOptions): {
  isInside: Ref<boolean, boolean>
  pressure: Ref<number, number>
  pointerId: Ref<number, number>
  tiltX: Ref<number, number>
  tiltY: Ref<number, number>
  width: Ref<number, number>
  height: Ref<number, number>
  twist: Ref<number, number>
  pointerType: Ref<PointerType | null, PointerType | null>
  x: Ref<number, number>
  y: Ref<number, number>
}

export type UsePointerReturn = ReturnType<typeof usePointer>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointer/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointer/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointer/index.md)
