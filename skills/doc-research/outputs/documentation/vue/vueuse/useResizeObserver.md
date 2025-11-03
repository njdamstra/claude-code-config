[Skip to content](https://vueuse.org/core/useResizeObserver/#VPContent)

On this page

# useResizeObserver [​](https://vueuse.org/core/useResizeObserver/\#useresizeobserver)

Category

[Elements](https://vueuse.org/functions#category=Elements)

Export Size

500 B

Last Changed

7 months ago

Reports changes to the dimensions of an Element's content or the border-box

## Demo [​](https://vueuse.org/core/useResizeObserver/\#demo)

Resize the box to see changes

width: 175
height: 30

## Usage [​](https://vueuse.org/core/useResizeObserver/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
,
} from 'vue'

const
=
('el')
const
=
('')

(

, (
) => {
  const
=
[0]
  const {
,
} =
.



.
= `width: ${
}, height: ${
}`
})
</script>

<template>
  <


="
">
    {{
}}
  </
>
</template>
```

## Directive Usage [​](https://vueuse.org/core/useResizeObserver/\#directive-usage)

> This function also provides a directive version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<script setup lang="ts">
import {
} from '@vueuse/components'

const
=
('')

function
(
) {
  const [\
] =


  const {
,
} =
.contentRect


.
= `width: ${
}, height: ${
}`
}
</script>

<template>
  <

er="
">
    {{
}}
  </
>
</template>
```

[ResizeObserver MDN](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver)

## Type Declarations [​](https://vueuse.org/core/useResizeObserver/\#type-declarations)

Show Type Declarations

ts

```
export interface ResizeObserverSize {
  readonly
: number
  readonly
: number
}
export interface ResizeObserverEntry {
  readonly
: Element
  readonly
: DOMRectReadOnly
  readonly
:
<ResizeObserverSize>
  readonly
:
<ResizeObserverSize>
  readonly
:
<ResizeObserverSize>
}
export type
= (


:
<ResizeObserverEntry>,

:
,
) => void
export interface UseResizeObserverOptions extends ConfigurableWindow {
  /**
   * Sets which box model the observer will observe changes to. Possible values
   * are `content-box` (the default), `border-box` and `device-pixel-content-box`.
   *
   * @default 'content-box'
   */

?:


}
declare class
{
  constructor(
:
)

(): void

(
: Element,
?: UseResizeObserverOptions): void

(
: Element): void
}
/**
 * Reports changes to the dimensions of an Element's content or the border-box
 *
 * @see https://vueuse.org/useResizeObserver
 * @param target
 * @param callback
 * @param options
 */
export declare function
(

:
    |


    |
[]
    |
<
[]>,

:
,

?: UseResizeObserverOptions,
): {

:
<boolean>

: () => void
}
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useResizeObserver/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useResizeObserver/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useResizeObserver/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useResizeObserver/index.md)
