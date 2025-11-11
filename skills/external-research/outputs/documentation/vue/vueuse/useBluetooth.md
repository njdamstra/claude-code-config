# useBluetooth

Category: Browser

Export Size: 1.04 kB

Reactive [Web Bluetooth API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API). Provides the ability to connect and interact with Bluetooth Low Energy peripherals.

The Web Bluetooth API lets websites discover and communicate with devices over the Bluetooth 4 wireless standard using the Generic Attribute Profile (GATT).

**Browser Compatibility:** Currently partially implemented in Android M, Chrome OS, Mac, and Windows 10. For a full overview see [Web Bluetooth API Browser Compatibility](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API#browser_compatibility)

**Important Notes:**
- There are numerous caveats with the Web Bluetooth API. See the [Web Bluetooth W3C Draft Report](https://webbluetoothcg.github.io/web-bluetooth/)
- This API is not available in Web Workers (not exposed via WorkerNavigator)

## Usage Default

```vue
<script setup lang="ts">
import { useBluetooth } from '@vueuse/core'

const {
  isSupported,
  isConnected,
  device,
  requestDevice,
  server,
} = useBluetooth({
  acceptAllDevices: true,
})
</script>

<template>
  <button @click="requestDevice()">
    Request Bluetooth Device
  </button>
</template>
```

When the device has paired and is connected, you can then work with the server object as you wish.

## Usage Battery Level Example

This sample illustrates the use of the Web Bluetooth API to read battery level and be notified of changes from a nearby Bluetooth Device advertising Battery information with Bluetooth Low Energy.

Here, we use the characteristicvaluechanged event listener to handle reading battery level characteristic value. This event listener will optionally handle upcoming notifications as well.

```vue
<script setup lang="ts">
import { useBluetooth, useEventListener, watchEffect } from '@vueuse/core'
import { ref } from 'vue'

const {
  isSupported,
  isConnected,
  device,
  requestDevice,
  server,
} = useBluetooth({
  acceptAllDevices: true,
  optionalServices: [
    'battery_service',
  ],
})

const batteryPercent = ref<undefined | number>()

const isGettingBatteryLevels = ref(false)

async function getBatteryLevels() {
  isGettingBatteryLevels.value = true

  // Get the battery service:
  const batteryService = await server!.getPrimaryService('battery_service')

  // Get the current battery level
  const batteryLevelCharacteristic = await batteryService.getCharacteristic(
    'battery_level',
  )

  // Listen to when characteristic value changes on `characteristicvaluechanged` event:
  useEventListener(batteryLevelCharacteristic, 'characteristicvaluechanged', (event) => {
    batteryPercent.value = event.target.value.getUint8(0)
  }, { passive: true })

  // Convert received buffer to number:
  const batteryLevel = await batteryLevelCharacteristic.readValue()

  batteryPercent.value = await batteryLevel.getUint8(0)
}

const { stop } = watchEffect(async () => {
  if (!isConnected.value || !server.value || isGettingBatteryLevels.value)
    return
  // Attempt to get the battery levels of the device:
  getBatteryLevels()
  // We only want to run this on the initial connection, as we will use an event listener to handle updates:
  stop()
})
</script>

<template>
  <button @click="requestDevice()">
    Request Bluetooth Device
  </button>
</template>
```

More samples can be found on [Google Chrome's Web Bluetooth Samples](https://googlechrome.github.io/samples/web-bluetooth/).

## Type Declarations

```ts
export interface UseBluetoothRequestDeviceOptions {
  /**
   * An array of BluetoothScanFilters. This filter consists of an array
   * of BluetoothServiceUUIDs, a name parameter, and a namePrefix parameter.
   */
  filters?: BluetoothLEScanFilter[] | undefined
  /**
   * An array of BluetoothServiceUUIDs.
   *
   * @see https://developer.mozilla.org/en-US/docs/Web/API/BluetoothRemoteGATTService/uuid
   */
  optionalServices?: BluetoothServiceUUID[] | undefined
}

export interface UseBluetoothOptions
  extends UseBluetoothRequestDeviceOptions,
    ConfigurableNavigator {
  /**
   * A boolean value indicating that the requesting script can accept all Bluetooth
   * devices. The default is false.
   *
   * !! This may result in a bunch of unrelated devices being shown
   * in the chooser and energy being wasted as there are no filters.
   *
   * Use it with caution.
   *
   * @default false
   */
  acceptAllDevices?: boolean
}

export declare function useBluetooth(
  options?: UseBluetoothOptions,
): UseBluetoothReturn

export interface UseBluetoothReturn {
  isSupported: Ref<boolean>
  isConnected: ComputedRef<boolean>
  device: Ref<BluetoothDevice | undefined>
  requestDevice: () => Promise<void>
  server: Ref<BluetoothRemoteGATTServer | undefined>
  error: Ref<unknown | null>
}
```
