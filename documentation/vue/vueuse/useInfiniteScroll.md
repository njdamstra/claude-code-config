[Skip to content](https://vueuse.org/core/useInfiniteScroll/#VPContent)

On this page

# useInfiniteScroll [​](https://vueuse.org/core/useInfiniteScroll/\#useinfinitescroll)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

2.86 kB

Last Changed

7 months ago

Infinite scrolling of the element.

## Demo [​](https://vueuse.org/core/useInfiniteScroll/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useInfiniteScroll/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNptU02P2jAQ/SujXAgqSaBbLgjQrqpKrcRetnsjqDLJJFjr2JY/YBHiv3ecBDZb9eLY4zfvzRtPLtGT1unRY7SIlrYwXDuw6LwGwWS9yiNn82idS95oZRxcwFv8JSsuucPfhVFCwBUqoxoYPRIL3WaFMjgaZBisgFkoEfULVpPA8IqNFswhne/plE1ZuSyUtA5QwOof5PLn6/Pmh8AGpVvHIxSj8Q1dMscI30sspW/2aLa7dbzdEeaGCqWQN1JsqT/biHMJpDoJn3gMqzVcwhagyxUoa3cIGiSVHpnwmPaxLzDrkIMr7e0hTtP0yRh2ToPB+NJzLGAO1wnEfybAW507DR9TsUCXYe3VS24dkwUuYDZt41QQkxvFymdq8+JzqQBZBuSp5AW1DE4HlOAOaBC4BamgoZTgx1EHwSkQRANWgboTgnVKW3CG1zUaLushcQWxVAH1vaMYUz+dNxIqJizekH3MGY8hq1KG3qVRoL3RyqLtcJ3JsLYPVHlZOK5k90IbMk3GWlcfTaXmb3ch1GJiyrvmcpl1Q0sjSgfXTwudAJYlP4bhoyFGkUdQCGYtHSqB7xCWpFACaqaTr6CTb3BKHqZT/Q6H/tskzFOT1BFNJdQpOSckFQZ+Xyc1PWsyn06zORjlZYll+5cEZ63sMSHfpEXj1dCLtC6ohMUbnvvooKBDMpv/n5TqergT00xcoCW8kvFWKiOtzuvHbu+do0Y+FoIXb8Q+6Oid6iXEurwOTvFlNuhedP0Lk1dbWQ==)

1

2

3

4

5

6

7

8

9

10

Reset

## Usage [​](https://vueuse.org/core/useInfiniteScroll/\#usage)

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
<HTMLElement>('el')
const
=
([1, 2, 3, 4, 5, 6])

const {
} =
(


,
  () => {
    // load more

.
.
(...moreData)
  },
  {

: 10,

: () => {
      // inidicate when there is no more content to load so onLoadMore stops triggering
      // if (noMoreContent) return false
      return true // for demo purposes
    },
  }
)

function
() {

.
= []

()
}
</script>

<template>
  <

="
">
    <
 v-for="
 in
">
      {{
}}
    </
>
  </
>
  <
 @
="
()">
    Reset
  </
>
</template>
```

## Direction [​](https://vueuse.org/core/useInfiniteScroll/\#direction)

Different scroll directions require different CSS style settings:

| Direction | Required CSS |
| --- | --- |
| `bottom` (default) | No special settings required |
| `top` | `display: flex;`<br>`flex-direction: column-reverse;` |
| `left` | `display: flex;`<br>`flex-direction: row-reverse;` |
| `right` | `display: flex;` |

WARNING

Make sure to indicate when there is no more content to load with `canLoadMore`, otherwise `onLoadMore` will trigger as long as there is space for more content.

## Directive Usage [​](https://vueuse.org/core/useInfiniteScroll/\#directive-usage)

> This function also provides a directive version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<script setup lang="ts">
import {
} from '@vueuse/components'
import {
} from 'vue'

const
=
([1, 2, 3, 4, 5, 6])

function
() {
  const
=
.
.
+ 1

.
.
(...
.
({
: 5 }, (
,
) =>
+
))
}
function
() {
  // inidicate when there is no more content to load so onLoadMore stops triggering
  // if (noMoreContent) return false
  return true // for demo purposes
}
</script>

<template>
  <

ll="
">
    <
 v-for="
 in

"
="
">
      {{
}}
    </
>
  </
>

  <!-- with options -->
  <

ll="


">
    <
 v-for="
 in

"
="
">
      {{
}}
    </
>
  </
>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useInfiniteScroll/\#type-declarations)

Show Type Declarations

ts

```
type
=
  | HTMLElement
  | SVGElement
  | Window
  | Document
  | null
  | undefined
export interface
<

 extends
=
,
> extends UseScrollOptions {
  /**
   * The minimum distance between the bottom of the element and the bottom of the viewport
   *
   * @default 0
   */

?: number
  /**
   * The direction in which to listen the scroll.
   *
   * @default 'bottom'
   */

?: "top" | "bottom" | "left" | "right"
  /**
   * The interval time between two load more (to avoid too many invokes).
   *
   * @default 100
   */

?: number
  /**
   * A function that determines whether more content can be loaded for a specific element.
   * Should return `true` if loading more content is allowed for the given element,
   * and `false` otherwise.
   */

?: (
:
) => boolean
}
/**
 * Reactive infinite scroll.
 *
 * @see https://vueuse.org/useInfiniteScroll
 */
export declare function
<
 extends
>(

:
<
>,

: (


:
<
<typeof useScroll>>,
  ) =>
<void>,

?:
<
>,
): {

:
<boolean>

(): void
}
```

## Source [​](https://vueuse.org/core/useInfiniteScroll/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useInfiniteScroll/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useInfiniteScroll/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useInfiniteScroll/index.md)
