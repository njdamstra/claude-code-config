# useDeviceOrientation

**Category:** Sensors
**Export Size:** 807 B
**Last Changed:** 2 months ago

Reactive [DeviceOrientationEvent](https://developer.mozilla.org/en-US/docs/Web/API/DeviceOrientationEvent). Provide web developers with information from the physical orientation of the device running the web page.

## Demo

```
isSupported: true
isAbsolute: false
alpha: null
beta: null
gamma: null
```

## Usage

```ts
import { useDeviceOrientation } from '@vueuse/core'

const {
  isAbsolute,
  alpha,
  beta,
  gamma,
} = useDeviceOrientation()
```

| State | Type | Description |
| --- | --- | --- |
| isAbsolute | `boolean` | A boolean that indicates whether or not the device is providing orientation data absolutely. |
| alpha | `number` | A number representing the motion of the device around the z axis, express in degrees with values ranging from 0 to 360. |
| beta | `number` | A number representing the motion of the device around the x axis, express in degrees with values ranging from -180 to 180. |
| gamma | `number` | A number representing the motion of the device around the y axis, express in degrees with values ranging from -90 to 90. |

You can find [more information about the state on the MDN](https://developer.mozilla.org/en-US/docs/Web/API/DeviceOrientationEvent#instance_properties).

## Component Usage

> This function also provides a renderless component version via the `@vueuse/components` package. [Learn more about the usage](https://vueuse.org/guide/components).

```vue
<template>
  <UseDeviceOrientation v-slot="{ alpha, beta, gamma }">
    Alpha: {{ alpha }}
    Beta: {{ beta }}
    Gamma: {{ gamma }}
  </UseDeviceOrientation>
</template>
```

## Type Declarations

```ts
/**
 * Reactive DeviceOrientationEvent.
 *
 * @see https://vueuse.org/useDeviceOrientation
 * @param options
 *
 * @__NO_SIDE_EFFECTS__
 */
export declare function useDeviceOrientation(
  options?: ConfigurableWindow
): {
  isSupported: Ref<boolean>
  isAbsolute: Ref<boolean, boolean>
  alpha: Ref<number | null, number | null>
  beta: Ref<number | null, number | null>
  gamma: Ref<number | null, number | null>
}

export type UseDeviceOrientationReturn = ReturnType<typeof useDeviceOrientation>
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDeviceOrientation/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDeviceOrientation/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDeviceOrientation/index.md)
