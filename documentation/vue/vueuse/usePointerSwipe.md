# usePointerSwipe

**Category:** Sensors
**Export Size:** 1.33 kB
**Last Changed:** 5 months ago

Reactive swipe detection based on [PointerEvents](https://developer.mozilla.org/en-US/docs/Web/API/PointerEvent).

## Demo

Reset / Swipe

## Usage

```vue
<script setup lang="ts">
import { usePointerSwipe } from '@vueuse/core'
import { ref } from 'vue'

const el = ref('el')
const { direction, distanceX } = usePointerSwipe(el)
</script>

<template>
  <div ref="el">
    Swipe here
  </div>
</template>
```

## Type Declarations

```ts
export interface UsePointerSwipeOptions {
  /**
   * @default 50
   */
  threshold?: number

  /**
   * Callback on swipe start.
   */
  onSwipeStart?: (e: PointerEvent) => void

  /**
   * Callback on swipe move.
   */
  onSwipe?: (e: PointerEvent) => void

  /**
   * Callback on swipe end.
   */
  onSwipeEnd?: (e: PointerEvent, direction: SwipeDirection) => void

  /**
   * Pointer types to listen to.
   *
   * @default ['mouse', 'touch', 'pen']
   */
  pointerTypes?: PointerType[]

  /**
   * Disable text selection on swipe.
   *
   * @default false
   */
  disableTextSelect?: boolean
}

export interface UsePointerSwipeReturn {
  readonly isSwiping: Ref<boolean>
  direction: Readonly<Ref<SwipeDirection>>
  readonly posStart: Position
  readonly posEnd: Position
  distanceX: Ref<Ref<number>>
  distanceY: Ref<Ref<number>>
  stop: () => void
}

/**
 * Reactive swipe detection based on PointerEvents.
 *
 * @see https://vueuse.org/usePointerSwipe
 * @param target
 * @param options
 */
export declare function usePointerSwipe(
  target: MaybeRefOrGetter<HTMLElement | null | undefined>,
  options?: UsePointerSwipeOptions,
): UsePointerSwipeReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointerSwipe/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointerSwipe/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/usePointerSwipe/index.md)
