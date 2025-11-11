# useMin

Category: @Math
Package: `@vueuse/math`
Export Size: 172 B

Reactive `Math.min`.

## Usage

```ts
import { ref } from 'vue'
import { useMin } from '@vueuse/math'

const list = ref([1, 2, 3, 4])
const min = useMin(list) // Ref<1>
```

```ts
import { ref } from 'vue'
import { useMin } from '@vueuse/math'

const a = ref(1)
const b = ref(3)

const min = useMin(a, b, 2) // Ref<1>
```

## Type Declarations

```ts
export declare function useMin(
  array: MaybeRefOrGetter<MaybeRefOrGetter<number>[]>,
): ComputedRef<number>

export declare function useMin(
  ...args: MaybeRefOrGetter<number>[]
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useMin/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useMin/index.md)
