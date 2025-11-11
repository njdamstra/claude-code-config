[Skip to content](https://vueuse.org/shared/tryOnMounted/#VPContent)

On this page

# tryOnMounted [​](https://vueuse.org/shared/tryOnMounted/\#tryonmounted)

Category

[Component](https://vueuse.org/functions#category=Component)

Export Size

164 B

Last Changed

last week

Safe `onMounted`. Call `onMounted()` if it's inside a component lifecycle, if not, just call the function

## Usage [​](https://vueuse.org/shared/tryOnMounted/\#usage)

ts

```
import {
} from '@vueuse/core'

(() => {

})
```

## Type Declarations [​](https://vueuse.org/shared/tryOnMounted/\#type-declarations)

ts

```
/**
 * Call onMounted() if it's inside a component lifecycle, if not, just call the function
 *
 * @param fn
 * @param sync if set to false, it will run in the nextTick() of Vue
 * @param target
 */
export declare function
(

:
,

?: boolean,

?:
| null,
): void
```

## Source [​](https://vueuse.org/shared/tryOnMounted/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/tryOnMounted/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/tryOnMounted/index.md)
