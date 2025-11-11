[Skip to content](https://vueuse.org/core/useCurrentElement/#VPContent)

On this page

# useCurrentElement [​](https://vueuse.org/core/useCurrentElement/\#usecurrentelement)

Category

[Component](https://vueuse.org/functions#category=Component)

Export Size

365 B

Last Changed

9 months ago

Get the DOM element of current component as a ref.

## Demo [​](https://vueuse.org/core/useCurrentElement/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useCurrentElement/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNplkMtqwzAQRX/loo0dKPY+2KalZN0f0Mao48QgS0IauRTjf884D2LIQmiGuefAzKK+QqjmTOqommTiGBiJOAfY3p1brThp1Wk3TsFHxoKc6DvHSI5Plib5sGKIfkLxKRaZ1sZHKnbEX8/mchoGMq+sRCWinfEuMciifReXhy2xo8vygLbDoh2wgd5SZf25LB6ceG7gsfiQspp7m0kcq7ymvu8mm0jDNAXbM0kHNL/j3P0Ecvj3Oe7FYC+3IPCFnuqm3tKbb+dQ6xWfKXSw)

Open your console.log to see the element

## Usage [​](https://vueuse.org/core/useCurrentElement/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
() // ComputedRef<Element>
```

Or pass a specific vue component

vue

```
<script setup lang="ts">
import {
,
} from '@vueuse/core'
import {
} from 'vue'

const
=
<
>(null as unknown as
)

const
=
(
) // ComputedRef<Element>
</script>

<template>
  <
>
    <OtherVueComponent
="
" />
    <
>Hello world</
>
  </
>
</template>
```

## Caveats [​](https://vueuse.org/core/useCurrentElement/\#caveats)

This functions uses [`$el` under the hood](https://vuejs.org/api/component-instance.html#el).

Value of the ref will be `undefined` until the component is mounted.

- For components with a single root element, it will point to that element.
- For components with text root, it will point to the text node.
- For components with multiple root nodes, it will be the placeholder DOM node that Vue uses to keep track of the component's position in the DOM.

It's recommend to only use this function for components with **a single root element**.

## Type Declarations [​](https://vueuse.org/core/useCurrentElement/\#type-declarations)

ts

```
export declare function
<

extends
=
,

extends
=
,

extends
=
extends


    ?
<
["$el"]> extends false
      ?
["$el"]
      :


    :
,
>(
?:
<
>):
<
>
```

## Source [​](https://vueuse.org/core/useCurrentElement/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useCurrentElement/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useCurrentElement/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useCurrentElement/index.md)
