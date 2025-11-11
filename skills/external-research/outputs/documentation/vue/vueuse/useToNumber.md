# useToNumber

**Category:** Utilities
**Export Size:** 213 B
**Last Changed:** 2 months ago

Reactively convert a string ref to number.

## Usage

```ts
import { useToNumber } from '@vueuse/core'
import { ref } from 'vue'

const str = ref('123')
const num = useToNumber(str)

num.value // 123
```

## Options

```ts
export interface UseToNumberOptions {
  /**
   * Method to use to convert the value to a number.
   * Or a custom function for the conversion.
   *
   * @default 'parseFloat'
   */
  method?: "parseFloat" | "parseInt" | ((value: string | number) => number)

  /**
   * The base in mathematical numeral systems passed to `parseInt`.
   * Only works with `method: 'parseInt'`
   */
  radix?: number

  /**
   * Replace NaN with zero
   *
   * @default false
   */
  nanToZero?: boolean
}
```

## Type Declarations

```ts
/**
 * Reactively convert a string ref to number.
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useToNumber(
  value: MaybeRef<number | string>,
  options?: UseToNumberOptions,
): ComputedRef<number>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useToNumber/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useToNumber/index.md)

## Changelog

**v13.6.0** (7/28/2025)
- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

**v12.8.0** (3/5/2025)
- feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native (#4636)

**v12.3.0** (1/2/2025)
- feat: `method` support custom function (#4441)
- feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

**v12.0.0-beta.1** (11/21/2024)
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
