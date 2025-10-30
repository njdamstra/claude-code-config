# useToString

**Category:** Utilities
**Export Size:** 118 B
**Last Changed:** 2 months ago

Reactively convert a ref to string.

## Usage

```ts
import { useToString } from '@vueuse/core'
import { ref } from 'vue'

const num = ref(3.14)
const str = useToString(num)

str.value // '3.14'
```

## Type Declarations

```ts
/**
 * Reactively convert a ref to string.
 *
 * @see https://vueuse.org/useToString
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useToString(
  value: MaybeRef<unknown>,
): ComputedRef<string>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useToString/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useToString/index.md)

## Changelog

**v13.6.0** (7/28/2025)
- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

**v12.8.0** (3/5/2025)
- feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native (#4636)

**v12.3.0** (1/2/2025)
- feat(toValue): deprecate `toValue` from `@vueuse/shared` in favor of Vue's native

**v12.0.0-beta.1** (11/21/2024)
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
