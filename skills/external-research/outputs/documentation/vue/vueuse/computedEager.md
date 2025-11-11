# computedEager

**Category**: Reactivity
**Export Size**: 231 B
**Last Changed**: 2 weeks ago

Eager computed without lazy evaluation.

> **Deprecation Notice:** As of Vue 3.4, the native `computed` function has been optimized to prevent unnecessary updates if the new value is identical to the old one. This makes `computedEager` less necessary, and it is being deprecated in future versions of VueUse.

## Usage

`computedEager` is a variant of `computed` that always keeps itself up-to-date. It is not lazy and will be computed immediately after creation and whenever its dependencies change.

```ts
import { computedEager } from '@vueuse/core'
import { ref } from 'vue'

const a = ref(1)
const b = ref(2)

const sum = computedEager(() => {
  console.log('Evaluating...')
  return a.value + b.value
})
// 'Evaluating...' is logged immediately

console.log(sum.value) // 3

a.value = 2
// 'Evaluating...' is logged again, even if `sum` is not accessed
```

## Performance

While standard `computed` is often more performant for complex calculations due to its lazy evaluation, `computedEager` can offer performance benefits in specific scenarios. By eagerly calculating and comparing the new value with the previous one, it can prevent unnecessary re-renders of components if the computed value hasn't actually changed. It's generally recommended for simple computations.

## Type Declarations

```ts
/**
 * Eager computed without lazy evaluation.
 *
 * @see https://vueuse.org/computedEager
 * @param fn A getter function that returns the value for the computed property.
 * @param options Watch options.
 */
export declare function computedEager<T>(
  fn: () => T,
  options?: WatchOptions,
): Readonly<Ref<T>>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/computedEager/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/computedEager/index.md)
