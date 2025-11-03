[Skip to content](https://vueuse.org/core/useSwipe/#VPContent)

On this page

# useSwipe [​](https://vueuse.org/core/useSwipe/\#useswipe)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

1.02 kB

Last Changed

last month

Reactive swipe detection based on [`TouchEvents`](https://developer.mozilla.org/en-US/docs/Web/API/TouchEvent).

## Demo [​](https://vueuse.org/core/useSwipe/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useSwipe/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqdVVuvGjcQ/itTThs4EgucRJXa7UJSqUfqQ/OSpmor8RCzO8u6Mba19sJBhP/esb1XLooUHlbj8Vw+f3PhNPpV69m+wlE8Skxacm3BoK00CCa3y/XImvVotZZ8p1VpwR41wgn+MvjngWv8jZeYWq4knCEv1Q7G7yhUZXCeqhLHrdsJSOc9vmqYqp2uLGZTMAUTQh0+YN46kQ/ZrmWqpCEwrNyihWXPMvn94/s/ngXuUFr4ArISYjVx38fGib6WcYnlt/r9zTNbkHMDdDJ5hOWqu5/tmajw7UzlORHprdsgAvMh3sl4MW5vlWYpt8ehwRNdr2VeycBziRSUMp7WEny4kI58KJLT1UFa9dNanjvKTpA1JZsCN64kXG6nFElubfFPI/xLjC/bmk1c3ED21Ik+N4BmxvA9xpAzYdDfUHoZXEj9UVVp8bwnRmu47sdzmAypDEh7JsGoRlS/I4HFwAIc355QZ0VY3zOKxDZm6EfcdR4Dtj59fwqWZ/3yqW91xd/sCaImz/yiDYJV505MNyISJ0PEt6p1N+uNmLVwHjL9LLMh2dOuxPH1oF6U4oplePXq5hudfnKH5Du0PMJqCYvZj4PCDUl4Wix+6PFwycLi4unXrN7n9C6jAxrdl5okmYfVR4uODhZ3WjCLdAJIMr73QhBpAHPaiu171yNIBQ1CX0cLVBDbkVQS/fIMiZNNZS2N8LtU8PQzOfhZ7hkAfPCaxn4eHLoAXf4wjb3kao+lYEfSxI3qBIzWKr0ji+G7dtbp/WRj7FGgt3EMTtvVQ5c9OIlehaVd8m1hk7nuoMx7tPRl3SIyltkq/HkEn7YHYzj19hC87ckxjKMxnM9EVtk61t3m3WrZmXxpllXvghZXXd8GbYMumffKSkfPAJhUacxIM+uq59tLK8MD1hLJifbcL06dcUMxjrTzBL54DRN8KyNOwU0MKc0fll7/X2Usz4+Ri0vawd1GlRmWMbzWL5AxU2AGD2ma+jtXyJx2fwwFzzKUpPT7e1ZXOMCzSsew8A6ugI18cNMXgxsrfy7QFa6n6J5FY6wE/X8FQCz9vC1VJalVHt7km59/enOZd9Y0Uw2gZLINJQTN+WsDyAxGXEaqslewV6CDZ6qEorc/5Hnuc+dEUHSogW6UyLzW4ouNPLcD5m6wQ68uiP7IUAvTIpTqUDLdpg9dWGO+FZPMaPpdM1AXjM7/A4/Z+5s=)

Reset

Direction: none

lengthX: 0 \| lengthY: 0

## Usage [​](https://vueuse.org/core/useSwipe/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
('el')
const {
,
} =
(
)
</script>

<template>
  <

="
">
    Swipe here
  </
>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useSwipe/\#type-declarations)

Show Type Declarations

ts

```
export type
= "up" | "down" | "left" | "right" | "none"
export interface UseSwipeOptions extends ConfigurableWindow {
  /**
   * Register events as passive
   *
   * @default true
   */

?: boolean
  /**
   * @default 50
   */

?: number
  /**
   * Callback on swipe start
   */

?: (
: TouchEvent) => void
  /**
   * Callback on swipe moves
   */

?: (
: TouchEvent) => void
  /**
   * Callback on swipe ends
   */

?: (
: TouchEvent,
:
) => void
}
export interface UseSwipeReturn {

:
<boolean>

:
<
>

:
<
>

:
<
>

:
<number>

:
<number>

: () => void
}
/**
 * Reactive swipe detection.
 *
 * @see https://vueuse.org/useSwipe
 * @param target
 * @param options
 */
export declare function
(

:
<EventTarget | null | undefined>,

?: UseSwipeOptions,
): UseSwipeReturn
```

## Source [​](https://vueuse.org/core/useSwipe/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useSwipe/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useSwipe/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useSwipe/index.md)
