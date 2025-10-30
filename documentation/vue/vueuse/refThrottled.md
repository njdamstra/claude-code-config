# refThrottled

**Category**: Reactivity
**Export Size**: 219 B
**Last Changed**: 2 weeks ago
**Alias**: `throttledRef`

Throttle changing of a ref value.

## Usage

`refThrottled` creates a new ref that is a throttled version of a source ref. The throttled ref will only update at most once per the specified time delay.

This is useful for rate-limiting updates on events like resizing or scrolling.

```ts
import { ref } from 'vue'
import { refThrottled, watch } from '@vueuse/core'

const input = ref('')
const throttled = refThrottled(input, 1000) // 1000ms delay

watch(throttled, (newValue) => {
  console.log(`Input is: ${newValue}`)
  // This will only run at most once every second.
})
```

## Options

You can also pass `trailing` and `leading` options to control the behavior of the throttle.

- `trailing` (default: `true`): If `true`, the throttled ref will update with the last value after the delay has passed.
- `leading` (default: `true`): If `true`, the throttled ref will update immediately with the first value when it changes.

```ts
const throttled = refThrottled(input, 1000, true, false) // trailing: true, leading: false
```

## Type Declarations

```ts
/**
 * Throttle changing of a ref value.
 *
 * @see https://vueuse.org/refThrottled
 * @param value The ref to be throttled.
 * @param delay The delay in milliseconds.
 * @param trailing
 * @param leading
 */
export declare function refThrottled<T>(
  value: Ref<T>,
  delay?: MaybeRefOrGetter<number>,
  trailing?: boolean,
  leading?: boolean,
): Readonly<Ref<T>>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/refThrottled/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/refThrottled/index.md)
