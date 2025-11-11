# useDeviceMotion

**Category:** Sensors
**Export Size:** 1.19 kB
**Last Changed:** 8 months ago

Reactive [DeviceMotionEvent](https://developer.mozilla.org/en-US/docs/Web/API/DeviceMotionEvent). Provide web developers with information about the speed of changes for the device's position and orientation.

## Demo

Device Motion:

```json
{
  "acceleration": {
    "x": null,
    "y": null,
    "z": null
  },
  "accelerationIncludingGravity": {
    "x": null,
    "y": null,
    "z": null
  },
  "rotationRate": {
    "alpha": null,
    "beta": null,
    "gamma": null
  },
  "interval": 16
}
```

Request Permission

## Usage

```ts
import { useDeviceMotion } from '@vueuse/core'

const {
  acceleration,
  accelerationIncludingGravity,
  rotationRate,
  interval,
} = useDeviceMotion()
```

> Note: For iOS, you need to use `trigger` and bind it with user interaction. After permission granted, the API will run automatically

| State | Type | Description |
| --- | --- | --- |
| acceleration | `object` | An object giving the acceleration of the device on the three axis X, Y and Z. |
| accelerationIncludingGravity | `object` | An object giving the acceleration of the device on the three axis X, Y and Z with the effect of gravity. |
| rotationRate | `object` | An object giving the rate of change of the device's orientation on the three orientation axis alpha, beta and gamma. |
| interval | `Number` | A number representing the interval of time, in milliseconds, at which data is obtained from the device.. |
| ensurePermissions | `boolean` | Indicates whether the platform requires permission to use the API |
| permissionGranted | `boolean` | Indicates whether the user has granted permission. The default is always false |
| trigger | `Promise<void>` | An async function to request user permission. The API runs automatically once permission is granted |

You can find [more information about the state on the MDN](https://developer.mozilla.org/en-US/docs/Web/API/DeviceMotionEvent#instance_properties).

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseDeviceMotion v-slot="{ acceleration }">
    Acceleration: {{ acceleration }}
  </UseDeviceMotion>
</template>
```

## Type Declarations

```ts
export interface DeviceMotionOptions
  extends ConfigurableWindow,
    ConfigurableEventFilter {
  /**
   * Request for permissions immediately if it's not granted,
   * otherwise label and deviceIds could be empty
   *
   * @default false
   */
  immediate?: boolean
}

/**
 * Reactive DeviceMotionEvent.
 *
 * @see https://vueuse.org/useDeviceMotion
 * @param options
 */
export declare function useDeviceMotion(
  options?: DeviceMotionOptions
): {
  acceleration: Ref<
    DeviceMotionEventAcceleration | null,
    DeviceMotionEventAcceleration | null
  >
  accelerationIncludingGravity: Ref<
    DeviceMotionEventAcceleration | null,
    DeviceMotionEventAcceleration | null
  >
  rotationRate: Ref<
    DeviceMotionEventRotationRate | null,
    DeviceMotionEventRotationRate | null
  >
  interval: Ref<number, number>
  ensurePermissions: Ref<boolean>
  permissionGranted: Ref<boolean>
  trigger: () => Promise<void>
  isSupported: Ref<boolean, boolean>
}

export type UseDeviceMotionReturn = ReturnType<typeof useDeviceMotion>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDeviceMotion/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDeviceMotion/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDeviceMotion/index.md)
