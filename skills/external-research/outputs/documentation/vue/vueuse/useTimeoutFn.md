# useTimeoutFn

**Category:** Animation
**Export Size:** 335 B
**Last Changed:** 4 months ago

Wrapper for `setTimeout` with controls.

## Usage

```ts
import { useTimeoutFn } from '@vueuse/core'

const { isPending, start, stop } = useTimeoutFn(() => {
  /* ... */
}, 3000)
```

## Type Declarations

```ts
export interface UseTimeoutFnOptions {
  /**
   * Start the timer immediately
   *
   * @default true
   */
  immediate?: boolean
  /**
   * Execute the callback immediately after calling `start`
   *
   * @default false
   */
  immediateCallback?: boolean
}

export type UseTimeoutFnReturn<StartFnArgs extends AnyFn> =
  Stoppable<PromiseLike<ReturnType<StartFnArgs>> | []>

/**
 * Wrapper for `setTimeout` with controls.
 *
 * @param cb
 * @param interval
 * @param options
 */
export declare function useTimeoutFn<StartFnArgs extends AnyFn>(
  cb: StartFnArgs,
  interval: MaybeRefOrGetter<number>,
  options?: UseTimeoutFnOptions,
): UseTimeoutFnReturn<StartFnArgs>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useTimeoutFn/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/useTimeoutFn/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useTimeoutFn/index.md)
