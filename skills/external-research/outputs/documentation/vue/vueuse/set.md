# set

**Category**: Utilities
**Export Size**: 127 B
**Last Changed**: 10 months ago

Shorthand for `ref.value = x`

## Usage

```ts
import { set } from '@vueuse/core'

const a = ref(0)
set(a, 1)
console.log(a.value) // 1
```

## Type Declarations

```ts
export declare function set < T >( ref : Ref < T >, value : T ): void
export declare function set < O extends object, K extends keyof O >( target : O , key : K , value : O [ K ], ): void
```

## Source

[Source](https://vueuse.org/shared/set/) • [Docs](https://vueuse.org/shared/set/)

## Contributors

* Anthony Fu
* Anthony Fu

## Changelog

* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
