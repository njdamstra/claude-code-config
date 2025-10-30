# logicAnd

Category: @Math
Package: `@vueuse/math`
Export Size: 104 B
Alias: `and` (deprecated)

Related: [`logicNot`](https://vueuse.org/math/logicNot/) [`logicOr`](https://vueuse.org/math/logicOr/)

`AND` condition for refs.

## Usage

```ts
import { watch, ref } from 'vue'
import { logicAnd } from '@vueuse/math'

const a = ref(true)
const b = ref(false)

watch(logicAnd(a, b), () => {
  console.log('both a and b are now truthy!')
})
```

## Type Declarations

```ts
/**
 * `AND` conditions for refs.
 *
 * @see https://vueuse.org/logicAnd
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function logicAnd(
  ...args: MaybeRefOrGetter<any>[]
): ComputedRef<boolean>

/** @deprecated use `logicAnd` instead */
export declare const and: typeof logicAnd
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/math/logicAnd/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/math/logicAnd/index.md)
