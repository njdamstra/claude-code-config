# watchArray

Category: [Watch](https://vueuse.org/functions#category=Watch)

Export Size: 303 B

Similar to `watch`, but provides added and removed elements to the callback function.

## Usage

Use `{ deep: true }` for in-place list updates.

```ts
import { watchArray } from '@vueuse/core'
import { ref, onMounted } from 'vue'

const list = ref([1, 2, 3])

watchArray(list, (newList, oldList, added, removed) => {
  console.log(newList)     // [1, 2, 3, 4]
  console.log(oldList)     // [1, 2, 3]
  console.log(added)       // [4]
  console.log(removed)     // []
})

onMounted(() => {
  list.value = [...list.value, 4]
})
```

## Type Declarations

```ts
export declare type WatchArrayCallback<V = any, OV = any> = (
  value: V,
  oldValue: OV,
  added: V,
  removed: OV,
  onCleanup: (cleanupFn: () => void) => void,
) => any

export declare function watchArray<
  T,
  Immediate extends Readonly<boolean> = false,
>(
  source: WatchSource<T[]> | T[],
  cb: WatchArrayCallback<T[], Immediate extends true ? T[] | undefined : T[]>,
  options?: WatchOptions<Immediate>,
): WatchHandle
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchArray/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchArray/index.md)

## Contributors

- Anthony Fu
- sun0day
- Di Weng
