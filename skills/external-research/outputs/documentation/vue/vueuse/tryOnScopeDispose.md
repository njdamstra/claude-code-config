# tryOnScopeDispose

**Category:** Component
**Export Size:** 125 B

Safe `onScopeDispose`. Call `onScopeDispose()` if it's inside an effect scope lifecycle, if not, do nothing.

## Usage

```ts
import { tryOnScopeDispose } from '@vueuse/core'

tryOnScopeDispose(() => {
  // cleanup logic
})
```

## Type Declarations

```ts
/**
 * Call onScopeDispose() if it's inside an effect scope lifecycle, if not, do nothing
 *
 * @param fn
 */
export declare function tryOnScopeDispose(
  fn: Fn,
  failSilently?: boolean,
): boolean
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/tryOnScopeDispose/index.ts)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/tryOnScopeDispose/index.md)
