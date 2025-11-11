# refWithControl

**Category**: Reactivity
**Export Size**: 464 B
**Last Changed**: 2 weeks ago
**Alias**: `controlledRef`

Fine-grained controls over ref and its reactivity.

## Usage

`refWithControl` is a powerful utility that gives you precise control over a ref's reactivity. It extends a standard ref with methods to get and set the value without triggering reactive effects or tracking dependencies.

```ts
import { refWithControl } from '@vueuse/core'
import { computed, watchEffect } from 'vue'

const num = refWithControl(0)
const doubled = computed(() => num.value * 2)

// Normal reactive behavior
num.value = 5
console.log(num.value) // 5
console.log(doubled.value) // 10

// Set value without triggering reactivity
num.set(10, false)
console.log(num.value) // 10
console.log(doubled.value) // Still 10, because reactivity was not triggered

// Get value without tracking as a dependency
watchEffect(() => {
  console.log('Peeked value:', num.peek())
})

num.value = 20 // `doubled` will update, but the watchEffect will not re-run
console.log(doubled.value) // 40
```

## Options

### `onBeforeChange`

You can provide an `onBeforeChange` function to intercept and validate changes. If the function returns `false`, the change is dismissed.

```ts
const num = refWithControl(0, {
  onBeforeChange(value, oldValue) {
    // only allow changes less than 5
    if (Math.abs(value - oldValue) > 5) {
      return false
    }
  },
})

num.value += 3 // num.value becomes 3

num.value += 10 // This change will be dismissed
console.log(num.value) // still 3
```

### `onChanged`

The `onChanged` option provides a way to react to value changes, similar to `watch`, but with potentially less overhead.

## Type Declarations

```ts
export interface ControlledRefOptions<T> {
  onBeforeChange?: (value: T, oldValue: T) => boolean | void
  onChanged?: (value: T, oldValue: T) => void
}

export declare function refWithControl<T>(
  initial: T,
  options?: ControlledRefOptions<T>,
): ControlledRef<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/refWithControl/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/refWithControl/index.md)
