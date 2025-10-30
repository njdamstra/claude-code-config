# useDevicesList

Category: [Sensors](https://vueuse.org/functions#category=Sensors)

Export Size: 1.34 kB

Last Changed: 3 months ago

Related: [`useUserMedia`](https://vueuse.org/core/useUserMedia/)

Reactive [enumerateDevices](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/enumerateDevices) listing available input/output devices.

## Demo

Camera (0)

Microphones (0)

Speakers (0)

## Usage

```ts
import { useDevicesList } from '@vueuse/core'

const {
  devices,
  videoInputs: cameras,
  audioInputs: microphones,
  audioOutputs: speakers,
} = useDevicesList()
```

## Requesting Permissions

To request permissions, use the `ensurePermissions` method.

```ts
const {
  ensurePermissions,
  permissionsGranted,
} = useDevicesList()

await ensurePermissions()

console.log(permissionsGranted.value)
```

## Component

```vue
<template>
  <UseDevicesList v-slot="{ videoInputs, audioInputs, audioOutputs }">
    Cameras: {{ videoInputs }}
    Microphones: {{ audioInputs }}
    Speakers: {{ audioOutputs }}
  </UseDevicesList>
</template>
```

## Type Declarations

```ts
export interface UseDevicesListOptions extends ConfigurableNavigator {
  onUpdated?: (devices: MediaDeviceInfo[]) => void
  /**
   * Request for permissions immediately if it's not granted,
   * otherwise label and deviceIds could be empty
   *
   * @default false
   */
  requestPermissions?: boolean
  /**
   * Request for types of media permissions
   *
   * @default { audio: true, video: true }
   */
  constraints?: MediaStreamConstraints
}

export interface UseDevicesListReturn {
  /**
   * All devices
   */
  devices: Ref<MediaDeviceInfo[]>
  videoInputs: Ref<MediaDeviceInfo[]>
  audioInputs: Ref<MediaDeviceInfo[]>
  audioOutputs: Ref<MediaDeviceInfo[]>
  permissionsGranted: Ref<boolean>
  ensurePermissions: () => Promise<boolean>
  isSupported: Ref<boolean>
}

/**
 * Reactive `enumerateDevices` listing available input/output devices
 *
 * @see https://vueuse.org/useDevicesList
 * @param options
 */
export declare function useDevicesList(
  options?: UseDevicesListOptions,
): UseDevicesListReturn
```

## Source

[Source](https://github.com/vueuse/vueuse/blob/main/packages/core/useDevicesList/index.ts) • [Demo](https://github.com/vueuse/vueuse/blob/main/packages/core/useDevicesList/demo.vue) • [Docs](https://github.com/vueuse/vueuse/blob/main/packages/core/useDevicesList/index.md)

## Contributors

- Anthony Fu
- IlyaL
- wheat
- SerKo
- Nikitatopodin
- Fernando Fernández
- Alex Liu
- Klein Petr
- Espen Solli Grande
- Félix Zapata
- vaakian X
- Jelf
- Andras Serfozo
- Alex Kozack

## Changelog

### v14.0.0-alpha.0 on 9/1/2025

`8c521` - feat(components)!: refactor components and make them consistent (#4912)

### v13.4.0 on 6/19/2025

`c424f` - fix: Check for device availability before requesting permissions (#4818)

### v12.8.0 on 3/5/2025

`f9685` - fix(useDeviceList): audioInputs doesn't update if camera permission is `granted` (#4559)

### v12.4.0 on 1/10/2025

`dd316` - feat: use passive event handlers everywhere is possible (#4477)

### v12.0.0-beta.1 on 11/21/2024

`0a9ed` - feat!: drop Vue 2 support, optimize bundles and clean up (#4349)

### v11.2.0 on 10/30/2024

`bf0f2` - fix: handle NotAllowedError on reject/close (#4246)
