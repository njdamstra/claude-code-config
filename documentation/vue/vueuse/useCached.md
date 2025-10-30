# useCached

Category: Utilities

Export Size: 199 B

Cache a ref with a custom comparator.

## Usage

```ts
import { useCached } from '@vueuse/core'
import { shallowRef } from 'vue'

interface Data {
  value: number
  extra: number
}

const source = shallowRef<Data>({ value: 42, extra: 0 })
const cached = useCached(source, (a, b) => a.value === b.value)

source.value = {
  value: 42,
  extra: 1,
}

console.log(cached.value) // { value: 42, extra: 0 }

source.value = {
  value: 43,
  extra: 1,
}

console.log(cached.value) // { value: 43, extra: 1 }
```

## Type Declarations

```ts
export interface UseCachedOptions<DeepRefs extends boolean = true>
  extends ConfigurableDeepRefs<DeepRefs>,
    WatchOptions {}

export declare function useCached<T, DeepRefs extends boolean = true>(
  source: WatchSource<T>,
  comparator?: (a: T, b: T) => boolean,
  options?: UseCachedOptions<DeepRefs>,
): Ref<T, DeepRefs>

export type UseCachedReturn<
  Source = any,
  DeepRefs extends boolean = true,
> = ReturnType<typeof useCached<Source, DeepRefs>>
```
