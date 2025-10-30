# useArrayIncludes

**Category**: Array
**Export Size**: 344 B
**Last Changed**: 2 months ago

Reactive `Array.includes`

## Usage

### Use with reactive array

```ts
import { useArrayIncludes } from '@vueuse/core'

const list = ref([0, 2, 4, 6, 8])
const result = useArrayIncludes(list, 10)
// result.value: false

list.value.push(10)
// result.value: true

list.value.pop()
// result.value: false
```

## Type Declarations

```ts
export type UseArrayIncludesComparatorFn<T, V> = (
  element: T,
  value: V,
  index: number,
  array: MaybeRefOrGetter<T>[],
) => boolean

export interface UseArrayIncludesOptions<T, V> {
  fromIndex?: number
  comparator?: UseArrayIncludesComparatorFn<T, V> | keyof T
}

export type UseArrayIncludesReturn = ComputedRef<boolean>

/**
 * Reactive `Array.includes`
 *
 * @see https://vueuse.org/useArrayIncludes
 *
 * @returns true if the `value` is found in the array. Otherwise, false.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayIncludes<T, V = any>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  value: MaybeRefOrGetter<V>,
  comparator?: UseArrayIncludesComparatorFn<T, V>,
): UseArrayIncludesReturn

export declare function useArrayIncludes<T, V = any>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  value: MaybeRefOrGetter<V>,
  comparator?: keyof T,
): UseArrayIncludesReturn

export declare function useArrayIncludes<T, V = any>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  value: MaybeRefOrGetter<V>,
  options?: UseArrayIncludesOptions<T, V>,
): UseArrayIncludesReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayIncludes/index.ts) • [Docs](https://vueuse.org/shared/useArrayIncludes/)

## Contributors

* Anthony Fu
* Anthony Fu
* SerKo
* Robin
* IlyaL
* 丶远方

## Changelog

* **v13.6.0** on 7/28/2025
  * `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
* **v13.1.0** on 4/8/2025
  * `c1d6e` - feat(shared): ensure return types exists (#4659)
* **v12.8.0** on 3/5/2025
  * `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.3.0** on 1/2/2025
  * `59f75` - feat(toValue): deprecate toValue from `@vueuse/shared` in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
