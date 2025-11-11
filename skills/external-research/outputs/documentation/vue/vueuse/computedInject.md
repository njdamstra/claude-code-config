# computedInject

**Category**: Component
**Export Size**: 436 B
**Last Changed**: 2 weeks ago

Combine `computed` and `inject`.

## Usage

`computedInject` allows you to inject a value from a parent component and immediately create a computed property based on it. This is useful for creating reactive values in a child component that depend on data provided by an ancestor.

### Read-only Computed

```ts
// Parent Component
import { ref, provide } from 'vue'

const count = ref(0)
provide('count', count)

// Child Component
import { computedInject } from '@vueuse/core'

const double = computedInject('count', (source) => {
  if (!source) return 0
  return source.value * 2
})

console.log(double.value) // 0
```

### Writable Computed

You can create a writable computed property by providing an object with `get` and `set` methods.

```ts
// Parent Component
import { ref, provide } from 'vue'

const count = ref(0)
provide('count', count)

// Child Component
import { computedInject } from '@vueuse/core'

const double = computedInject('count', {
  get(source) {
    if (!source) return 0
    return source.value * 2
  },
  set(value) {
    // This will update the provided value in the parent component
    const source = inject('count')
    if (source) {
      source.value = value / 2
    }
  }
})

double.value = 10
// In the parent component, `count.value` will be 5
```

### Default Value

You can provide a default value, which will be used if the injection key is not found.

```ts
const injected = computedInject('my-key', source => source, 100) // 100 is the default value
```

## Type Declarations

```ts
export declare function computedInject<T, S = T | undefined>(
  key: InjectionKey<S> | string,
  options: {
    get(source: S): T
    set(value: T): void
  },
  treatDefaultAsFactory?: boolean,
): WritableComputedRef<T>

export declare function computedInject<T, S = T | undefined>(
  key: InjectionKey<S> | string,
  options: (source: S) => T,
  defaultValue?: T,
  treatDefaultAsFactory?: boolean,
): ComputedRef<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/core/computedInject/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/computedInject/index.md)
