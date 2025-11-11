# useIntervalFn

**Category:** Animation
**Export Size:** 367 B
**Last Changed:** 4 months ago

Wrapper for `setInterval` with controls

## Usage

```ts
import { useIntervalFn } from '@vueuse/core'

const { pause, resume, isActive } = useIntervalFn(() => {
  /* your function */
}, 1000)
```

## Type Declarations

```ts
export interface UseIntervalFnOptions {
  /**
   * Start the timer immediately
   *
   * @default true
   */
  immediate?: boolean
  /**
   * Execute the callback immediately after calling `resume`
   *
   * @default false
   */
  immediateCallback?: boolean
}

export type UseIntervalFnReturn = Pausable

/**
 * Wrapper for `setInterval` with controls
 *
 * @see https://vueuse.org/useIntervalFn
 * @param cb
 * @param interval
 * @param options
 */
export declare function useIntervalFn(
  cb: Fn,
  interval?: MaybeRefOrGetter<number>,
  options?: UseIntervalFnOptions,
): Pausable
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/useIntervalFn/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/useIntervalFn/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/useIntervalFn/index.md)
