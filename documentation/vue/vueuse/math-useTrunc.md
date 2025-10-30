# useTrunc

Category: @Math
Package: `@vueuse/math`
Export Size: 94 B

Reactive `Math.trunc`.

## Usage

```ts
import { ref } from 'vue'
import { useTrunc } from '@vueuse/math'

const value = ref(0.95)
const negValue = ref(-2.34)
const result = useTrunc(value) // 0
const negResult = useTrunc(negValue) // -2
```

## Type Declarations

```ts
/**
 * Reactive `Math.trunc`.
 *
 * @see https://vueuse.org/useTrunc
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useTrunc(
  value: MaybeRefOrGetter<number>,
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useTrunc/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useTrunc/index.md)
