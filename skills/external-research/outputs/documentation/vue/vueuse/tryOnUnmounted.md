[Skip to content](https://vueuse.org/shared/tryOnUnmounted/#VPContent)

On this page

# tryOnUnmounted [​](https://vueuse.org/shared/tryOnUnmounted/\#tryonunmounted)

Category

[Component](https://vueuse.org/functions#category=Component)

Export Size

144 B

Last Changed

last week

Safe `onUnmounted`. Call `onUnmounted()` if it's inside a component lifecycle, if not, do nothing

## Usage [​](https://vueuse.org/shared/tryOnUnmounted/\#usage)

ts

```
import {
} from '@vueuse/core'

(() => {

})
```

## Type Declarations [​](https://vueuse.org/shared/tryOnUnmounted/\#type-declarations)

ts

```
/**
 * Call onUnmounted() if it's inside a component lifecycle, if not, do nothing
 *
 * @param fn
 * @param target
 */
export declare function
(

:
,

?:
| null,
): void
```

## Source [​](https://vueuse.org/shared/tryOnUnmounted/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/tryOnUnmounted/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/tryOnUnmounted/index.md)
