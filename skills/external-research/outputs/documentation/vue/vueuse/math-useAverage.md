# useAverage

Category: @Math
Package: `@vueuse/math`
Export Size: 171 B

Get the average of an array reactively.

## Usage

```ts
import { ref } from 'vue'
import { useAverage } from '@vueuse/math'

const list = ref([1, 2, 3])
const average = useAverage(list) // Ref<2>
```

```ts
import { ref } from 'vue'
import { useAverage } from '@vueuse/math'

const a = ref(1)
const b = ref(3)

const average = useAverage(a, b) // Ref<2>
```

## Type Declarations

```ts
export declare function useAverage(
  array: MaybeRefOrGetter<MaybeRefOrGetter<number>[]>,
): ComputedRef<number>

export declare function useAverage(
  ...args: MaybeRefOrGetter<number>[]
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useAverage/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useAverage/index.md)
