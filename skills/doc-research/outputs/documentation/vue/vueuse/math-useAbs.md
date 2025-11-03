# useAbs

Category: @Math
Package: `@vueuse/math`
Export Size: 90 B

Reactive `Math.abs`.

## Usage

```ts
import { ref } from 'vue'
import { useAbs } from '@vueuse/math'

const value = ref(-23)
const abs = useAbs(value) // Ref<23>
```

## Type Declarations

```ts
/**
 * Reactive `Math.abs`.
 *
 * @see https://vueuse.org/useAbs
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useAbs(
  value: MaybeRefOrGetter<number>,
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useAbs/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useAbs/index.md)
