# useCeil

Category: @Math
Package: `@vueuse/math`
Export Size: 92 B

Reactive `Math.ceil`

## Usage

```ts
import { ref } from 'vue'
import { useCeil } from '@vueuse/math'

const value = ref(0.95)
const ceil = useCeil(value) // 1
```

## Type Declarations

```ts
/**
 * Reactive `Math.ceil`.
 *
 * @see https://vueuse.org/useCeil
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useCeil(
  value: MaybeRefOrGetter<number>,
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useCeil/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useCeil/index.md)
