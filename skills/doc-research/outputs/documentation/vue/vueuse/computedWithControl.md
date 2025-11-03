# computedWithControl

**Category**: Reactivity
**Export Size**: 334 B
**Last Changed**: 2 weeks ago
**Alias**: `controlledComputed`

Explicitly define the dependencies of a computed property.

## Usage

`computedWithControl` allows you to explicitly specify the dependencies that should trigger a re-evaluation of the computed property. It takes a `source` (or an array of sources) and a `getter` function. Changes to reactive variables used in the getter but not listed as sources will not cause the computed property to update.

```ts
import { ref } from 'vue'
import { computedWithControl } from '@vueuse/core'

const source = ref('foo')
const counter = ref(0)

// The computed property will only update when `source` changes, not `counter`.
const computedRef = computedWithControl(
  source, // Explicit dependency
  () => `counter: ${counter.value}`
)

console.log(computedRef.value) // 'counter: 0'

counter.value += 1
console.log(computedRef.value) // Still 'counter: 0'

source.value = 'bar' // Triggers re-evaluation
console.log(computedRef.value) // 'counter: 1'
```

## Manual Triggering

The returned computed ref includes a `trigger()` method that you can use to force a re-evaluation, even if the defined sources have not changed.

```ts
const computedRef = computedWithControl(source, () => counter.value)

counter.value = 10
console.log(computedRef.value) // Old value

computedRef.trigger() // Forces re-evaluation
console.log(computedRef.value) // 10
```

## Deep Watch

You can pass `watch` options, like `{ deep: true }`, to control the behavior of the dependency watching.

```ts
const source = ref({ nested: { value: 1 } })

const computedRef = computedWithControl(
  source,
  () => source.value.nested.value,
  { deep: true }
)

source.value.nested.value = 2 // Triggers re-evaluation
```

## Type Declarations

```ts
export declare function computedWithControl<T, S>(
  source: WatchSource<S> | WatchSource<S>[],
  fn: () => T,
  options?: WatchOptions,
): ComputedRef<T> & {
  trigger: () => void
}
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/computedWithControl/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/computedWithControl/index.md)
