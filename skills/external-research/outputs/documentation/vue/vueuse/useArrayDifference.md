# useArrayDifference

**Category:** Array
**Export Size:** 301 B
**Last Changed:** 2 months ago

Reactive get array difference of two arrays.

By default, it returns the difference of the first array from the second array, so call `A \ B`, [Relative Complement](https://en.wikipedia.org/wiki/Complement_(set_theory)) of B in A.

You can pass the `symmetric` option to get the [Symmetric difference](https://en.wikipedia.org/wiki/Symmetric_difference) of two arrays `A △ B`.

## Usage

### Use with reactive array

```ts
import { useArrayDifference, ref } from '@vueuse/core'

const list1 = ref([0, 1, 2, 3, 4, 5])
const list2 = ref([4, 5, 6])
const result = useArrayDifference(list1, list2)
// result.value: [0, 1, 2, 3]

list2.value = [0, 1, 2]
// result.value: [3, 4, 5]
```

### Use with reactive array and use function comparison

```ts
import { useArrayDifference, ref } from '@vueuse/core'

const list1 = ref([{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }])
const list2 = ref([{ id: 4 }, { id: 5 }, { id: 6 }])

const result = useArrayDifference(list1, list2, (a, b) => a.id === b.id)
// result.value: [{ id: 1 }, { id: 2 }, { id: 3 }]
```

### Symmetric Difference

This composable also supports [Symmetric difference](https://en.wikipedia.org/wiki/Symmetric_difference) by passing the `symmetric` option.

```ts
import { useArrayDifference, ref } from '@vueuse/core'

const list1 = ref([{ id: 1 }, { id: 2 }, { id: 3 }, { id: 4 }, { id: 5 }])
const list2 = ref([{ id: 4 }, { id: 5 }, { id: 6 }])

const result = useArrayDifference(
  list1,
  list2,
  (a, b) => a.id === b.id,
  { symmetric: true }
)
// result.value: [{ id: 1 }, { id: 2 }, { id: 3 }, { id: 6 }]
```

## Type Declarations

```ts
export interface UseArrayDifferenceOptions {
  /**
   * Returns asymmetric difference
   *
   * @see https://en.wikipedia.org/wiki/Symmetric_difference
   * @default false
   */
  symmetric?: boolean
}

export type UseArrayDifferenceReturn<T = any> = ComputedRef<T[]>

export declare function useArrayDifference<T>(
  list: MaybeRefOrGetter<T[]>,
  values: MaybeRefOrGetter<T[]>,
  key?: keyof T,
  options?: UseArrayDifferenceOptions,
): UseArrayDifferenceReturn<T>

export declare function useArrayDifference<T>(
  list: MaybeRefOrGetter<T[]>,
  values: MaybeRefOrGetter<T[]>,
  compareFn?: (a: T, b: T) => boolean,
  options?: UseArrayDifferenceOptions,
): UseArrayDifferenceReturn<T>
```

## Source

- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayDifference/index.ts)
- [Documentation](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayDifference/index.md)
