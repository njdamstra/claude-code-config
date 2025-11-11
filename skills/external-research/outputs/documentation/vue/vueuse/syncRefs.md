# syncRefs

**Category:** Reactivity
**Export Size:** 198 B
**Last Changed:** 7 months ago
**Related:** [`syncRef`](https://vueuse.org/shared/syncRef/)

Keep target refs in sync with a source ref

## Usage

```ts
import { syncRefs } from '@vueuse/core'
import { ref } from 'vue'

const source = ref('hello')
const target = ref('target')

const stop = syncRefs(source, target)

console.log(target.value) // hello

source.value = 'foo'

console.log(target.value) // foo
```

### Sync with multiple targets

You can also pass an array of refs to sync.

```ts
import { syncRefs } from '@vueuse/core'
import { ref } from 'vue'

const source = ref('hello')
const target1 = ref('target1')
const target2 = ref('target2')

const stop = syncRefs(source, [target1, target2])

console.log(target1.value) // hello

console.log(target2.value) // hello

source.value = 'foo'

console.log(target1.value) // foo

console.log(target2.value) // foo
```

## Watch options

The options for `syncRefs` are similar to `watch`'s `WatchOptions` but with different default values.

```ts
export interface SyncRefsOptions {
  /**
   * Timing for syncing, same as watch's flush option
   *
   * @default 'sync'
   */
  flush?: WatchOptions['flush']

  /**
   * Watch deeply
   *
   * @default false
   */
  deep?: boolean

  /**
   * Sync values immediately
   *
   * @default true
   */
  immediate?: boolean
}
```

When setting `{ flush: 'pre' }`, the target reference will be updated at [the end of the current "tick"](https://vuejs.org/guide/essentials/watchers.html#callback-flush-timing) before rendering starts.

```ts
import { syncRefs } from '@vueuse/core'
import { nextTick, ref } from 'vue'

const source = ref('hello')
const target = ref('target')

syncRefs(source, target, { flush: 'pre' })

console.log(target.value) // hello

source.value = 'foo'

console.log(target.value) // hello <- still unchanged, because of flush 'pre'

await nextTick()

console.log(target.value) // foo <- changed!
```

## Type Declarations

```ts
export interface SyncRefsOptions extends ConfigurableFlushSync {
  /**
   * Watch deeply
   *
   * @default false
   */
  deep?: boolean

  /**
   * Sync values immediately
   *
   * @default true
   */
  immediate?: boolean
}

/**
 * Keep target ref(s) in sync with the source ref
 *
 * @param source source ref
 * @param targets
 */
export declare function syncRefs<T>(
  source: Ref<T>,
  targets: Ref<T> | Ref<T>[],
  options?: SyncRefsOptions
): WatchStopHandle
```

## Source

- [Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/syncRefs/index.ts)
- [Demo](https://github.com/vueuse/vueuse/blob/main/packages/shared/syncRefs/demo.vue)
- [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/syncRefs/index.md)
