[Skip to content](https://vueuse.org/core/useActiveElement/#VPContent)

On this page

# useActiveElement [​](https://vueuse.org/core/useActiveElement/\#useactiveelement)

Category

[Elements](https://vueuse.org/functions#category=Elements)

Export Size

1.19 kB

Last Changed

last month

Reactive `document.activeElement`

## Demo [​](https://vueuse.org/core/useActiveElement/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useActiveElement/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNplUk1P40AM/SsmWqnlMA27SHuoUli04hdwzYFhYuiI+dKME6hC/juepGkbcRvbz89+z9MXDyFsuhaLbVElFXUgSEhtACPd264uKNXFXe20DT4S9NAmfFCkO3w0aNERDPAavYXVPybhYql8xNVFg/I2tITNCcg4rtdOeZcI5IJs94N/fT0j3/HA9Zluvb6G3d2yfdNJ0+L9ppEkWcT9Rjfw9QUr1xqzYp6qnBSyHg4IbTCSkCOAynnC/ABQRqbEyu2LuK2LnBsRAE9oUBHQHkE7XiLBCxr/AeTZMhzzas+uYRoZy0w5kTe6W3JP0VvUzfkllDdJ/J4Sttmec7dHkAziz2KjatxjegN04tVHJte8HvydhwBs2bmcPmfoEDDfFj/pApZtE7pZQueNr+xB3MCV1U58iJuLLvZQ4d6bBvPs51+9Hp7n8qS+ZPknH872UhZzFPK/jTHffzo9HO+5PapMQbpTX15ahKitjAfu7/vxYwwDH5dhi4lVeXHjYvgGagbzpA==)

Select the inputs below to see the changes

Current Active Element: null

## Usage [​](https://vueuse.org/core/useActiveElement/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
()

(
, (
) => {

.
('focus changed to',
)
})
</script>
```

## Component Usage [​](https://vueuse.org/core/useActiveElement/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UseActiveElement v-slot="{
}">
    Active element is {{
?.dataset.id }}
  </UseActiveElement>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useActiveElement/\#type-declarations)

ts

```
export interface UseActiveElementOptions
  extends ConfigurableWindow,
    ConfigurableDocumentOrShadowRoot {
  /**
   * Search active element deeply inside shadow dom
   *
   * @default true
   */

?: boolean
  /**
   * Track active element when it's removed from the DOM
   * Using a MutationObserver under the hood
   * @default false
   */

?: boolean
}
/**
 * Reactive `document.activeElement`
 *
 * @see https://vueuse.org/useActiveElement
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
<
extends HTMLElement>(

?: UseActiveElementOptions,
):
<
| null | undefined,
| null | undefined>
export type
=
<typeof
>
```

## Source [​](https://vueuse.org/core/useActiveElement/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useActiveElement/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useActiveElement/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useActiveElement/index.md)
