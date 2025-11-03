# useProjection

Category: @Math
Package: `@vueuse/math`
Export Size: 163 B

Related: [`createGenericProjection`](https://vueuse.org/math/createGenericProjection/) [`createProjection`](https://vueuse.org/math/createProjection/)

Reactive numeric projection from one domain to another.

## Usage

```ts
import { ref } from 'vue'
import { useProjection } from '@vueuse/math'

const input = ref(0)
const projected = useProjection(input, [0, 10], [0, 100])

input.value = 5 // projected.value === 50

input.value = 10 // projected.value === 100
```

## Type Declarations

```ts
/**
 * Reactive numeric projection from one domain to another.
 *
 * @see https://vueuse.org/useProjection
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useProjection(
  input: MaybeRefOrGetter<number>,
  fromDomain: MaybeRefOrGetter<readonly [number, number]>,
  toDomain: MaybeRefOrGetter<readonly [number, number]>,
  interpolator?: MaybeRefOrGetter<number, number>,
): ComputedRef<number>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/useProjection/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/math/useProjection/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/useProjection/index.md)
