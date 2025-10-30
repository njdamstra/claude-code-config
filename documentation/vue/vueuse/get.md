# get

## Description
Shorthand for accessing `ref.value`

## Usage

```ts
import { get } from '@vueuse/core'

const a = ref(42)
console.log(get(a)) // 42
```

## Type Declarations

```ts
/**
 * Shorthand for accessing `ref.value`
 */
export declare function get<T>(ref: MaybeRef<T>): T
export declare function get<T, K extends keyof T>(ref: MaybeRef<T>, key: K): T[K]
```

## Source

[Source](https://vueuse.org/shared/get/) • [Docs](https://vueuse.org/shared/get/)

## Contributors

* Anthony Fu
* RYGRIT
* Robin

## Changelog

* **v13.6.0 on 7/28/2025**
  * `2d179` - fix(types): use Vue's native MaybeRef and MaybeRefOrGetter instead (#4913)
* **v13.1.0 on 4/8/2025**
  * `c1d6e` - feat(shared): ensure return types exists (#4659)
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
