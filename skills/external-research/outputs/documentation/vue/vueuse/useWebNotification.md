# useWebNotification

Category: Browser

Export Size: 1.23 kB

Last Changed: 8 months ago

Reactive [Notification](https://developer.mozilla.org/en-US/docs/Web/API/notification)

The Web Notification interface of the Notifications API is used to configure and display desktop notifications to the user.

## Usage

**TIP**: Before an app can send a notification, the user must grant the application the right to do so. The user's OS settings may also prevent expected notification behaviour.

```ts
import { useWebNotification } from '@vueuse/core'

const {
  isSupported,
  notification,
  show,
  close,
  onClick,
  onShow,
  onError,
  onClose,
  ensurePermissions,
} = useWebNotification({
  title: 'Hello, VueUse world!',
  dir: 'auto',
  lang: 'en',
  renotify: true,
  tag: 'test',
})

if (isSupported.value && notification.value)
  show()
```

This composable also utilizes the createEventHook utility from '@vueuse/shared':

```ts
onClick((evt: Event) => {
  // Do something with the notification on:click event...
})

onShow((evt: Event) => {
  // Do something with the notification on:show event...
})

onError((evt: Event) => {
  // Do something with the notification on:error event...
})

onClose((evt: Event) => {
  // Do something with the notification on:close event...
})
```

## Type Declarations

```ts
export interface WebNotificationOptions {
  /**
   * The title read-only property of the Notification interface indicates
   * the title of the notification
   *
   * @default ''
   */
  title?: string
  /**
   * The body string of the notification as specified in the constructor's
   * options parameter.
   *
   * @default ''
   */
  body?: string
  /**
   * The text direction of the notification as specified in the constructor's
   * options parameter.
   *
   * @default ''
   */
  dir?: "auto" | "ltr" | "rtl"
  /**
   * The language code of the notification as specified in the constructor's
   * options parameter.
   *
   * @default DOMString
   */
  lang?: string
  /**
   * The ID of the notification(if any) as specified in the constructor's options
   * parameter.
   *
   * @default ''
   */
  tag?: string
  /**
   * The URL of the image used as an icon of the notification as specified
   * in the constructor's options parameter.
   *
   * @default ''
   */
  icon?: string
  /**
   * Specifies whether the user should be notified after a new notification
   * replaces an old one.
   *
   * @default false
   */
  renotify?: boolean
  /**
   * A boolean value indicating that a notification should remain active until the
   * user clicks or dismisses it, rather than closing automatically.
   *
   * @default false
   */
  requireInteraction?: boolean
  /**
   * The silent read-only property of the Notification interface specifies
   * whether the notification should be silent, i.e., no sounds or vibrations
   * should be issued, regardless of the device settings.
   *
   * @default false
   */
  silent?: boolean
  /**
   * Specifies a vibration pattern for devices with vibration hardware to emit.
   * A vibration pattern, as specified in the Vibration API spec
   *
   * @see https://w3c.github.io/vibration/
   */
  vibrate?: number[]
}

export interface UseWebNotificationOptions
  extends ConfigurableWindow,
    WebNotificationOptions {
  /**
   * Request for permissions onMounted if it's not granted.
   *
   * Can be disabled and calling `ensurePermissions` to grant afterwords.
   *
   * @default true
   */
  requestPermissions?: boolean
}

/**
 * Reactive useWebNotification
 *
 * @see https://vueuse.org/useWebNotification
 * @see https://developer.mozilla.org/en-US/docs/Web/API/notification
 */
export declare function useWebNotification(
  options?: UseWebNotificationOptions,
): {
  isSupported: Ref<boolean>
  notification: Ref<Notification | null, Notification | null>
  ensurePermissions: () => Promise<boolean | undefined>
  permissionGranted: Ref<boolean, boolean>
  show: (overrides?: WebNotificationOptions) => Promise<Notification | undefined>
  close: () => void
  onClick: EventHookOn<any>
  onShow: EventHookOn<any>
  onError: EventHookOn<any>
  onClose: EventHookOn<any>
}

export type UseWebNotificationReturn = ReturnType<typeof useWebNotification>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebNotification/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebNotification/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useWebNotification/index.md)

## Changelog

### v12.1.0 on 12/22/2024
- fix: prevent notifications when checking for support (#4019)

### v12.0.0-beta.1 on 11/21/2024
- feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v10.10.0 on 5/27/2024
- fix: detect `isSupported` with try-catch (#3980)

### v10.5.0 on 10/7/2023
- fix: condition check on permission (#3422)

### v10.4.0 on 8/25/2023
- feat: add `requestPermissions` option, return `permissionGranted` and `ensurePermissions` (#3325)
