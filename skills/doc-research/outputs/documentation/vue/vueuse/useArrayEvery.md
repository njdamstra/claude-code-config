# useArrayEvery

**Category**: Array
**Export Size**: 131 B
**Last Changed**: 2 months ago

Reactive `Array.every`

## Usage

### Use with array of multiple refs

```ts
import { useArrayEvery } from '@vueuse/core'

const item1 = ref(0)
const item2 = ref(2)
const item3 = ref(4)
const item4 = ref(6)
const item5 = ref(8)

const list = [item1, item2, item3, item4, item5]
const result = useArrayEvery(list, i => i % 2 === 0)

// result.value: true
item1.value = 1
// result.value: false
```

### Use with reactive array

```ts
import { useArrayEvery } from '@vueuse/core'

const list = ref()
const result = useArrayEvery(list, i => i % 2 === 0)

// result.value: true
list.value.push(9)
// result.value: false
```

## Type Declarations

```ts
export type UseArrayEveryReturn = ComputedRef<boolean>

/**
 * Reactive `Array.every`
 *
 * @see https://vueuse.org/useArrayEvery
 * @param list - the array was called upon.
 * @param fn - a function to test each element.
 *
 * @returns **true** if the `fn` function returns a **truthy** value for every element from the array. Otherwise, **false**.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayEvery<T>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  fn: (element: T, index: number, array: MaybeRefOrGetter<T>[]) => unknown,
): UseArrayEveryReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useArrayEvery/index.ts) • [Docs](https://vueuse.org/shared/useArrayEvery/)

## Contributors

* Anthony Fu
* SerKo
* Robin
* IlyaL
* Levi (Nguyễn Lương Huy)

## Changelog

*   **v13.6.0** on 7/28/2025
    *   `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
*   **v13.1.0** on 4/8/2025
    *   `c1d6e` - feat(shared): ensure return types exists (#4659)
*   **v12.8.0** on 3/5/2025
    *   `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
*   **v12.3.0** on 1/2/2025
    *   `59f75` - feat(toValue): deprecate toValue from `@vueuse/shared` in favor of Vue's native
*   **v12.0.0-beta.1** on 11/21/2024
    *   `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)