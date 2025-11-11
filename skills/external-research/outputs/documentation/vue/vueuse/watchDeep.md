# watchDeep

**Category**: Watch
**Export Size**: 113 B
**Last Changed**: 2 weeks ago

Shorthand for watching value with {deep: true}

## Usage

Similar to `watch`, but with `{ deep: true }`

```ts
import { watchDeep } from '@vueuse/core'

const nestedObject = ref({
  foo: {
    bar: {
      deep: 5
    }
  }
})

watchDeep(nestedObject, (updated) => {
  console.log(updated)
})

onMounted(() => {
  nestedObject.value.foo.bar.deep = 10
})
```

## Type Declarations

```ts
export declare function watchDeep<
  T extends Readonly<WatchSource<unknown>[]!>,
  Immediate extends Readonly<boolean> = false,
>(
  source: [...T],
  cb: WatchCallback<MapSources<T>, MapOldSources<T, Immediate>>,
  options?: Omit<WatchOptions<Immediate>, "deep">,
): WatchHandle

export declare function watchDeep<
  T,
  Immediate extends Readonly<boolean> = false,
>(
  source: WatchSource<T>,
  cb: WatchCallback<T, Immediate extends true ? T | undefined : T>,
  options?: Omit<WatchOptions<Immediate>, "deep">,
): WatchHandle

export declare function watchDeep<
  T extends object,
  Immediate extends Readonly<boolean> = false,
>(
  source: T,
  cb: WatchCallback<T, Immediate extends true ? T | undefined : T>,
  options?: Omit<WatchOptions<Immediate>, "deep">,
): WatchHandle
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchDeep/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchDeep/index.md)

## Contributors

* Anthony Fu
* Arthur Darkstone
* Anthony Fu
* 山吹色御守
* jp-liu
* Kyrie890514
* Alex Liu
* 丶远方
* Hammad Asif

## Changelog

* **v14.0.0-alpha.3** on 9/16/2025
  * `b8102` - feat(watch): update watch return typo in watchExtractedObservable, watchDebounced, watchDeep, watchImmediate, watchOnce, watchThrottled and watchWithFilter (#4896)
* **v14.0.0-alpha.0** on 9/1/2025
  * `00a72` - fix(types): update type casting for watch functions to use WatchSource (#4966)
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v11.0.0-beta.2** on 7/17/2024
  * `0716d` - fix: unify overload declaration for watch functions (#4043)
* **v10.1.0** on 4/22/2023
  * `8f6a0` - feat(watch): watchImmediate and watchDeep support overloads (#2998)