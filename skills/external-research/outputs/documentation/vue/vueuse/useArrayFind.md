# useArrayFind

**Category:** Array
**Export Size:** 137 B
**Last Changed:** 2 months ago

Reactive `Array.find`.

## Usage

```ts
import { useArrayFind, ref } from '@vueuse/core'

const list = [ref(1), ref(-1), ref(2)]
const positive = useArrayFind(list, val => val > 0)
// positive.value: 1
```

### Use with reactive array

```ts
import { useArrayFind, ref } from '@vueuse/core'

const list = ref([-1, -2])
const positive = useArrayFind(list, val => val > 0)
// positive.value: undefined

list.value.push(1)
// positive.value: 1
```

## Type Declarations

```ts
export type UseArrayFindReturn<T = any> = ComputedRef<T | undefined>

/**
 * Reactive `Array.find`
 *
 * @see https://vueuse.org/useArrayFind
 * @param list - the array was called upon.
 * @param fn - a function to test each element.
 *
 * @returns the first element in the array that satisfies the provided testing function. Otherwise, undefined is returned.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayFind<T>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  fn: (element: T, index: number, array: MaybeRefOrGetter<T>[]) => boolean,
): UseArrayFindReturn<T>
```

## Source

- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayFind/index.ts)
- [Documentation](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayFind/index.md)
