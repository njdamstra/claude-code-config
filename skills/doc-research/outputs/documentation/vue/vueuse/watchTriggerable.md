# watchTriggerable

Category: [Watch](https://vueuse.org/functions#category=Watch)

Export Size: 570 B

Watch that can be triggered manually

## Usage

A `watch` wrapper that supports manual triggering of `WatchCallback`, which returns an additional `trigger` to execute a `WatchCallback` immediately.

```ts
import { watchTriggerable } from '@vueuse/core'
import { nextTick, ref } from 'vue'

const source = ref(0)

const { trigger, stop } = watchTriggerable(
  source,
  v => console.log(`Changed to ${v}!`),
)

source.value = 'bar'
await nextTick() // logs: Changed to bar!

// Execution of WatchCallback via `trigger` does not require waiting
trigger() // logs: Changed to bar!
```

### `onCleanup`

When you want to manually call a `watch` that uses the onCleanup parameter; simply taking the `WatchCallback` out and calling it doesn't make it easy to implement the `onCleanup` parameter.

Using `watchTriggerable` will solve this problem.

```ts
import { watchTriggerable } from '@vueuse/core'
import { ref } from 'vue'

const source = ref(0)

const { trigger } = watchTriggerable(
  source,
  async (v, ov, onCleanup) => {
    let canceled = false
    onCleanup(() => canceled = true)

    await new Promise(resolve => setTimeout(resolve, 500))
    if (canceled)
      return

    console.log(`The value is "${v}"\n`)
  },
)

source.value = 1 // no log
await trigger() // logs (after 500 ms): The value is "1"
```

## Type Declarations

```ts
export interface WatchTriggerableReturn<FnReturnT = void>
  extends WatchIgnorableReturn {
  /** Execute `WatchCallback` immediately */
  trigger: () => FnReturnT
}

type OnCleanup = (cleanupFn: () => void) => void

export type WatchTriggerableCallback<V = any, OV = any, R = void> = (
  value: V,
  oldValue: OV,
  onCleanup: OnCleanup,
) => R

export declare function watchTriggerable<
  T extends Readonly<WatchSource<unknown>[]>,
  FnReturnT,
>(
  sources: [...T],
  cb: WatchTriggerableCallback<
    MapSources<T>,
    MapOldSources<T, true>,
    FnReturnT
  >,
  options?: WatchWithFilterOptions<boolean>,
): WatchTriggerableReturn<FnReturnT>

export declare function watchTriggerable<T, FnReturnT>(
  source: WatchSource<T>,
  cb: WatchTriggerableCallback<T, T | undefined, FnReturnT>,
  options?: WatchWithFilterOptions<boolean>,
): WatchTriggerableReturn<FnReturnT>

export declare function watchTriggerable<T extends object, FnReturnT>(
  source: T,
  cb: WatchTriggerableCallback<T, T | undefined, FnReturnT>,
  options?: WatchWithFilterOptions<boolean>,
): WatchTriggerableReturn<FnReturnT>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchTriggerable/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchTriggerable/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchTriggerable/index.md)
