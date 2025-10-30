[Skip to content](https://vueuse.org/shared/watchOnce/#VPContent)

On this page

# watchOnce [​](https://vueuse.org/shared/watchOnce/\#watchonce)

Category

[Watch](https://vueuse.org/functions#category=Watch)

Export Size

123 B

Last Changed

2 weeks ago

Shorthand for watching value with `{ once: true }`. Once the callback fires once, the watcher will be stopped. See [Vue's docs](https://vuejs.org/guide/essentials/watchers.html#once-watchers) for full details.

## Usage [​](https://vueuse.org/shared/watchOnce/\#usage)

Similar to `watch`, but with `{ once: true }`

ts

```
import {
 } from '@vueuse/core'

(source, () => {
  // triggers only once

.
('source changed!')
})
```

## Type Declarations [​](https://vueuse.org/shared/watchOnce/\#type-declarations)

ts

```
export declare function
<
 extends
<
<unknown>[]>>(

: [...\
],

:
<
<
>,
<
, true>>,

?:
<
<true>, "once">,
):

export declare function
<
>(

:
<
>,

:
<
,
 | undefined>,

?:
<
<true>, "once">,
):

export declare function
<
 extends object>(

:
,

:
<
,
 | undefined>,

?:
<
<true>, "once">,
):


```

## Source [​](https://vueuse.org/shared/watchOnce/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchOnce/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchOnce/index.md)
