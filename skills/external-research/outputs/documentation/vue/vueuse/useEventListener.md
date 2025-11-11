[Skip to content](https://vueuse.org/core/useEventListener/#VPContent)

On this page

# useEventListener [​](https://vueuse.org/core/useEventListener/\#useeventlistener)

Category

[Browser](https://vueuse.org/functions#category=Browser)

Export Size

588 B

Last Changed

2 months ago

Use EventListener with ease. Register using [addEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener) on mounted, and [removeEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener) automatically on unmounted.

## Usage [​](https://vueuse.org/core/useEventListener/\#usage)

ts

```
import {
} from '@vueuse/core'

(
, 'visibilitychange', (
) => {

.
(
)
})
```

You can also pass a ref as the event target, [`useEventListener`](https://vueuse.org/core/useEventListener/) will unregister the previous event and register the new one when you change the target.

vue

```
<script setup lang="ts">
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
('element')

(
, 'keydown', (
) => {

.
(
.
)
})
</script>

<template>
  <
 v-if="cond"
="
">
    Div1
  </
>
  <
 v-else
="
">
    Div2
  </
>
</template>
```

You can also call the returned to unregister the listener.

ts

```
import {
} from '@vueuse/core'

const
=
(
, 'keydown', (
) => {

.
(
.
)
})

() // This will unregister the listener.
```

Note if your components also run in SSR (Server Side Rendering), you might get errors (like `document is not defined`) because DOM APIs like `document` and `window` are not available in Node.js. To avoid that you can put the logic inside `onMounted` hook.

ts

```
// onMounted will only be called in the client side
// so it guarantees the DOM APIs are available.

(() => {

(
, 'keydown', (
) => {

.
(
.
)
  })
})
```

## Source [​](https://vueuse.org/core/useEventListener/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useEventListener/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useEventListener/index.md)
