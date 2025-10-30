# logicNot

Category: @Math
Package: `@vueuse/math`
Export Size: 83 B
Alias: `not` (deprecated)

Related: [`logicAnd`](https://vueuse.org/math/logicAnd/) [`logicOr`](https://vueuse.org/math/logicOr/)

`NOT` condition for ref.

## Usage

```ts
import { watch, ref } from 'vue'
import { logicNot } from '@vueuse/math'

const a = ref(true)

watch(logicNot(a), () => {
  console.log('a is now falsy!')
})
```

## Type Declarations

```ts
/**
 * `NOT` conditions for refs.
 *
 * @see https://vueuse.org/logicNot
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function logicNot(
  v: MaybeRefOrGetter<any>
): ComputedRef<boolean>

/** @deprecated use `logicNot` instead */
export declare const not: typeof logicNot
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/logicNot/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/logicNot/index.md)
