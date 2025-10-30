# createRef

**Category**: Reactivity
**Export Size**: 114 B
**Last Changed**: 2 weeks ago

Returns a `deepRef` or `shallowRef` depending on the `deep` param.

## Usage

`createRef` is a utility to create a reactive reference that can be either deep (like `ref`) or shallow (like `shallowRef`) based on a boolean parameter.

By default, it creates a `shallowRef`.

```ts
import { createRef } from '@vueuse/core'
import { isShallow } from 'vue'

// Creates a shallowRef by default
const shallowData = createRef({ count: 1 })
console.log(isShallow(shallowData)) // true

// To create a deep ref, pass `true` as the second argument
const deepData = createRef({ count: 1 }, true)
console.log(isShallow(deepData)) // false
```

This can be useful for explicitly controlling the reactivity depth of a reference in a more declarative way.

## Type Declarations

```ts
/**
 * Returns a deepRef or shallowRef depending on the deep param.
 *
 * @see https://vueuse.org/createRef
 * @param initialValue
 * @param deep
 */
export declare function createRef<T>(
  initialValue: T,
  deep?: boolean,
): Ref<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/createRef/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/createRef/index.md)
