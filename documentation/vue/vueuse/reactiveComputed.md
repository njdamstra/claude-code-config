# reactiveComputed

**Category:** Reactivity
**Export Size:** 288 B
**Last Changed:** 6 months ago

Computed reactive object. Instead of returning a ref that `computed` does, `reactiveComputed` returns a reactive object.

## Usage

```ts
import { reactiveComputed } from '@vueuse/core'

const obj = reactiveComputed(() => {
  return {
    foo: 'bar',
    bar: 'baz',
  }
})

obj.bar // 'baz'
```

## Type Declarations

```ts
export type ReactiveComputed<T extends object> = UnwrapNestedRefs<T>

/**
 * Computed reactive object.
 */
export declare function reactiveComputed<T extends object>(
  fn: ComputedGetter<T>
): ReactiveComputed<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/reactiveComputed/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/reactiveComputed/index.md)
