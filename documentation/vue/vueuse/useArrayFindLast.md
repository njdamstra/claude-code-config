# useArrayFindLast

**Category**: Array
**Export Size**: 204 B
**Last Changed**: 3 weeks ago

Reactive `Array.findLast`.

## Usage

```ts
import { useArrayFindLast } from '@vueuse/core'

const list = [ref(1), ref(-1), ref(2)]
const positive = useArrayFindLast(list, val => val > 0)
// positive.value: 2
```

### Use with reactive array

```ts
import { useArrayFindLast } from '@vueuse/core'
import { reactive } from 'vue'

const list = reactive([-1, -2])
const positive = useArrayFindLast(list, val => val > 0)
// positive.value: undefined

list.push(10)
// positive.value: 10

list.push(5)
// positive.value: 5
```

## Type Declarations

```ts
export type UseArrayFindLastReturn <T = any> = ComputedRef <T | undefined>

/**
 * Reactive `Array.findLast`
 *
 * @see https://vueuse.org/useArrayFindLast
 * @param list - the array was called upon.
 * @param fn - a function to test each element.
 *
 * @returns the last element in the array that satisfies the provided testing function. Otherwise, undefined is returned.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayFindLast <T>(
  list: MaybeRefOrGetter <MaybeRefOrGetter <T>[]>,
  fn: (element: T, index: number, array: MaybeRefOrGetter <T>[]) => boolean,
): UseArrayFindLastReturn <T>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayFindLast/index.ts) • [Docs](https://vueuse.org/shared/useArrayFindLast/)

## Contributors

* Anthony Fu
* SerKo
* Robin
* IlyaL
* Levi (Nguyễn Lương Huy)

## Changelog

* **v13.6.0** on 7/28/2025: `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
* **v13.1.0** on 4/8/2025: `c1d6e` - feat(shared): ensure return types exists (#4659)
* **v12.8.0** on 3/5/2025: `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.3.0** on 1/2/2025: `59f75` - feat(toValue): deprecate toValue from `@vueuse/shared` in favor of Vue's native
* **v12.0.0-beta.1** on 11/21/2024: `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v10.0.0-beta.4** on 4/13/2023: `4d757` - feat(types)!: rename MaybeComputedRef to MaybeRefOrGetter
* **v10.0.0-beta.4** on 4/13/2023: `0a72b` - feat(toValue): rename resolveUnref to toValue