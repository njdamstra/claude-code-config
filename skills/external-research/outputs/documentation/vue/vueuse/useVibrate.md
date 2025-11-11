# useVibrate

Category: Browser

Export Size: 700 B

Last Changed: 2 months ago

Reactive [Vibration API](https://developer.mozilla.org/en-US/docs/Web/API/Vibration_API)

Most modern mobile devices include vibration hardware, which lets software code provides physical feedback to the user by causing the device to shake.

The Vibration API offers Web apps the ability to access this hardware, if it exists, and does nothing if the device doesn't support it.

## Usage

Vibration is described as a pattern of on-off pulses, which may be of varying lengths.

The pattern may consist of either a single integer describing the number of milliseconds to vibrate, or an array of integers describing a pattern of vibrations and pauses.

```ts
import { useVibrate } from '@vueuse/core'

// This vibrates the device for 300 ms
// then pauses for 100 ms before vibrating the device again for another 300 ms:
const { isSupported, vibrate, stop } = useVibrate({
  pattern: [300, 100, 300]
})

// Start the vibration, it will automatically stop when the pattern is complete:
vibrate()

// But if you want to stop it, you can:
stop()
```

## Type Declarations

```ts
export interface UseVibrateOptions extends ConfigurableNavigator {
  /**
   *
   * Vibration Pattern
   *
   * An array of values describes alternating periods in which the
   * device is vibrating and not vibrating. Each value in the array
   * is converted to an integer, then interpreted alternately as
   * the number of milliseconds the device should vibrate and the
   * number of milliseconds it should not be vibrating
   *
   * @default []
   *
   */
  pattern?: MaybeRefOrGetter<number[] | number>
  /**
   * Interval to run a persistent vibration, in ms
   *
   * Pass `0` to disable
   *
   * @default 0
   *
   */
  interval?: number
}

/**
 * Reactive vibrate
 *
 * @see https://vueuse.org/useVibrate
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Vibration_API
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useVibrate(
  options?: UseVibrateOptions
): {
  isSupported: Ref<boolean>
  pattern: Ref<number | number[]>
  intervalControls: Pausable | undefined
  vibrate: (pattern?: number | number[]) => void
  stop: () => void
}

export type UseVibrateReturn = ReturnType<typeof useVibrate>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useVibrate/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useVibrate/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useVibrate/index.md)

## Changelog

### v13.6.0 on 7/28/2025
- refactor: add `@__NO_SIDE_EFFECTS__` annotations to all pure functions (#4907)

### v12.8.0 on 3/5/2025
- feat(types): deprecate `MaybeRef` and `MaybeRefOrGetter` in favor of Vue's native (#4636)
