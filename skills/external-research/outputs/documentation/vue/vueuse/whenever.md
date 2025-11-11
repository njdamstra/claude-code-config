[Skip to content](https://vueuse.org/shared/whenever/#VPContent)

On this page

# whenever [​](https://vueuse.org/shared/whenever/\#whenever)

Category

[Watch](https://vueuse.org/functions#category=Watch)

Export Size

173 B

Last Changed

10 months ago

Shorthand for watching value to be truthy.

## Usage [​](https://vueuse.org/shared/whenever/\#usage)

js

```
import { useAsyncState, whenever } from '@vueuse/core'

const { state, isReady } = useAsyncState(
  fetch('https://jsonplaceholder.typicode.com/todos/1').then(t => t.json()),
  {},
)

whenever(isReady, () => console.log(state))
```

ts

```
// this

(ready, () =>
.
(state))

// is equivalent to:

(ready, (
) => {
  if (
)

.
(state)
})
```

### Callback Function [​](https://vueuse.org/shared/whenever/\#callback-function)

Same as `watch`, the callback will be called with `cb(value, oldValue, onInvalidate)`.

ts

```

(height, (
,
) => {
  if (
 >
)

.
(`Increasing height by ${
 -
}`)
})
```

### Computed [​](https://vueuse.org/shared/whenever/\#computed)

Same as `watch`, you can pass a getter function to calculate on each change.

ts

```
// this

(
  () => counter.value === 7,
  () =>
.
('counter is 7 now!'),
)
```

### Options [​](https://vueuse.org/shared/whenever/\#options)

Options and defaults are same with `watch`.

ts

```
// this

(
  () => counter.value === 7,
  () =>
.
('counter is 7 now!'),
  {
: 'sync' },
)
```

## Type Declarations [​](https://vueuse.org/shared/whenever/\#type-declarations)

ts

```
export interface WheneverOptions extends WatchOptions {
  /**
   * Only trigger once when the condition is met
   *
   * Override the `once` option in `WatchOptions`
   *
   * @default false
   */

?: boolean
}
/**
 * Shorthand for watching value to be truthy
 *
 * @see https://vueuse.org/whenever
 */
export declare function
<
>(

:
<
 | false | null | undefined>,

:
<
>,

?: WheneverOptions,
):


```

## Source [​](https://vueuse.org/shared/whenever/\#source)

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/whenever/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/whenever/index.md)
