# useWakeLock

Category: Browser

Export Size: 1.04 kB

Last Changed: 2 months ago

Reactive [Screen Wake Lock API](https://developer.mozilla.org/en-US/docs/Web/API/Screen_Wake_Lock_API). Provides a way to prevent devices from dimming or locking the screen when an application needs to keep running.

## Usage

```ts
import { useWakeLock } from '@vueuse/core'

const { isSupported, isActive, request, forceRequest, release } = useWakeLock()
```

When `request` is called, the wake lock will be requested if the document is visible. Otherwise, the request will be queued until the document becomes visible. If the request is successful, `isActive` will be **true**. Whenever the document is hidden, the `isActive` will be **false**.

When `release` is called, the wake lock will be released. If there is a queued request, it will be canceled.

To request a wake lock immediately, even if the document is hidden, use `forceRequest`. Note that this may throw an error if the document is hidden.

## Type Declarations

```ts
type WakeLockType = "screen"

export interface WakeLockSentinel extends EventTarget {
  type: WakeLockType
  released: boolean
  release: () => Promise<void>
}

export type UseWakeLockOptions = ConfigurableNavigator & ConfigurableDocument

/**
 * Reactive Screen Wake Lock API.
 *
 * @see https://vueuse.org/useWakeLock
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useWakeLock(
  options?: UseWakeLockOptions
): {
  sentinel: Ref<WakeLockSentinel | null, WakeLockSentinel | null>
  isSupported: Ref<boolean>
  isActive: Ref<boolean>
  request: (type: WakeLockType) => Promise<void>
  forceRequest: (type: WakeLockType) => Promise<void>
  release: () => Promise<void>
}

export type UseWakeLockReturn = ReturnType<typeof useWakeLock>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useWakeLock/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useWakeLock/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useWakeLock/index.md)

## Changelog

### v13.6.0 on 7/28/2025
- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

### v12.4.0 on 1/10/2025
- feat: use passive event handlers everywhere is possible (#4477)

### v12.0.0-beta.1 on 11/21/2024
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v11.0.0-beta.2 on 7/17/2024
- fix: should delay wake lock request if document is hidden (#4055)
