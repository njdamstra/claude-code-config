[Skip to content](https://vueuse.org/core/useRefHistory/#VPContent)

On this page

# useRefHistory [​](https://vueuse.org/core/useRefHistory/\#userefhistory)

Category

[State](https://vueuse.org/functions#category=State)

Export Size

1.2 kB

Last Changed

2 weeks ago

Related

[`useDebouncedRefHistory`](https://vueuse.org/core/useDebouncedRefHistory/) [`useManualRefHistory`](https://vueuse.org/core/useManualRefHistory/) [`useThrottledRefHistory`](https://vueuse.org/core/useThrottledRefHistory/)

Track the change history of a ref, also provides undo and redo functionality

[Learn useRefHistory with this FREE video lesson from Vue School!](https://vueschool.io/lessons/ref-history-with-vueuse?friend=vueuse)

## Demo [​](https://vueuse.org/core/useRefHistory/\#demo)

[source](https://github.com/vueuse/vueuse/blob/main/packages/core/useRefHistory/demo.vue) [playground (beta)](https://playground.vueuse.org/?vueuse=14.0.0-beta.1#eNp1U02PmzAQ/StTLiHaENJVe0Ek2qo5pIe9rNRDJS6OcRor/kD2kFUU8d87dgiF/eAA/njzZubN45r8aJrluRVJkZSeO9kgeIFtA4qZv+sqQV8lm8pI3ViHcIWDdZrhlqFYQOvFizjspEfrLtDBwVkNsydio5ucWydmo0h/ZErZV4oYoIQkRGUOreEorenZU/QFmFbvhZvDtTIAjkpy9+uQPDXiFeIC/XwBsz/0ZM/P2XYLu12hdeH9bF6ZLrBzazwCt61BWI/KSFeEGCWXhqd9vghenplqxcNDTzPgavERLssm6a5wvOlCMpnaLqiF8ObM/I5bWrzQCUmxnuqYRs4FEXDWMC7xUsDXFXRUa5nfJkTzoA0K3ShSgHYAZS3Pm58hsoArhcZmu67Mw3kE7FtEKv6JK8lPNNjYbZwt0PPLcCe0MBix+Q38cWBsfwjcik8DfcMMcMW8pyitskcKyqkHOp4wF7X0bK9ETbAvvUBV8j9h0G+UMV5/VuVbrqDxmCtMYcQVr99zuenXWFL5bvNUSS1R1IA2zMUJ8nntgzXJGNrOyzzC70MZBOC2FtleWX4Cjdm3oYQIOmcUH4ZCJrwbh8ouTuISTpcotfDIdDOEvdXX3rySfV+Bdtkj1WMw09ZQ9xsyRP9jjZjm0R7DMN4zThggejx6Sy69YY0/2mAwmHKM/Navynzk06T7BzbUgUM=)

Count: 0

Increment  Decrement / Undo  Redo

History (limited to 10 records for demo)

2025-10-01 17:05:42{ value: 0 }

## Usage [​](https://vueuse.org/core/useRefHistory/\#usage)

ts

```
import {
} from '@vueuse/core'
import {
} from 'vue'

const
=
(0)
const {
,
,
} =
(
)
```

Internally, `watch` is used to trigger a history point when the ref value is modified. This means that history points are triggered asynchronously batching modifications in the same "tick".

ts

```

.
+= 1

await
()

.
(
.
)
/* [\
  { snapshot: 1, timestamp: 1601912898062 },\
  { snapshot: 0, timestamp: 1601912898061 }\
] */
```

You can use `undo` to reset the ref value to the last history point.

ts

```

.
(
.
) // 1

()

.
(
.
) // 0
```

### Objects / arrays [​](https://vueuse.org/core/useRefHistory/\#objects-arrays)

When working with objects or arrays, since changing their attributes does not change the reference, it will not trigger the committing. To track attribute changes, you would need to pass `deep: true`. It will create clones for each history record.

ts

```
const
=
({

: 1,

: 'bar',
})

const {
,
,
} =
(
, {

: true,
})

.
.
= 2

await
()

.
(
.
)
/* [\
  { snapshot: { foo: 2, bar: 'bar' } },\
  { snapshot: { foo: 1, bar: 'bar' } }\
] */
```

#### Custom Clone Function [​](https://vueuse.org/core/useRefHistory/\#custom-clone-function)

[`useRefHistory`](https://vueuse.org/core/useRefHistory/) only embeds the minimal clone function `x => JSON.parse(JSON.stringify(x))`. To use a full featured or custom clone function, you can set up via the `clone` options.

For example, using [structuredClone](https://developer.mozilla.org/en-US/docs/Web/API/structuredClone):

ts

```
import {
} from '@vueuse/core'

const
=
(target, {
:
})
```

Or by using [lodash's `cloneDeep`](https://lodash.com/docs/4.17.15#cloneDeep):

ts

```
import {
} from '@vueuse/core'
import {
} from 'lodash-es'

const
=
(target, {
:
})
```

Or a more lightweight [`klona`](https://github.com/lukeed/klona):

ts

```
import {
} from '@vueuse/core'
import {
} from 'klona'

const
=
(target, {
:
})
```

#### Custom Dump and Parse Function [​](https://vueuse.org/core/useRefHistory/\#custom-dump-and-parse-function)

Instead of using the `clone` options, you can pass custom functions to control the serialization and parsing. In case you do not need history values to be objects, this can save an extra clone when undoing. It is also useful in case you want to have the snapshots already stringified to be saved to local storage for example.

ts

```
import {
} from '@vueuse/core'

const
=
(target, {

:
.
,

:
.
,
})
```

### History Capacity [​](https://vueuse.org/core/useRefHistory/\#history-capacity)

We will keep all the history by default (unlimited) until you explicitly clear them up, you can set the maximal amount of history to be kept by `capacity` options.

ts

```
const
=
(target, {

: 15, // limit to 15 history records
})

.
() // explicitly clear all the history
```

### History WatchOptionFlush Timing [​](https://vueuse.org/core/useRefHistory/\#history-watchoptionflush-timing)

From [Vue's documentation](https://vuejs.org/guide/essentials/watchers.html#callback-flush-timing): Vue's reactivity system buffers invalidated effects and flush them asynchronously to avoid unnecessary duplicate invocation when there are many state mutations happening in the same "tick".

In the same way as `watch`, you can modify the flush timing using the `flush` option.

ts

```
const
=
(target, {

: 'sync', // options 'pre' (default), 'post' and 'sync'
})
```

The default is `'pre'`, to align this composable with the default for Vue's watchers. This also helps to avoid common issues, like several history points generated as part of a multi-step update to a ref value that can break invariants of the app state. You can use `commit()` in case you need to create multiple history points in the same "tick"

ts

```
const
=
(0)
const {
,
} =
(
)

.
= 1

()

.
= 2

()

.
(
.
)
/* [\
  { snapshot: 2 },\
  { snapshot: 1 },\
  { snapshot: 0 },\
] */
```

On the other hand, when using flush `'sync'`, you can use `batch(fn)` to generate a single history point for several sync operations

ts

```
const
=
({
: [],
: 1 })
const {
,
} =
(
, {
: 'sync' })

(() => {

.
.
.
('Lena')

.
.
++
})

.
(
.
)
/* [\
  { snapshot: { names: [ 'Lena' ], version: 2 },\
  { snapshot: { names: [], version: 1 },\
] */
```

If `{ flush: 'sync', deep: true }` is used, `batch` is also useful when doing a mutable `splice` in an array. `splice` can generate up to three atomic operations that will be pushed to the ref history.

ts

```
const
=
([1, 2, 3])
const {
,
} =
(
, {
: true,
: 'sync' })

(() => {

.
.
(1, 1) // batch ensures only one history point is generated
})
```

Another option is to avoid mutating the original ref value using `arr.value = [...arr.value].splice(1,1)`.

## Recommended Readings [​](https://vueuse.org/core/useRefHistory/\#recommended-readings)

- [History and Persistence](https://patak.dev/vue/history-and-persistence.html) \- by [@patak-dev](https://github.com/patak-dev)

## Type Declarations [​](https://vueuse.org/core/useRefHistory/\#type-declarations)

Show Type Declarations

ts

```
export interface
<
,
=
>
  extends ConfigurableEventFilter {
  /**
   * Watch for deep changes, default to false
   *
   * When set to true, it will also create clones for values store in the history
   *
   * @default false
   */

?: boolean
  /**
   * The flush option allows for greater control over the timing of a history point, default to 'pre'
   *
   * Possible values: 'pre', 'post', 'sync'
   * It works in the same way as the flush option in watch and watch effect in vue reactivity
   *
   * @default 'pre'
   */

?:


  /**
   * Maximum number of history to be kept. Default to unlimited.
   */

?: number
  /**
   * Clone when taking a snapshot, shortcut for dump: JSON.parse(JSON.stringify(value)).
   * Default to false
   *
   * @default false
   */

?: boolean |
<
>
  /**
   * Serialize data into the history
   */

?: (
:
) =>


  /**
   * Deserialize data from the history
   */

?: (
:
) =>

  /**
   * Function to determine if the commit should proceed
   * @param oldValue Previous value
   * @param newValue New value
   * @returns boolean indicating if commit should proceed
   */

?: (
:
| undefined,
:
) => boolean
}
export interface
<
,
>
  extends UseManualRefHistoryReturn<
,
> {
  /**
   * A ref representing if the tracking is enabled
   */

:
<boolean>
  /**
   * Pause change tracking
   */

: () => void
  /**
   * Resume change tracking
   *
   * @param [commit] if true, a history record will be create after resuming
   */

: (
?: boolean) => void
  /**
   * A sugar for auto pause and auto resuming within a function scope
   *
   * @param fn
   */

: (
: (
:
) => void) => void
  /**
   * Clear the data and stop the watch
   */

: () => void
}
/**
 * Track the change history of a ref, also provides undo and redo functionality.
 *
 * @see https://vueuse.org/useRefHistory
 * @param source
 * @param options
 */
export declare function
<
,
=
>(

:
<
>,

?:
<
,
>,
):
<
,
>
```

## Source [​](https://vueuse.org/core/useRefHistory/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useRefHistory/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useRefHistory/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useRefHistory/index.md)

## Contributors [​](https://vueuse.org/core/useRefHistory/\#contributors)

![](https://gravatar.com/avatar/616389b9fc3c3c92d244e2639418f0c5?d=retro) Anthony Fu

![](https://gravatar.com/avatar/f35f879ccab422c2e22902930cc7a5ab?d=retro) Matias Capeletto

![](https://gravatar.com/avatar/10af285c4d864f57c5baefa1bcc05ed2?d=retro) Anthony Fu

![](https://gravatar.com/avatar/ea03a6ddeec93e6914335dfc99aefc62?d=retro) Vida Xie

![](https://gravatar.com/avatar/99eb998777e92818fc1e4eacb5179fb3?d=retro) Arthur Darkstone

![](https://gravatar.com/avatar/b1f73ba4300d063a1ccc27a8e3068d57?d=retro) SerKo

![](https://gravatar.com/avatar/46f3527083016d732d6846ca84a8fb94?d=retro) IlyaL

![](https://gravatar.com/avatar/2856a8a5677e32ac17d438c07399007f?d=retro) Jonathan Schneider

![](https://gravatar.com/avatar/7a1806b5ad96f54dbdb5e593cef7cb51?d=retro) Robin

![](https://gravatar.com/avatar/1a35762c4e5869c2ab4feaf3354660a7?d=retro) IlyaL

![](https://gravatar.com/avatar/0ee529578c8d69092ad8808c11d9a215?d=retro) Lov\`u\`e

![](https://gravatar.com/avatar/30a88958bc6473e983d6261158fe03f3?d=retro) Kyrie890514

![](https://gravatar.com/avatar/21cc105fe55fff579c4ce9d3f0c7baf7?d=retro) sun0day

![](https://gravatar.com/avatar/552806e0e4cad0d086b19c33e83fbe87?d=retro) Eduardo Wesley

![](https://gravatar.com/avatar/34cc2a5407b17bea233fe61940d0b047?d=retro) vaakian X

![](https://gravatar.com/avatar/0f9dcba0e769292ec5c8aa7efc226a4c?d=retro) Hollis Wu

![](https://gravatar.com/avatar/32ac938937f01c0d0198b70219e12027?d=retro) Bruno Perel

![](https://gravatar.com/avatar/d2eccc131bb7a5815d1ef3695ad30b04?d=retro) wheat

![](https://gravatar.com/avatar/f38aeb1791e2072fbfc867bbb2e3f161?d=retro) webfansplz

![](https://gravatar.com/avatar/641bccaf505f9515210e343adab90ca5?d=retro) Roman Harmyder

![](https://gravatar.com/avatar/11e362516e144541907475ff1dbcea6b?d=retro) Alex Kozack

![](https://gravatar.com/avatar/77b8ac226fff6d2ac09e16d547cd9ac5?d=retro) Antério Vieira

## Changelog [​](https://vueuse.org/core/useRefHistory/\#changelog)

[`v13.4.0`](https://github.com/vueuse/vueuse/releases/tag/v13.4.0) on 6/19/2025

[`18acf`](https://github.com/vueuse/vueuse/commit/18acfabfd31ad1c1ecc28320b2ece4fcba65f12e) \- feat: add `shouldCommit` ( [#4471](https://github.com/vueuse/vueuse/issues/4471))

[`v12.0.0-beta.1`](https://github.com/vueuse/vueuse/releases/tag/v12.0.0-beta.1) on 11/21/2024

[`0a9ed`](https://github.com/vueuse/vueuse/commit/0a9ed589ab0e3a4aa8c7b7a4292757947378c14c) \- feat!: drop Vue 2 support, optimize bundles and clean up ( [#4349](https://github.com/vueuse/vueuse/issues/4349))

[`v10.8.0`](https://github.com/vueuse/vueuse/releases/tag/v10.8.0) on 2/20/2024

[`a086e`](https://github.com/vueuse/vueuse/commit/a086e8b6619c2fc3ec3a25bfbed7b5dce2f46787) \- fix: stricter types
