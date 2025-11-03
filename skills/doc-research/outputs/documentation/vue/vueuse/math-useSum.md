# useSum

Category: @Math
Package: `@vueuse/math`
Export Size: 190 B

Get the sum of an array reactively

## Usage

```ts
import { ref } from 'vue'
import { useSum } from '@vueuse/math'

const list = ref([1, 2, 3, 4])
const sum = useSum(list) // Ref<10>
```

```ts
import { ref } from 'vue'
import { useSum } from '@vueuse/math'

const a = ref(1)
const b = ref(3)

const sum = useSum(a, b, 2) // Ref<6>
```

## Type Declarations

```ts
export declare function useSum(
  array: MaybeRefOrGetter<MaybeRefOrGetter<number>[]>,
): ComputedRef<number>

export declare function useSum(
  ...args: MaybeRefOrGetter<number>[]
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useSum/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useSum/index.md)
