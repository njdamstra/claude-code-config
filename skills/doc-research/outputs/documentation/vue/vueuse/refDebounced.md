# refDebounced

**Category**: Reactivity
**Export Size**: 219 B
**Last Changed**: 2 weeks ago
**Alias**: `debouncedRef`

Debounce execution of a ref value.

## Usage

`refDebounced` creates a new ref that is a debounced version of a source ref. The debounced ref will only update after a specified delay has passed without any new changes to the source ref.

This is particularly useful for scenarios like user input, where you want to delay an action (e.g., an API call) until the user has stopped typing.

```ts
import { ref } from 'vue'
import { refDebounced, watch } from '@vueuse/core'

const input = ref('')
const debounced = refDebounced(input, 1000) // 1000ms delay

watch(debounced, (newValue) => {
  console.log(`Performing search for: ${newValue}`)
  // This will only run after the user has stopped typing for 1 second.
})
```

## Options

You can also pass an options object as the third argument, which can include a `maxWait` time, similar to Lodash's `debounce`.

```ts
const debounced = refDebounced(input, 1000, { maxWait: 5000 })
```
If there are continuous updates, the debounced ref will update at least once every 5 seconds.

## Type Declarations

```ts
/**
 * Debounce execution of a ref value.
 *
 * @see https://vueuse.org/refDebounced
 * @param value The ref to be debounced.
 * @param delay The delay in milliseconds.
 * @param options The options for the debounce.
 */
export declare function refDebounced<T>(
  value: Ref<T>,
  delay?: MaybeRefOrGetter<number>,
  options?: DebounceFilterOptions,
): Readonly<Ref<T>>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/refDebounced/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/refDebounced/index.md)
