# useClamp

Category: @Math
Package: `@vueuse/math`
Export Size: 223 B

Reactively clamp a value between two other values.

## Usage

```ts
import { ref } from 'vue'
import { useClamp } from '@vueuse/math'

const min = ref(0)
const max = ref(10)
const value = useClamp(0, min, max)
```

You can also pass a `ref` and the returned `computed` will be updated when the source ref changes:

```ts
import { ref } from 'vue'
import { useClamp } from '@vueuse/math'

const number = ref(0)
const clamped = useClamp(number, 0, 10)
```

## Type Declarations

```ts
/**
 * Reactively clamp a value between two other values.
 *
 * @see https://vueuse.org/useClamp
 * @param value number
 * @param min
 * @param max
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useClamp(
  value: MaybeRefOrGetter<number>,
  min: MaybeRefOrGetter<number>,
  max: MaybeRefOrGetter<number>,
): ComputedRef<number>

export declare function useClamp(
  value: MaybeRef<number>,
  min: MaybeRefOrGetter<number>,
  max: MaybeRefOrGetter<number>,
): Ref<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useClamp/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/math/useClamp/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useClamp/index.md)
