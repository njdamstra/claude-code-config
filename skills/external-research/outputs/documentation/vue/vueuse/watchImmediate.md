# watchImmediate

**Category**: Watch
**Export Size**: 117 B
**Last Changed**: 2 weeks ago

Shorthand for watching value with {immediate: true}

## Usage

Similar to `watch`, but with `{ immediate: true }`

```ts
import { watchImmediate } from '@vueuse/core'

const obj = ref('vue-use') // changing the value from some external store/composables
obj.value = 'VueUse'

watchImmediate(obj, (updated) => {
  console.log(updated) // Console.log will be logged twice
})
```

## Type Declarations

```ts
export declare function watchImmediate<
  T extends Readonly<WatchSource<unknown>[]>,
>(
  source: [...T],
  cb: WatchCallback<MapSources<T>, MapOldSources<T, true>>,
  options?: Omit<WatchOptions<true>, "immediate">,
): WatchHandle

export declare function watchImmediate<
  T,
>(
  source: WatchSource<T>,
  cb: WatchCallback<T, T | undefined>,
  options?: Omit<WatchOptions<true>, "immediate">,
): WatchHandle

export declare function watchImmediate<
  T extends object,
>(
  source: T,
  cb: WatchCallback<T, T | undefined>,
  options?: Omit<WatchOptions<true>, "immediate">,
): WatchHandle
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchImmediate/index.ts) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/shared/watchImmediate/index.md)

## Contributors

* Anthony Fu
* Arthur Darkstone
* Anthony Fu
* 山吹色御守
* jp-liu
* Andrew Ferreira
* Kyrie890514
* Alex Liu
* 丶远方
* Magomed Chemurziev
* Hammad Asif

## Changelog

* **v14.0.0-alpha.3** on 9/16/2025
  * `b8102` - feat(watch): update watch return typo in watchExtractedObservable, watchDebounced, watchDeep, watchImmediate, watchOnce, watchThrottled and watchWithFilter (#4896)
* **v14.0.0-alpha.0** on 9/1/2025
  * `00a72` - fix(types): update type casting for watch functions to use WatchSource (#4966)
* **v12.0.0-beta.1** on 11/21/2024
  * `0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)
* **v11.0.0-beta.2** on 7/17/2024
  * `0716d` - fix(watchDeep): unify overload declaration for watch functions (#4043)
* **v10.2.0** on 6/16/2023
  * `4b4e6` - fix: fix overload signature (#3114)
* **v10.1.0** on 4/22/2023
  * `8f6a0` - feat(watch): watchImmediate and watchDeep support overloads (#2998)