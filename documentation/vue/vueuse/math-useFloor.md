# useFloor

Category: @Math
Package: `@vueuse/math`
Export Size: 90 B

Reactive `Math.floor`.

## Usage

```ts
import { ref } from 'vue'
import { useFloor } from '@vueuse/math'

const value = ref(45.95)
const floor = useFloor(value) // 45
```

## Type Declarations

```ts
/**
 * Reactive `Math.floor`
 *
 * @see https://vueuse.org/useFloor
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useFloor(
  value: MaybeRefOrGetter<number>,
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useFloor/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useFloor/index.md)
