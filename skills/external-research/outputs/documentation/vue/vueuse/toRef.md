# toRef

**Category**: Reactivity
**Export Size**: 181 B
**Last Changed**: 2 weeks ago

Normalize value/ref/getter to ref or computed.

## Usage

The `toRef` utility from VueUse provides a consistent way to work with reactive values by normalizing a value, an existing ref, or a getter function into a ref.

- If you pass a plain value, it creates a new ref.
- If you pass an existing ref, it returns that ref.
- If you pass a getter function, it creates a computed ref.

```ts
import { toRef } from '@vueuse/core'
import { ref } from 'vue'

const plainValue = 1
const existingRef = ref(2)
const getter = () => 3

const ref1 = toRef(plainValue) // creates a new ref, ref1.value is 1
const ref2 = toRef(existingRef) // returns the existing ref, ref2.value is 2
const ref3 = toRef(getter) // creates a computed ref, ref3.value is 3
```

This is different from Vue's native `toRef`, which is primarily used to create a ref for a property on a source reactive object.

## Type Declarations

```ts
/**
 * Normalize value/ref/getter to ref or computed.
 *
 * @see https://vueuse.org/toRef
 * @param r
 */
export declare function toRef<T>(
  r: MaybeRefOrGetter<T>,
): Ref<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/toRef/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/toRef/index.md)
