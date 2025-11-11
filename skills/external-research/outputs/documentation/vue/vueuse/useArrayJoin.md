# useArrayJoin

**Category**: Array
**Export Size**: 139 B
**Last Changed**: last month

Reactive `Array.join`

## Usage

### Use with array of multiple refs

```ts
import { useArrayJoin } from '@vueuse/core'

const item1 = ref('foo')
const item2 = ref(0)
const item3 = ref({ prop: 'val' })
const list = [item1, item2, item3]
const result = useArrayJoin(list)

// result.value: foo,0,[object Object]
item1.value = 'bar'
// result.value: bar,0,[object Object]
```

### Use with reactive array

```ts
import { useArrayJoin } from '@vueuse/core'

const list = ref(['string', 0, { prop: 'val' }, false, , [], null, undefined, []])
const result = useArrayJoin(list)
// result.value: string,0,[object Object],false,1,2,,,

list.value.push(true)
// result.value: string,0,[object Object],false,1,2,,,,true

list.value = [null, 'string', undefined]
// result.value: ,string,
```

### Use with reactive separator

```ts
import { useArrayJoin } from '@vueuse/core'

const list = ref(['string', 0, { prop: 'val' }])
const separator = ref()
const result = useArrayJoin(list, separator)

// result.value: string,0,[object Object]
separator.value = ''
// result.value: string0[object Object]
separator.value = '--'
// result.value: string--0--[object Object]
```

## Type Declarations

```ts
export type UseArrayJoinReturn = ComputedRef<string>

/**
 * Reactive `Array.join`
 *
 * @see https://vueuse.org/useArrayJoin
 * @param list - the array was called upon.
 * @param separator - a string to separate each pair of adjacent elements of the array. If omitted, the array elements are separated with a comma (",").
 *
 * @returns a string with all array elements joined. If arr.length is 0, the empty string is returned.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useArrayJoin(
  list: MaybeRefOrGetter<MaybeRefOrGetter<any>[]>,
  separator?: MaybeRefOrGetter<string>,
): UseArrayJoinReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useArrayJoin/index.ts) • [Docs](https://vueuse.org/shared/useArrayJoin/)

## Contributors

* Anthony Fu
* Anthony Fu
* SerKo
* Levi (Nguyễn Lương Huy)
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
* **v10.0.0-beta.4** on 4/13/2023
  * `4d757` - feat(types)!: rename MaybeComputedRef to MaybeRefOrGetter
  * `0a72b` - feat(toValue): rename resolveUnref to toValue
