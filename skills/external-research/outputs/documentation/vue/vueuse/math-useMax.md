# useMax

Category: @Math
Package: `@vueuse/math`
Export Size: 184 B

Reactive `Math.max`.

## Usage

```ts
import { ref } from 'vue'
import { useMax } from '@vueuse/math'

const list = ref([1, 2, 3, 4])
const max = useMax(list) // Ref<4>
```

```ts
import { ref } from 'vue'
import { useMax } from '@vueuse/math'

const a = ref(1)
const b = ref(3)

const max = useMax(a, b, 2) // Ref<3>
```

## Type Declarations

```ts
export declare function useMax(
  array: MaybeRefOrGetter<MaybeRefOrGetter<number>[]>,
): ComputedRef<number>

export declare function useMax(
  ...args: MaybeRefOrGetter<number>[]
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useMax/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useMax/index.md)
