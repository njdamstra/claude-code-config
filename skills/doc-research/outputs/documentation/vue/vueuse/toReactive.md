# toReactive

**Category:** Reactivity
**Export Size:** 269 B
**Last Changed:** 7 months ago

Converts ref to reactive. Also made possible to create a "swapable" reactive object.

## Usage

```ts
import { toReactive } from '@vueuse/core'
import { ref } from 'vue'

const refState = ref({ foo: 'bar' })

console.log(refState.value.foo) // => 'bar'

const state = toReactive(refState) // <--

console.log(state.foo) // => 'bar'

refState.value = { bar: 'foo' }

console.log(state.foo) // => undefined

console.log(state.bar) // => 'foo'
```

## Type Declarations

```ts
/**
 * Converts ref to reactive.
 *
 * @see https://vueuse.org/toReactive
 * @param objectRef A ref of object
 */
export declare function toReactive<T extends object>(
  objectRef: Ref<T>
): UnwrapNestedRefs<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/toReactive/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/toReactive/index.md)
