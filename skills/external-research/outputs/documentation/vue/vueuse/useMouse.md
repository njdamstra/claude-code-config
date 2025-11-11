[Skip to content](https://vueuse.org/core/useMouse/#VPContent)

On this page

# useMouse [​](https://vueuse.org/core/useMouse/\#usemouse)

Category

[Sensors](https://vueuse.org/functions#category=Sensors)

Export Size

1.08 kB

Last Changed

7 months ago

Reactive mouse position

## Demo [​](https://vueuse.org/core/useMouse/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouse/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqNU01v2zAM/SuEL3EAI7kbdrBu620FusOwFfMOgkNlxmRJkCmvgeH/PsqOvzIU6EkS+fhEPpJd9GDtofUYpVHWlK6yBA2St6CEvuRFRE0RnQpd1dY4ArpahA6+NfhkfIOPLWp6fCUnSjIOepDO1LD7wHzsPZbG4W6O7cAh4yp5TYC9A8FwexYu0Cis+XgnSYszkHGL/+Xh6cvNfhW1YkehS6MbropcpS/8O+RzInGhAeJKW08pCH3dQ34aKA4zevQmEP9JoB38XQgCqCTEQQ4joYU8z2EnvWZWo3f7CQP8E3mnweszykrjebT343FztuHVJ1NQwx8r/OoNYQrkPCajXSrz95NRCodPnsX5zMAUpFCs40Cx52O/VGxvunLB9yrHK1gdGvEZpfCKZm1ajKcexXsGj1DCV1qQi0ZrihUzo8fJSN+amBxiDJZF2CDrYIKKKYQug8BLKLOvlPs5IA9GSp7ZHwmsny+/AhRZnE2I9koVmhuwKf97Rb/XWf0vQgck3AV5TiZZk2Eb0qVKbsBGqXvSO702bg7MjuP+8bbxg7C2ShDyCyCzp4+iqUqWUVwwO9qb1eG0pmHYeVE7TnPVo75nrJs5lmTeybOtYGHLjqv0ov4fGuSFSQ==)

Basic Usage

```
x: 0
y: 0
sourceType: null

```

Extractor Usage

```
x: 0
y: 0
sourceType: null

```

## Basic Usage [​](https://vueuse.org/core/useMouse/\#basic-usage)

ts

```
import {
 } from '@vueuse/core'

const {
,
,
 } =
()
```

Touch is enabled by default. To only detect mouse changes, set `touch` to `false`. The `dragover` event is used to track mouse position while dragging.

ts

```
const {
,
 } =
({
: false })
```

## Custom Extractor [​](https://vueuse.org/core/useMouse/\#custom-extractor)

It's also possible to provide a custom extractor function to get the position from the event.

TypeScript

ts

```
import type {
 } from '@vueuse/core'
import {
,
 } from '@vueuse/core'

const
 =
()

const
:
 =
 => (

 instanceof


    ? [
.
,
.
]
    : null
)

const {
,
,
 } =
({
:
,
:
 })
```

js

```
import { useMouse, useParentElement } from '@vueuse/core'
const parentEl = useParentElement()
const extractor = (event) =>
  event instanceof MouseEvent ? [event.offsetX, event.offsetY] : null
const { x, y, sourceType } = useMouse({ target: parentEl, type: extractor })
```

## Component Usage [​](https://vueuse.org/core/useMouse/\#component-usage)

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

vue

```
<template>
  <UseMouse v-slot="{
,
}">
    x: {{
}}
    y: {{
}}
  </UseMouse>
</template>
```

## Type Declarations [​](https://vueuse.org/core/useMouse/\#type-declarations)

Show Type Declarations

ts

```
export type
 = "page" | "client" | "screen" | "movement"
export type
 = "mouse" | "touch" | null
export type
 = (

: MouseEvent | Touch,
) => [
: number,
: number] | null | undefined
export interface UseMouseOptions
  extends ConfigurableWindow,
    ConfigurableEventFilter {
  /**
   * Mouse position based by page, client, screen, or relative to previous position
   *
   * @default 'page'
   */

?:
 |


  /**
   * Listen events on `target` element
   *
   * @default 'Window'
   */

?:
<Window | EventTarget | null | undefined>
  /**
   * Listen to `touchmove` events
   *
   * @default true
   */

?: boolean
  /**
   * Listen to `scroll` events on window, only effective on type `page`
   *
   * @default true
   */

?: boolean
  /**
   * Reset to initial value when `touchend` event fired
   *
   * @default false
   */

?: boolean
  /**
   * Initial values
   */

?:


}
/**
 * Reactive mouse position.
 *
 * @see https://vueuse.org/useMouse
 * @param options
 */
export declare function
(
?: UseMouseOptions): {

:
<number, number>

:
<number, number>

:
<
,
>
}
export type
 =
<typeof
>
```

## Source [​](https://vueuse.org/core/useMouse/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouse/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouse/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useMouse/index.md)
