# createUnrefFn

**Category**: Utilities
**Export Size**: 101 B
**Last Changed**: last month
**Related**: [reactify](reactify.md)

Make a plain function accepting ref and raw values as arguments. Returns the same value the unconverted function returns, with proper typing.

## TIP

Make sure you're using the right tool for the job. Using reactify might be more pertinent in some cases where you want to evaluate the function on each changes of it's arguments.

## Usage

```ts
import { createUnrefFn } from '@vueuse/core'
import { shallowRef } from 'vue'

const url = shallowRef('https://httpbin.org/post')
const data = shallowRef({ foo: 'bar' })

function post(url, data) {
  return fetch(url, { data })
}

const unrefPost = createUnrefFn(post)

post(url, data) /* ❌ Will throw an error because the arguments are refs */

unrefPost(url, data) /* ✔️ Will Work because the arguments will be auto unref */
```

## Type Declarations

```ts
export type UnrefFn < T > = T extends (... args : infer A ) => infer R ? ( ... args : { [ K in keyof A ]: MaybeRef < A [ K ]> } ) => R : never

/**
 * Make a plain function accepting ref and raw values as arguments.
 * Returns the same value the unconverted function returns, with proper typing.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function createUnrefFn < T extends Function>( fn : T ): UnrefFn < T >
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/createUnrefFn/index.ts) • [Docs](https://vueuse.org/shared/createUnrefFn/)

## Contributors

* Anthony Fu
* Anthony Fu
* IlyaL
* SerKo
* Stanley Horwood

## Changelog

* **v13.6.0** on 7/28/2025
  * `d32f8` - refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)
* **v12.8.0** on 3/5/2025
  * `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
* **v12.3.0** on 1/2/2025
  * `59f75` - feat(toValue): deprecate toValue from `@vueuse/shared` in favor of Vue's native
