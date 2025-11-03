# watchThrottled

Category: Watch

Export Size: 531 B

Alias: `throttledWatch`

Throttled watch.

## Usage

Similar to `watch`, but offering an extra option `throttle` which will be applied to the callback function.

```ts
import { watchThrottled } from '@vueuse/core'

watchThrottled(
  source,
  () => { console.log('changed!') },
  { throttle: 500 },
)
```

It's essentially a shorthand for the following code:

```ts
import { watch, useThrottleFn } from '@vueuse/core'

watch(
  source,
  () => { console.log('changed!') },
  {
    eventFilter: useThrottleFn(500),
  },
)
```
