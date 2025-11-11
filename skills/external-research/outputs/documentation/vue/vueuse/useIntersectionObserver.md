[Skip to content](https://vueuse.org/core/useIntersectionObserver/#VPContent)

On this page

# useIntersectionObserver [​](https://vueuse.org/core/useIntersectionObserver/\#useintersectionobserver)

Category

[Elements](https://vueuse.org/functions#category=Elements)

Export Size

638 B

Last Changed

7 months ago

Detects that a target element's visibility.

## Demo [​](https://vueuse.org/core/useIntersectionObserver/\#demo)

Enable

Scroll me down!

Hello world!

Element inside the viewport

## Usage [​](https://vueuse.org/core/useIntersectionObserver/\#usage)

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
<HTMLDivElement>('target')
const
=
(false)

const {
} =
(


,
  ([\
],
) => {


.
=
?.
|| false
  },
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

## Directive Usage [​](https://vueuse.org/core/useIntersectionObserver/\#directive-usage)

> This function also provides a directive version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<script setup lang="ts">
import {
} from '@vueuse/components'
import {
,
} from 'vue'

const
=
<HTMLDivElement>('root')

const
=
(false)

function
([\
]: IntersectionObserverEntry[]) {

.
=
?.
|| false
}
</script>

<template>
  <
>
    <
>
      Scroll me down!
    </
>
    <

er="
">
      <
>Hello world!</
>
    </
>
  </
>

  <!-- with options -->
  <


="
">
    <
>
      Scroll me down!
    </
>
    <

er="


">
      <
>Hello world!</
>
    </
>
  </
>
</template>
```

[IntersectionObserver MDN](https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver/IntersectionObserver)

## Type Declarations [​](https://vueuse.org/core/useIntersectionObserver/\#type-declarations)

Show Type Declarations

ts

```
export interface UseIntersectionObserverOptions extends ConfigurableWindow {
  /**
   * Start the IntersectionObserver immediately on creation
   *
   * @default true
   */

?: boolean
  /**
   * The Element or Document whose bounds are used as the bounding box when testing for intersection.
   */

?:
| Document
  /**
   * A string which specifies a set of offsets to add to the root's bounding_box when calculating intersections.
   */

?: string
  /**
   * Either a single number or an array of numbers between 0.0 and 1.
   * @default 0
   */

?: number | number[]
}
export interface UseIntersectionObserverReturn extends Pausable {

:
<boolean>

: () => void
}
/**
 * Detects that a target element's visibility.
 *
 * @see https://vueuse.org/useIntersectionObserver
 * @param target
 * @param callback
 * @param options
 */
export declare function
(

:
    |


    |
<
[]>
    |
[],

: IntersectionObserverCallback,

?: UseIntersectionObserverOptions,
): UseIntersectionObserverReturn
```

## Source [​](https://vueuse.org/core/useIntersectionObserver/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useIntersectionObserver/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useIntersectionObserver/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useIntersectionObserver/index.md)
