# isDefined

**Category:** Utilities
**Export Size:** 103 B
**Last Changed:** 6 months ago

Non-nullish checking type guard for Ref.

## Usage

```ts
import { isDefined } from '@vueuse/core'

const value = ref(Math.random() ? 'example' : undefined) // Ref<string | undefined>

if (isDefined(value)) {
  // value is Ref<string>
}
```

## Type Declarations

```ts
export type IsDefined = boolean

export declare function isDefined<T>(
  v: Ref<T>,
): v is Ref<Exclude<T, null | undefined>>

export declare function isDefined<T>(
  v: ComputedRef<T>,
): v is ComputedRef<Exclude<T, null | undefined>>

export declare function isDefined<T>(
  v: T
): v is Exclude<T, null | undefined>
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/isDefined/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/isDefined/index.md)

## Changelog

**v13.1.0** (4/8/2025)
- feat(shared): ensure return types exists (#4659)

**v12.0.0-beta.1** (11/21/2024)
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

**v11.0.0-beta.3** (8/14/2024)
- fix: moves most specific overload to the top (#4141)
