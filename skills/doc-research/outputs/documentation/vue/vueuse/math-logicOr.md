# logicOr

Category: @Math
Package: `@vueuse/math`
Export Size: 95 B
Alias: `or` (deprecated)

Related: [`logicAnd`](https://vueuse.org/math/logicAnd/) [`logicNot`](https://vueuse.org/math/logicNot/)

`OR` conditions for refs.

## Usage

```ts
import { watch, ref } from 'vue'
import { logicOr } from '@vueuse/math'

const a = ref(true)
const b = ref(false)

watch(logicOr(a, b), () => {
  console.log('either a or b is truthy!')
})
```

## Type Declarations

```ts
/**
 * `OR` conditions for refs.
 *
 * @see https://vueuse.org/logicOr
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function logicOr(
  ...args: MaybeRefOrGetter<any>[]
): ComputedRef<boolean>

/** @deprecated use `logicOr` instead */
export declare const or: typeof logicOr
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/logicOr/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/logicOr/index.md)
