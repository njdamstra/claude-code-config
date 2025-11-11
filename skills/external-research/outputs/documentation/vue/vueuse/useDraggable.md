[Skip to content](https://vueuse.org/core/useDraggable/#VPContent)

On this page

# useDraggable [​](https://vueuse.org/core/useDraggable/\#usedraggable)

Category

[Elements](https://vueuse.org/functions#category=Elements)

Export Size

1.37 kB

Last Changed

7 months ago

Make elements draggable.

## Usage [​](https://vueuse.org/core/useDraggable/\#usage)

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
<HTMLElement>('el')

// `style` will be a helper computed for `left: ?px; top: ?px;`
const {
,
,
} =
(
, {

: {
: 40,
: 40 },
})
</script>

<template>
  <


="

"
="
"
="position: fixed">
    Drag me! I am at {{
}}, {{
}}
  </
>
</template>
```

Set `preventDefault: true` to override the default drag-and-drop behavior of certain elements in the browser.

ts

```
const {
,
,
} =
(el, {

: true,
  // with `preventDefault: true`
  // you can disable the native behavior (e.g., for img)
  // and control the drag-and-drop, preventing the browser interference.
})
```

## Component Usage [​](https://vueuse.org/core/useDraggable/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UseDraggable v-slot="{
,
}"
="{
: 10,
: 10 }">
    Drag me! I am at {{
}}, {{
}}
  </UseDraggable>
</template>
```

For component usage, additional props `storageKey` and `storageType` can be passed to the component and enable the persistence of the element position.

vue

```
<template>
  <UseDraggable

="vueuse-draggable"

="session">
    Refresh the page and I am still in the same position!
  </UseDraggable>
</template>
```

## Source [​](https://vueuse.org/core/useDraggable/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDraggable/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDraggable/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDraggable/index.md)
