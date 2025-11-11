# useArrayUnique

**Category:** Array
**Export Size:** 219 B
**Last Changed:** 2 months ago

Reactive unique array

## Usage

### Use with array of multiple refs

```ts
import { useArrayUnique, ref } from '@vueuse/core'

const item1 = ref(0)
const item2 = ref(1)
const item3 = ref(1)
const item4 = ref(2)
const item5 = ref(3)
const list = [item1, item2, item3, item4, item5]
const result = useArrayUnique(list)
// result.value: [0, 1, 2, 3]

item5.value = 1
// result.value: [0, 1, 2]
```

### Use with reactive array

```ts
import { useArrayUnique, ref } from '@vueuse/core'

const list = ref([1, 2, 2, 3])
const result = useArrayUnique(list)
// result.value: [1, 2, 3]

list.value.push(1)
// result.value: [1, 2, 3]
```

### Use with custom function

```ts
import { useArrayUnique, ref } from '@vueuse/core'

const list = ref([
  { id: 1, name: 'foo' },
  { id: 2, name: 'bar' },
  { id: 1, name: 'baz' },
])

const result = useArrayUnique(list, (a, b) => a.id === b.id)
// result.value: [{ id: 1, name: 'foo' }, { id: 2, name: 'bar' }]

list.value.push({ id: 1, name: 'qux' })
// result.value: [{ id: 1, name: 'foo' }, { id: 2, name: 'bar' }]
```

## Type Declarations

```ts
export type UseArrayUniqueReturn<T = any> = ComputedRef<T[]>

/**
 * reactive unique array
 * @see https://vueuse.org/useArrayUnique
 * @param list - the array was called upon.
 * @param compareFn
 * @returns A computed ref that returns a unique array of items.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayUnique<T>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  compareFn?: (a: T, b: T, array: T[]) => boolean,
): UseArrayUniqueReturn<T>
```

## Source

- [Source Code](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayUnique/index.ts)
- [Documentation](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayUnique/index.md)
