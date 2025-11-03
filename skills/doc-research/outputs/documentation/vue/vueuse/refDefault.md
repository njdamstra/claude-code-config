# refDefault

**Category**: Reactivity
**Export Size**: 136 B
**Last Changed**: 2 weeks ago

Apply a default value to a ref.

## Usage

`refDefault` is a utility that provides a fallback value for a ref that might be `null` or `undefined`. It returns a `computed` ref that will return the default value if the source ref's value is nullish.

```ts
import { ref } from 'vue'
import { refDefault } from '@vueuse/core'

const source = ref<string | undefined>(undefined)

// If `source` is `undefined` or `null`, `defaulted` will be 'default value'
const defaulted = refDefault(source, 'default value')

console.log(defaulted.value) // 'default value'

source.value = 'hello'
console.log(defaulted.value) // 'hello'

source.value = undefined
console.log(defaulted.value) // 'default value'
```

This is useful when working with refs that might not have a value yet, for example, when using `useStorage`.

```ts
import { useStorage, refDefault } from '@vueuse/core'

const stored = useStorage('my-key', undefined) // could be undefined
const state = refDefault(stored, 'default-state') // ensures a value is always present
```

## Type Declarations

```ts
/**
 * Apply a default value to a ref.
 *
 * @see https://vueuse.org/refDefault
 * @param source The ref to be defaulted.
 * @param defaultValue The default value.
 */
export declare function refDefault<T>(
  source: Ref<T | null | undefined>,
  defaultValue: T,
): ComputedRef<T>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/refDefault/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/refDefault/index.md)
