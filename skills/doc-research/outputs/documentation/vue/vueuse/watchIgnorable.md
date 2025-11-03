[Skip to content](https://vueuse.org/shared/watchIgnorable/#VPContent)

On this page

# watchIgnorable [​](https://vueuse.org/shared/watchIgnorable/\#watchignorable)

Category

[Watch](https://vueuse.org/functions#category=Watch)

Export Size

410 B

Last Changed

3 weeks ago

Alias

`ignorableWatch`

Ignorable watch

## Demo [​](https://vueuse.org/shared/watchIgnorable/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchIgnorable/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNqFUk1rwzAM/SvCDJLS0fRcktKx02CnwnbyoanrJmGuHfyRMkL++2SnSZNusJstvfekJ6klL3W9ahwnG5IapqvaguHW1SByWWSUWEPJlsrqUittoYVrbln5Vkil86Pg0MFZqwtEO5RwhidMaR5N4KbMhVDXPT+PUEQigkqmpLEgVAHZBBZH0WLIGeU04/P0GrNDvoXKN8I/6lNuucEK2UN/MZVwk3n2zwayLcRYc9XkwnFYZnB4LdEpP4FVQMlT23SUUCoPi0Bo4SycKTcQmW/JIugwGjo4O8lspSQwwXMdL6C9l7qJZ7D2sXu1DCJ03k3ILnT+F3u5nCN7p6fe6kCY2Y8xiu5C4rcWQId9o2Ka9GvGpeLH8kstkI0/gPRUNdtPz9hAi7vrx991aeITAXF01mI3OyYq9oXn0RsIJ+Kr9q0EZNJDZzQmcmOQhcvBkVNy15nZG+XCHnE1/8iOKmEXI3vP8ZIfSD1NDy+p0Pq7KtIkvG7RWvMt+fen6c37r5/bZFak+wEaIByU)

Value: 0

Update  Ignored Update  Reset

Log

```

```

## Usage [​](https://vueuse.org/shared/watchIgnorable/\#usage)

Extended `watch` that returns extra `ignoreUpdates(updater)` and `ignorePrevAsyncUpdates()` to ignore particular updates to the source.

ts

```
import {
 } from '@vueuse/core'
import {
,
 } from 'vue'

const
 =
('foo')

const {
,
 } =
(


,

 =>
.
(`Changed to ${
}!`),
)

.
 = 'bar'
await
() // logs: Changed to bar!

(() => {

.
 = 'foobar'
})
await
() // (nothing happened)

.
 = 'hello'
await
() // logs: Changed to hello!

(() => {

.
 = 'ignored'
})

.
 = 'logged'

await
() // logs: Changed to logged!
```

## WatchOptionFlush timing [​](https://vueuse.org/shared/watchIgnorable/\#watchoptionflush-timing)

[`watchIgnorable`](https://vueuse.org/shared/watchIgnorable/) accepts the same options as `watch` and uses the same defaults. So, by default the composable works using `flush: 'pre'`.

## `ignorePrevAsyncUpdates` [​](https://vueuse.org/shared/watchIgnorable/\#ignoreprevasyncupdates)

This feature is only for async flush `'pre'` and `'post'`. If `flush: 'sync'` is used, `ignorePrevAsyncUpdates()` is a no-op as the watch will trigger immediately after each update to the source. It is still provided for sync flush so the code can be more generic.

ts

```
import {
 } from '@vueuse/core'
import {
,
 } from 'vue'

const
 =
('foo')

const {
 } =
(


,

 =>
.
(`Changed to ${
}!`),
)

.
 = 'bar'
await
() // logs: Changed to bar!

.
 = 'good'

.
 = 'by'

()

await
() // (nothing happened)

.
 = 'prev'

()

.
 = 'after'

await
() // logs: Changed to after!
```

## Recommended Readings [​](https://vueuse.org/shared/watchIgnorable/\#recommended-readings)

- [Ignorable Watch](https://patak.dev/vue/ignorable-watch.html) \- by [@patak-dev](https://github.com/patak-dev)

## Type Declarations [​](https://vueuse.org/shared/watchIgnorable/\#type-declarations)

Show Type Declarations

ts

```
export type
 = (
: () => void) => void
export type
 = () => void
export interface WatchIgnorableReturn {

:


:


:


}
export declare function
<

 extends
<
<unknown>[]>,

 extends
<boolean> = false,
>(

: [...\
],

:
<
<
>,
<
,
>>,

?:
<
>,
): WatchIgnorableReturn
export declare function
<


,

 extends
<boolean> = false,
>(

:
<
>,

:
<
,
 extends true ?
 | undefined :
>,

?:
<
>,
): WatchIgnorableReturn
export declare function
<

 extends object,

 extends
<boolean> = false,
>(

:
,

:
<
,
 extends true ?
 | undefined :
>,

?:
<
>,
): WatchIgnorableReturn
/** @deprecated use `watchIgnorable` instead */
export declare const
: typeof


```

## Source [​](https://vueuse.org/shared/watchIgnorable/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchIgnorable/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchIgnorable/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchIgnorable/index.md)
