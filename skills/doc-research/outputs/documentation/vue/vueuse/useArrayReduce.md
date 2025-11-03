# useArrayReduce

**Category:** Array
**Export Size:** 183 B
**Last Changed:** 2 months ago

Reactive `Array.reduce`.

## Usage

```ts
import { useArrayReduce, ref } from '@vueuse/core'

const sum = useArrayReduce([ref(1), ref(2), ref(3)], (sum, val) => sum + val)
// sum.value: 6
```

### Use with reactive array

```ts
import { useArrayReduce, ref } from '@vueuse/core'

const list = ref([1, 2])
const sum = useArrayReduce(list, (sum, val) => sum + val)

list.value.push(3)
// sum.value: 6
```

### Use with initialValue

```ts
import { useArrayReduce, ref } from '@vueuse/core'

const list = ref([{ num: 1 }, { num: 2 }])
const sum = useArrayReduce(list, (sum, val) => sum + val.num, 0)
// sum.value: 3
```

## Type Declarations

```ts
export type UseArrayReducer<PV, CV, R> = (
  previousValue: PV,
  currentValue: CV,
  currentIndex: number,
) => R

/**
 * Reactive `Array.reduce`
 *
 * @see https://vueuse.org/useArrayReduce
 * @param list - the array was called upon.
 * @param reducer - a "reducer" function.
 *
 * @returns the value that results from running the "reducer" callback function to completion over the entire array.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayReduce<T>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  reducer: UseArrayReducer<T, T, T>,
): ComputedRef<T>

/**
 * Reactive `Array.reduce`
 *
 * @see https://vueuse.org/useArrayReduce
 * @param list - the array was called upon.
 * @param reducer - a "reducer" function.
 * @param initialValue - a value to be initialized the first time when the callback is called.
 *
 * @returns the value that results from running the "reducer" callback function to completion over the entire array.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayReduce<T, U>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  reducer: UseArrayReducer<U, T, U>,
  initialValue: MaybeRefOrGetter<U>,
): ComputedRef<U>
```

## Source

- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayReduce/index.ts)
- [Documentation](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayReduce/index.md)
