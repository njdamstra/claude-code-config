[Skip to content](https://vueuse.org/core/useMouseInElement/#VPContent)

On this page

# useMouseInElement [​](https://vueuse.org/core/useMouseInElement/\#usemouseinelement)

Category

[Elements](https://vueuse.org/functions#category=Elements)

Export Size

1.87 kB

Last Changed

2 months ago

Reactive mouse position related to an element

## Demo [​](https://vueuse.org/core/useMouseInElement/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouseInElement/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNplUsFq4zAQ/ZXBF9tg4suegh02LAu70MBu6aXgi4hHwVSWhDxyG4z77R1ZjtPSi63RmzdvRvOm5GjtbvSY7JNqOLvOEgxI3oIS+lI3CQ1Ncmh011vjCCZwKM7UyWsBfsCT4c9f/Vthj5pgBulMD+lPrsdAeTYO02/cERfuE/ZWCcJHlBuReff85+PpYb2/il7dgSPXWYFdGYLQP8ONPhs9cP/kOn3hHqHe2s0aDZB12nrag9DXHOrDorDbsiNaQPZSwLjgUyABdBIyulo0Ekao6xpS6TVXNTrNbznASuSdBq9blJ3GNt7P8beCY4jm4kYaWFjhf28I90DOYxHvpTKvv4xSuIj8E23LiXuQQg0xZc75l98nJuEuSDzu13et/jydHtblHLI0ZqXMi6w+bG97oxGzbxvNIiXfKIRvQeb+ZksNhqsymoetwgGtPXAEULXdyCPhG7vpvUngIiyffiy2CtNWyz4dyuC2RY+TyhtoHd6sGFzArGmKbcxzVTIaNUoW4VNVfpJO5g+wgvvc)

Hover me

```
x: 0
y: 0
sourceType: null
elementX: -8
elementY: -12551.5625
elementPositionX: 8
elementPositionY: 12551.5625
elementHeight: 18
elementWidth: 1904
isOutside: true

```

## Usage [​](https://vueuse.org/core/useMouseInElement/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
<HTMLDivElement>('target')

const {
,
,
} =
(
)
</script>

<template>
  <

="
">
    <
>Hello world</
>
  </
>
</template>
```

## Component Usage [​](https://vueuse.org/core/useMouseInElement/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UseMouseInElement v-slot="{
,
,
}">
    x: {{
}}
    y: {{
}}
    Is Outside: {{
}}
  </UseMouseInElement>
</template>
```

## Directive Usage [​](https://vueuse.org/core/useMouseInElement/\#directive-usage)

> This function also provides a directive version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<script setup lang="ts">
import {
} from '@vueuse/components'
import {
} from '@vueuse/core'

interface MouseInElementType {

: number

: number

:


: number

: number

: number

: number

: number

: number

: boolean
}

const
= {

: true
}
function
({
,
,
,
,
,
,
,
,
,
}: MouseInElementType) {

.
(
,
,
,
,
,
,
,
,
,
)
}
</script>

<template>
  <

ent="
" />
  <!-- with options -->
  <

ent="

" />
</template>
```

## Type Declarations [​](https://vueuse.org/core/useMouseInElement/\#type-declarations)

Show Type Declarations

ts

```
export interface MouseInElementOptions extends UseMouseOptions {
  /**
   * Whether to handle mouse events when the cursor is outside the target element.
   * When enabled, mouse position will continue to be tracked even when outside the element bounds.
   *
   * @default true
   */

?: boolean
  /**
   * Listen to window resize event
   *
   * @default true
   */

?: boolean
  /**
   * Listen to window scroll event
   *
   * @default true
   */

?: boolean
}
/**
 * Reactive mouse position related to an element.
 *
 * @see https://vueuse.org/useMouseInElement
 * @param target
 * @param options
 */
export declare function
(

?:
,

?: MouseInElementOptions,
): {

:
<number, number>

:
<number, number>

:
<
,
>

:
<number, number>

:
<number, number>

:
<number, number>

:
<number, number>

:
<number, number>

:
<number, number>

:
<boolean, boolean>

: () => void
}
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useMouseInElement/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouseInElement/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouseInElement/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouseInElement/index.md)
