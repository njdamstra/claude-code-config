[Skip to content](https://vueuse.org/core/useElementBounding/#VPContent)

On this page

# useElementBounding [​](https://vueuse.org/core/useElementBounding/\#useelementbounding)

Category

[Elements](https://vueuse.org/functions#category=Elements)

Export Size

1.31 kB

Last Changed

8 months ago

Reactive [bounding box](https://developer.mozilla.org/en-US/docs/Web/API/Element/getBoundingClientRect) of an HTML element

## Demo [​](https://vueuse.org/core/useElementBounding/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementBounding/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNplUs1unDAQfpURF0AiIWpvCKKmVW+tlES5ROLiwHjXirEt/5AlK949Y9hlE+UE9vcz843nmNwZcz0GTKqkdp0VxoNDHwxIpnZNm3jXJretEoPR1sMRLLLOCz4VEBz+lTig8r91UL1QO5iBWz1A+osMCS47bTH9Jh5xET/hYCTz+Ih8E5Luwn+++//vdD+xQRLQqk4rRx16S+WoC2i2hrJWAWRCmeArYGrKobldLK439ooWkL0WMC74MYoABIfMTwY1hxGapoGUB0WuWqX5mQNUyQergLIiFwr79X5ePydwjKe5OIscFZb4ELTHCrwNWKz3XOq3P1pKXIrcsz6OrwLOpFspc06f/JIYJUX9OrQsRZkSZSVYstqmMWL2/XUylPlG93iI9Mtoop7QulyXgJ6cDv5UjU4AdS9GEkwSaS0Goa72KHZ7GvbPmxtzWLYkRqsVhYVOMuci7+XqxwYBPKIT7wh+j/CiD+A1LRuR97Rr6E76MhqczWKfjEJRME52KNskZuy1ktNWxC6ulqBqZDLE/qKOzuXaeUmt019dfgqUzB+XPwSG)

Resize the box to see changes

height: 0
bottom: 0
left: 0
right: 0
top: 0
width: 0
x: 0
y: 0

## Usage [​](https://vueuse.org/core/useElementBounding/\#usage)

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
,
,
,
,
,
,
} =
(
)
</script>

<template>
  <

="
" />
</template>
```

## Component Usage [​](https://vueuse.org/core/useElementBounding/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UseElementBounding v-slot="{
,
}">
    Width: {{
}} Height: {{
}}
  </UseElementBounding>
</template>
```

## Directive Usage [​](https://vueuse.org/core/useElementBounding/\#directive-usage)

> This function also provides a directive version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<script setup lang="ts">
import {
} from '@vueuse/components'

interface BoundingType {

: number

: number

: number

: number

: number

: number

: number

: number
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
}: BoundingType) {

.
(
,
,
,
,
,
,
,
)
}

const
= {

: true,

: true,

: true,

: true,

: 'sync',
}
</script>

<template>
  <

ng="
" />
  <!-- with options -->
  <

ng="

" />
</template>
```

## Type Declarations [​](https://vueuse.org/core/useElementBounding/\#type-declarations)

Show Type Declarations

ts

```
export interface UseElementBoundingOptions {
  /**
   * Reset values to 0 on component unmounted
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
  /**
   * Immediately call update on component mounted
   *
   * @default true
   */

?: boolean
  /**
   * Timing to recalculate the bounding box
   *
   * Setting to `next-frame` can be useful when using this together with something like {@link useBreakpoints}
   * and therefore the layout (which influences the bounding box of the observed element) is not updated on the current tick.
   *
   * @default 'sync'
   */

?: "sync" | "next-frame"
}
/**
 * Reactive bounding box of an HTML element.
 *
 * @see https://vueuse.org/useElementBounding
 * @param target
 */
export declare function
(

:
,

?: UseElementBoundingOptions,
): {

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
<number, number>

:
<number, number>

: () => void
}
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useElementBounding/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementBounding/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementBounding/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useElementBounding/index.md)
