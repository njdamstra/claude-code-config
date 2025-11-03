# useRound

Category: @Math
Package: `@vueuse/math`
Export Size: 92 B

Reactive `Math.round`.

## Usage

```ts
import { ref } from 'vue'
import { useRound } from '@vueuse/math'

const value = ref(20.49)
const round = useRound(value) // 20
```

## Type Declarations

```ts
/**
 * Reactive `Math.round`.
 *
 * @see https://vueuse.org/useRound
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useRound(
  value: MaybeRefOrGetter<number>,
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useRound/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useRound/index.md)
