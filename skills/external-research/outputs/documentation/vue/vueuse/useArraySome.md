# useArraySome

**Category**: Array
**Export Size**: 135 B
**Last Changed**: 2 months ago

Reactive `Array.some`

## Usage

### Use with array of multiple refs

```ts
import { useArraySome } from '@vueuse/core'

const item1 = ref(0)
const item2 = ref(2)
const item3 = ref(4)
const item4 = ref(6)
const item5 = ref(8)

const list = [item1, item2, item3, item4, item5]
const result = useArraySome(list, i => i > 10)

// result.value: false

item1.value = 11

// result.value: true
```

### Use with reactive array

```ts
import { useArraySome } from '@vueuse/core'

const list = ref([1, 2, 3, 4])
const result = useArraySome(list, i => i > 10)

// result.value: false

list.value.push(11)

// result.value: true
```

## Type Declarations

```ts
export type UseArraySomeReturn = ComputedRef<boolean>

/**
 * Reactive `Array.some`
 *
 * @see https://vueuse.org/useArraySome
 * @param list - the array was called upon.
 * @param fn - a function to test each element.
 *
 * @returns **true** if the `fn` function returns a **truthy** value for any element from the array. Otherwise, **false**.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArraySome<T>(
  list: MaybeRefOrGetter<MaybeRefOrGetter<T>[]>,
  fn: (element: T, index: number, array: MaybeRefOrGetter<T>[]) => unknown,
): UseArraySomeReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useArraySome/index.ts) • [Docs](https://vueuse.org/shared/useArraySome/)

## Contributors

* Anthony Fu
* SerKo
* Robin
* IlyaL
* Levi (Nguyễn Lương Huy)

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
