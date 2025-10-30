# usePrevious

**Category**: Utilities
**Export Size**: 249 B
**Last Changed**: 7 months ago

Holds the previous value of a ref.

## Demo

```
counter: 1
previous: 0
+1
```

## Usage

```ts
import { usePrevious } from '@vueuse/core'
import { shallowRef } from 'vue'

const counter = shallowRef('Hello')
const previous = usePrevious(counter)

console.log(previous.value) // undefined

counter.value = 'World'
console.log(previous.value) // Hello
```

## Type Declarations

```ts
/**
 * Holds the previous value of a ref.
 *
 * @see {@link https://vueuse.org/usePrevious}
 */
export declare function usePrevious<T>(
  value: MaybeRefOrGetter<T>,
): Readonly<ShallowRef<T | undefined>>
export declare function usePrevious<T>(
  value: MaybeRefOrGetter<T>,
  initialValue: T,
): Readonly<ShallowRef<T>>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/usePrevious/index.ts) • [Demo](https://vueuse.org/core/usePrevious/#demo) • [Docs](https://vueuse.org/core/usePrevious/)

## Contributors

* Anthony Fu
* IlyaL
* 青椒肉丝

## Changelog

*   **v12.8.0** on 3/5/2025: `7432f` - feat(types): deprecate MaybeRef and MaybeRefOrGetter in favor of Vue's native (#4636)
*   **v12.0.0-beta.1** on 11/21/2024: `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
