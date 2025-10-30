[Skip to content](https://vueuse.org/core/usemounted/#VPContent)

Return to top

# useMounted [​](https://vueuse.org/core/usemounted/\#usemounted)

Category

[Component](https://vueuse.org/functions#category=Component)

Export Size

122 B

Last Changed

2 months ago

Mounted state in ref.

## Demo [​](https://vueuse.org/core/usemounted/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMounted/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNpNjTEOwyAMRa9isdAuzR6RtD1Ab8ASEbdCCgaByYK4e4miVmz+1n/vF/EM4bZnFKNQyUQbGBJyDrAt9Jm04KTFrMm64CNDgZzw5TMxrlDhHb0D+Wh4ew/GR5SaNBlPicGmX3HqqMtVkxrOpeZtgdGFbWFsCUCtdp9L6eA7SHeeEkaQmf6pVjUc9UPYSUT9AucZTBk=)

unmounted

## Usage [​](https://vueuse.org/core/usemounted/\#usage)

ts

```
import {
} from '@vueuse/core'

const
=
()
```

Which is essentially a shorthand of:

ts

```
const
=
(false)

(() => {

.
= true
})
```

## Type Declarations [​](https://vueuse.org/core/usemounted/\#type-declarations)

ts

```
/**
 * Mounted state in ref.
 *
 * @see https://vueuse.org/useMounted
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function
():
<boolean, boolean>
```

## Source [​](https://vueuse.org/core/usemounted/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useMounted/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useMounted/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useMounted/index.md)
