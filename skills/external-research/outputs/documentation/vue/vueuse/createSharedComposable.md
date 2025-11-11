# createSharedComposable

**Category:** State
**Export Size:** 232 B
**Last Changed:** 2 weeks ago

Make a composable function usable with multiple Vue instances.

## ⚠️ SSR Warning

When used in a **SSR** environment, `createSharedComposable` will **automatically fallback** to a non-shared version. This means every call will create a fresh instance in SSR to avoid [cross-request state pollution](https://vuejs.org/guide/scaling-up/ssr.html#cross-request-state-pollution).

## Usage

```ts
import { createSharedComposable, useMouse } from '@vueuse/core'

const useSharedMouse = createSharedComposable(useMouse)

// CompA.vue
const { x, y } = useSharedMouse()

// CompB.vue - will reuse the previous state and no new event listeners will be registered
const { x, y } = useSharedMouse()
```

## Type Declarations

```ts
export type SharedComposable<Fn extends AnyFn = AnyFn> = ReturnType<Fn>

/**
 * Make a composable function usable with multiple Vue instances.
 *
 * @see https://vueuse.org/createSharedComposable
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function createSharedComposable<Fn extends AnyFn>(
  composable: Fn,
): SharedComposable<Fn>
```

## Related

- [`createGlobalState`](https://vueuse.org/shared/createGlobalState/)

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/createSharedComposable/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/createSharedComposable/index.md)
